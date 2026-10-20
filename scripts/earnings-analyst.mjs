/* ============================================================
 * Agent 1: 财报解读官
 *
 * 流程:
 *   1. 从 SEC EDGAR 获取 23 家 JPM 药企的最新 8-K 财报公告
 *   2. 提取新闻稿正文
 *   3. 调用 LLM 提炼为 PHARMA_META 字段格式(双语)
 *   4. 直接 patch finnhub.js 中的 PHARMA_META
 *   5. 输出摘要到 scripts/earnings_summary.md
 *   6. GitHub Actions workflow 负责建 PR
 *
 * 用法:
 *   node scripts/earnings-analyst.mjs              # 全部公司
 *   COMPANIES=礼来,强生 node scripts/earnings-analyst.mjs  # 指定公司
 *
 * 环境变量:
 *   OPENAI_API_KEY  - OpenAI API key (必须, 否则跳过 LLM 提取)
 *   COMPANIES       - 逗号分隔的公司名(可选)
 * ============================================================ */

import { readFileSync, writeFileSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = join(__dirname, '..');
const FINNHUB_JS = join(REPO_ROOT, 'finnhub.js');
const SUMMARY_MD = join(__dirname, 'earnings_summary.md');

const SEC_UA = 'industry-chain-agent contact@lil020.workers.dev';
const OPENAI_MODEL = process.env.OPENAI_MODEL || 'gpt-4o-mini';
const OPENAI_API_KEY = process.env.OPENAI_API_KEY || '';

/* JPM 23 家药企: 公司名 → ticker */
const JPM_PHARMA = {
  '礼来': 'LLY', '强生': 'JNJ', '艾伯维': 'ABBV', '罗氏': 'RHHBY',
  '阿斯利康': 'AZN', '默沙东': 'MRK', '诺华': 'NVS', '诺和诺德': 'NVO',
  '安进': 'AMGN', '吉利德': 'GILD', '辉瑞': 'PFE', '福泰制药': 'VRTX',
  '百时美施贵宝': 'BMY', '赛诺菲': 'SNY', 'GSK': 'GSK', '再生元': 'REGN',
  '默克(德)': 'MKKGY', 'UCB': 'UCB', '武田': 'TAK', '拜耳': 'BAYRY',
  '第一三共': 'DSNKY', '渤健': 'BIIB', '安斯泰来': 'ALPMY',
};

/* ADR 公司 CIK 可能不存在于 SEC, 这些公司跳过 SEC 直接用新闻搜索 */
const NON_US_ADR = new Set(['RHHBY','AZN','NVS','NVO','SNY','GSK','MKKGY','UCB','TAK','BAYRY','DSNKY','BIIB','ALPMY']);

/* ============================================================
 * SEC EDGAR helpers
 * ============================================================ */

async function getTickerCikMap() {
  const res = await fetch('https://www.sec.gov/files/company_tickers.json', {
    headers: { 'User-Agent': SEC_UA },
  });
  if (!res.ok) throw new Error(`SEC ticker map HTTP ${res.status}`);
  const json = await res.json();
  const map = {};
  for (const k of Object.keys(json)) {
    const e = json[k];
    map[e.ticker.toUpperCase()] = String(e.cik_str).padStart(10, '0');
  }
  return map;
}

async function getRecent8Ks(cik, days = 90) {
  const url = `https://data.sec.gov/submissions/CIK${cik}.json`;
  const res = await fetch(url, { headers: { 'User-Agent': SEC_UA } });
  if (!res.ok) throw new Error(`SEC submissions HTTP ${res.status} for CIK ${cik}`);
  const json = await res.json();

  const recent = json.filings?.recent;
  if (!recent) return [];

  const cutoff = Date.now() - days * 86400000;
  const results = [];
  const forms = recent.form || [];
  const dates = recent.filingDate || [];
  const accessions = recent.accessionNumber || [];
  const primaryDocs = recent.primaryDocument || [];

  for (let i = 0; i < forms.length; i++) {
    if (forms[i] !== '8-K') continue;
    const d = new Date(dates[i]);
    if (d.getTime() < cutoff) continue;
    results.push({
      accession: accessions[i],
      date: dates[i],
      primaryDoc: primaryDocs[i],
      url: `https://www.sec.gov/Archives/edgar/data/${parseInt(cik, 10)}/${accessions[i].replace(/-/g, '')}/`,
    });
  }
  return results;
}

async function getPressReleaseText(filing) {
  /* 获取 8-K filing index 页面, 找 exhibit 99 新闻稿 */
  const indexUrl = filing.url + 'index.htm';
  const res = await fetch(indexUrl, { headers: { 'User-Agent': SEC_UA } });
  if (!res.ok) {
    /* 有些 filing 没有 index.htm, 尝试 primaryDoc */
    if (filing.primaryDoc) {
      const docUrl = filing.url + filing.primaryDoc;
      const docRes = await fetch(docUrl, { headers: { 'User-Agent': SEC_UA } });
      if (docRes.ok) return cleanHtml(await docRes.text());
    }
    return null;
  }
  const html = await res.text();

  /* 从 index 页面找 exhibit 99 htm 文件 */
  const exhibits = [];
  const linkRe = /href="([^"]+\.htm)"/gi;
  let m;
  while ((m = linkRe.exec(html)) !== null) {
    const name = m[1];
    if (/ex99|ex-99|press|earn/i.test(name)) {
      exhibits.push(name.startsWith('http') ? name : filing.url + name);
    }
  }

  /* 优先取 exhibit 99, 否则取 primaryDoc */
  let docUrl = exhibits[0];
  if (!docUrl && filing.primaryDoc) {
    docUrl = filing.url + filing.primaryDoc;
  }
  if (!docUrl) return null;

  const docRes = await fetch(docUrl, { headers: { 'User-Agent': SEC_UA } });
  if (!docRes.ok) return null;
  return cleanHtml(await docRes.text());
}

function cleanHtml(html) {
  return html
    .replace(/<script[\s\S]*?<\/script>/gi, '')
    .replace(/<style[\s\S]*?<\/style>/gi, '')
    .replace(/<[^>]+>/g, ' ')
    .replace(/&nbsp;/g, ' ')
    .replace(/&amp;/g, '&')
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&quot;/g, '"')
    .replace(/&#39;/g, "'")
    .replace(/\s+/g, ' ')
    .trim()
    .slice(0, 12000); /* 截断防止超 token */
}

/* ============================================================
 * LLM 提取
 * ============================================================ */

async function extractWithLLM(coName, ticker, pressRelease, existingMeta) {
  if (!OPENAI_API_KEY) {
    console.log(`  ⚠ 跳过 LLM 提取(无 OPENAI_API_KEY): ${coName}`);
    return null;
  }

  const prompt = `You are a pharmaceutical industry analyst. Read the following earnings press release for ${coName} (${ticker}) and extract structured insights as JSON.

Existing metadata for reference (update fields that have new information):
${JSON.stringify(existingMeta, null, 2)}

Extract these fields (only if clearly supported by the press release):
- enStrategy: 1-2 sentence English summary of strategic highlights and forward outlook
- strategy: Chinese translation of the strategy summary
- enMoat: English description of competitive moat / differentiation
- moat: Chinese translation
- enRisks: Pipe-separated (|) list of key risk factors mentioned (English)
- risks: Chinese translation (pipe-separated)
- enAreas: JSON array of therapeutic/strategic areas (English)
- areas: JSON array of therapeutic/strategic areas (Chinese)

Rules:
- Return ONLY valid JSON, no markdown fences, no explanation
- Use double quotes for all strings
- Do NOT include single quotes inside string values (use "can't" not 'can't')
- Keep strategy summaries concise (under 200 chars each)
- If a field is not mentioned, omit it from the JSON

Press release:
${pressRelease}`;

  const res = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${OPENAI_API_KEY}`,
    },
    body: JSON.stringify({
      model: OPENAI_MODEL,
      messages: [{ role: 'user', content: prompt }],
      temperature: 0.3,
      response_format: { type: 'json_object' },
    }),
  });

  if (!res.ok) {
    const err = await res.text();
    console.log(`  ✗ LLM error for ${coName}: ${res.status} ${err.slice(0, 200)}`);
    return null;
  }

  const json = await res.json();
  const content = json.choices?.[0]?.message?.content;
  if (!content) return null;

  try {
    return JSON.parse(content);
  } catch (e) {
    console.log(`  ✗ LLM JSON parse failed for ${coName}: ${e.message}`);
    return null;
  }
}

/* ============================================================
 * finnhub.js patching
 * ============================================================ */

function parsePharmaMeta(content) {
  /* 提取 PHARMA_META 对象 */
  const start = content.indexOf('const PHARMA_META = {');
  if (start === -1) return {};
  /* 找到对应的 }; 结束 */
  let depth = 0;
  let end = start;
  for (let i = start + content.slice(start).indexOf('{'); i < content.length; i++) {
    if (content[i] === '{') depth++;
    if (content[i] === '}') depth--;
    if (depth === 0) { end = i + 1; break; }
  }
  const metaStr = content.slice(start, end);
  /* 用 eval 解析(可信源: 本地文件) */
  const meta = eval('(' + metaStr.replace('const PHARMA_META = ', '') + ')');
  return meta;
}

function escapeSingleQuote(s) {
  return String(s).replace(/'/g, "\u2019");
}

function patchPharmaMeta(content, coName, newFields) {
  /* 每个公司在 finnhub.js 中占一行, 找到该行并替换字段 */
  const lines = content.split('\n');
  const lineIdx = lines.findIndex(l => l.includes(`'${coName}': {`));
  if (lineIdx === -1) {
    console.log(`  ✗ 未找到 ${coName} 在 PHARMA_META 中`);
    return content;
  }

  let line = lines[lineIdx];

  /* 替换各字段 */
  const fieldMap = {
    enStrategy: 'enStrategy',
    strategy: 'strategy',
    enMoat: 'enMoat',
    moat: 'moat',
    enRisks: 'enRisks',
    risks: 'risks',
  };

  for (const [llmKey, metaKey] of Object.entries(fieldMap)) {
    if (newFields[llmKey] != null) {
      const val = escapeSingleQuote(newFields[llmKey]);
      const re = new RegExp(`${metaKey}:'[^']*'`);
      if (re.test(line)) {
        line = line.replace(re, `${metaKey}:'${val}'`);
      } else {
        /* 字段不存在, 在行末添加 */
        line = line.replace(/\}\s*,?\s*$/, `},\n  ${metaKey}:'${val}',`);
        /* 修正: 确保行格式正确 */
      }
    }
  }

  /* 更新 areas / enAreas 数组 */
  if (newFields.enAreas) {
    const arr = newFields.enAreas.map(a => `'${escapeSingleQuote(a)}'`).join(',');
    line = line.replace(/enAreas:\[.*?\]/, `enAreas:[${arr}]`);
  }
  if (newFields.areas) {
    const arr = newFields.areas.map(a => `'${escapeSingleQuote(a)}'`).join(',');
    line = line.replace(/areas:\[.*?\]/, `areas:[${arr}]`);
  }

  lines[lineIdx] = line;
  return lines.join('\n');
}

/* ============================================================
 * 主流程
 * ============================================================ */

async function main() {
  /* 确定要处理的公司 */
  const inputCompanies = process.env.COMPANIES || process.argv[2] || '';
  let companies = inputCompanies
    ? inputCompanies.split(',').map(s => s.trim()).filter(Boolean)
    : Object.keys(JPM_PHARMA);

  console.log(`=== Earnings Analyst Agent ===`);
  console.log(`处理 ${companies.length} 家公司: ${companies.join(', ')}\n`);

  /* 读取当前 finnhub.js */
  let finnhubContent = readFileSync(FINNHUB_JS, 'utf8');
  const pharmaMeta = parsePharmaMeta(finnhubContent);

  /* 获取 ticker → CIK 映射 */
  console.log('获取 SEC EDGAR ticker→CIK 映射...');
  let tickerCikMap = {};
  try {
    tickerCikMap = await getTickerCikMap();
    console.log(`  获取 ${Object.keys(tickerCikMap).length} 个映射\n`);
  } catch (e) {
    console.log(`  ✗ 获取失败: ${e.message}`);
  }

  const updates = [];
  const skipped = [];

  for (const coName of companies) {
    const ticker = JPM_PHARMA[coName];
    if (!ticker) {
      console.log(`✗ ${coName}: 不在 JPM 列表中, 跳过`);
      skipped.push({ name: coName, reason: '不在列表' });
      continue;
    }

    console.log(`\n--- ${coName} (${ticker}) ---`);

    /* ADR 公司可能不在 SEC EDGAR */
    if (NON_US_ADR.has(ticker)) {
      console.log(`  ⚠ ADR 公司, SEC EDGAR 可能无 8-K, 尝试...`);
    }

    const cik = tickerCikMap[ticker];
    if (!cik) {
      console.log(`  ✗ 无 CIK 映射, 跳过`);
      skipped.push({ name: coName, ticker, reason: '无CIK' });
      continue;
    }

    /* 获取最近 90 天的 8-K */
    let filings = [];
    try {
      await sleep(150); /* SEC rate limit */
      filings = await getRecent8Ks(cik);
      console.log(`  最近 90 天 ${filings.length} 个 8-K 文件`);
    } catch (e) {
      console.log(`  ✗ 获取 8-K 失败: ${e.message}`);
      skipped.push({ name: coName, ticker, reason: e.message });
      continue;
    }

    if (filings.length === 0) {
      console.log(`  - 无近期 8-K, 跳过`);
      skipped.push({ name: coName, ticker, reason: '无近期8-K' });
      continue;
    }

    /* 取最新 8-K 的新闻稿 */
    let pressRelease = null;
    for (const f of filings.slice(0, 3)) {
      try {
        await sleep(150);
        pressRelease = await getPressReleaseText(f);
        if (pressRelease && pressRelease.length > 500) break;
      } catch (e) {
        console.log(`  ⚠ 获取新闻稿失败: ${e.message}`);
      }
    }

    if (!pressRelease) {
      console.log(`  ✗ 未获取到新闻稿正文, 跳过`);
      skipped.push({ name: coName, ticker, reason: '无新闻稿正文' });
      continue;
    }

    console.log(`  获取新闻稿 ${pressRelease.length} 字符`);

    /* LLM 提取 */
    const existingMeta = pharmaMeta[coName] || {};
    const extracted = await extractWithLLM(coName, ticker, pressRelease, existingMeta);

    if (!extracted) {
      console.log(`  - 无 LLM 提取结果, 跳过`);
      skipped.push({ name: coName, ticker, reason: 'LLM跳过' });
      continue;
    }

    /* 检查是否有实际变化 */
    const changed = hasChanges(existingMeta, extracted);
    if (!changed) {
      console.log(`  - 无显著变化, 跳过`);
      skipped.push({ name: coName, ticker, reason: '无变化' });
      continue;
    }

    /* Patch finnhub.js */
    finnhubContent = patchPharmaMeta(finnhubContent, coName, extracted);
    console.log(`  ✓ 已更新 PHARMA_META`);

    updates.push({
      name: coName,
      ticker,
      changedFields: Object.keys(extracted).filter(k => extracted[k] != null),
    });
  }

  /* 输出结果 */
  if (updates.length === 0) {
    console.log('\n=== 无需更新 ===');
    writeFileSync(SUMMARY_MD, '# Earnings Analyst Report\n\n本轮无 PHARMA_META 更新。\n\n## 跳过的公司\n\n' +
      skipped.map(s => `- **${s.name}** (${s.ticker||'—'}): ${s.reason}`).join('\n'));
    console.log(`GITHUB_OUTPUT::changed=false`);
    return;
  }

  /* 写入更新后的 finnhub.js */
  writeFileSync(FINNHUB_JS, finnhubContent, 'utf8');

  /* 生成摘要 */
  const summary = generateSummary(updates, skipped);
  writeFileSync(SUMMARY_MD, summary, 'utf8');

  console.log(`\n=== 完成 ===`);
  console.log(`更新 ${updates.length} 家公司`);
  console.log(`跳过 ${skipped.length} 家公司`);
  console.log(`摘要写入 ${SUMMARY_MD}`);
  console.log(`GITHUB_OUTPUT::changed=true`);
}

function hasChanges(existing, extracted) {
  const fields = ['enStrategy', 'strategy', 'enMoat', 'moat', 'enRisks', 'risks'];
  for (const f of fields) {
    if (extracted[f] != null && extracted[f] !== existing[f]) return true;
  }
  if (extracted.enAreas && JSON.stringify(extracted.enAreas) !== JSON.stringify(existing.enAreas)) return true;
  if (extracted.areas && JSON.stringify(extracted.areas) !== JSON.stringify(existing.areas)) return true;
  return false;
}

function generateSummary(updates, skipped) {
  let md = '# Earnings Analyst: PHARMA_META Update\n\n';
  md += `**日期**: ${new Date().toISOString().slice(0, 10)}\n`;
  md += `**更新公司**: ${updates.length} 家 | **跳过**: ${skipped.length} 家\n\n`;

  md += '## 更新内容\n\n';
  md += '| 公司 | Ticker | 更新字段 |\n|---|---|---|\n';
  for (const u of updates) {
    md += `| ${u.name} | ${u.ticker} | ${u.changedFields.join(', ')} |\n`;
  }

  if (skipped.length) {
    md += '\n## 跳过的公司\n\n';
    md += '| 公司 | Ticker | 原因 |\n|---|---|---|\n';
    for (const s of skipped) {
      md += `| ${s.name} | ${s.ticker || '—'} | ${s.reason} |\n`;
    }
  }

  md += '\n---\n';
  md += '> 本 PR 由 Earnings Analyst Agent 自动生成, 内容来自 SEC EDGAR 8-K 新闻稿经 LLM 提取。\n';
  md += '> 请审核后合并。字段格式与 PHARMA_META 一致。\n';

  return md;
}

function sleep(ms) { return new Promise(r => setTimeout(r, ms)); }

main().catch(e => {
  console.error('Fatal:', e);
  process.exit(1);
});
