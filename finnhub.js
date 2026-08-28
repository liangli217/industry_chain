/* ============================================================
 * Finnhub API 集成模块
 * 免费层: 60次/分钟, 实时美股行情, 财报surprise, 公司profile
 * 注册: https://finnhub.io/register
 * ============================================================ */

const FINNHUB_API_KEY = 'da8k5ghr01qo86chau50da8k5ghr01qo86chau5g'; // ← 替换为你的API Key
const FINNHUB_BASE = 'https://finnhub.io/api/v1';

/* 公司名 → 股票代码映射 (23家JPM药企 + 其他) */
const TICKER_MAP = {
  '礼来':'LLY','强生':'JNJ','艾伯维':'ABBV','罗氏':'RHHBY',
  '阿斯利康':'AZN','默沙东':'MRK','诺华':'NVS','诺和诺德':'NVO',
  '安进':'AMGN','吉利德':'GILD','辉瑞':'PFE','福泰制药':'VRTX',
  '百时美施贵宝':'BMY','赛诺菲':'SNY','GSK':'GSK','再生元':'REGN',
  '默克(德)':'MKKGY','UCB':'UCB','武田':'TAK','拜耳':'BAYRY',
  '第一三共':'DSNKY','渤健':'BIIB','安斯泰来':'ALPMY'
};

/* 简易缓存(5分钟内不重复请求) */
const cache = new Map();
const CACHE_TTL = 5 * 60 * 1000;

function getCached(key) {
  const entry = cache.get(key);
  if (entry && Date.now() - entry.ts < CACHE_TTL) return entry.data;
  return null;
}
function setCached(key, data) {
  cache.set(key, { ts: Date.now(), data });
}

/* 获取实时行情 (price, change%, market cap, PE等) */
async function fetchQuote(ticker) {
  const cached = getCached('quote:' + ticker);
  if (cached) return cached;
  try {
    const [quoteRes, profileRes] = await Promise.all([
      fetch(`${FINNHUB_BASE}/quote?symbol=${ticker}&token=${FINNHUB_API_KEY}`),
      fetch(`${FINNHUB_BASE}/stock/profile2?symbol=${ticker}&token=${FINNHUB_API_KEY}`)
    ]);
    const quote = await quoteRes.json();
    const profile = await profileRes.json();
    const data = {
      ticker,
      price: quote.c,           // 当前价格
      change: quote.d,          // 涨跌额
      changePct: quote.dp,      // 涨跌幅%
      high: quote.h,            // 日高
      low: quote.l,             // 日低
      prevClose: quote.pc,      // 前收盘
      open: quote.o,            // 开盘
      marketCap: profile.marketCapitalization,  // 市值(百万美元)
      pe: profile.pe,            // 市盈率
      peTTM: profile.peTTM,      // TTM市盈率
      dividend: profile.dividend,
      industry: profile.finnhubIndustry,
      exchange: profile.exchange,
      name: profile.name,
      ts: Date.now()
    };
    setCached('quote:' + ticker, data);
    return data;
  } catch (e) {
    console.warn('Finnhub quote failed for', ticker, e);
    return null;
  }
}

/* 获取财报surprise (EPS实际vs预期, 最近4个季度) */
async function fetchEarnings(ticker) {
  const cached = getCached('earn:' + ticker);
  if (cached) return cached;
  try {
    const res = await fetch(`${FINNHUB_BASE}/stock/earnings?symbol=${ticker}&token=${FINNHUB_API_KEY}`);
    const data = await res.json();
    setCached('earn:' + ticker, data);
    return data;
  } catch (e) {
    console.warn('Finnhub earnings failed for', ticker, e);
    return null;
  }
}

/* 格式化市值 */
function fmtMcap(m) {
  if (!m) return '—';
  if (m >= 1e6) return '$' + (m / 1e6).toFixed(0) + '万亿';  // million USD → 万亿
  if (m >= 1e3) return '$' + (m / 1e3).toFixed(0) + '亿';
  return '$' + m.toFixed(0) + '百万';
}

/* 格式化价格 */
function fmtPrice(p) {
  if (!p || p === 0) return '—';
  return '$' + p.toFixed(2);
}

/* 格式化涨跌幅 */
function fmtChange(pct) {
  if (pct === null || pct === undefined) return '';
  const sign = pct >= 0 ? '+' : '';
  const cls = pct >= 0 ? 'up' : 'down';
  return { text: sign + pct.toFixed(2) + '%', cls };
}

/* 根据公司名获取ticker */
function getTicker(companyName) {
  return TICKER_MAP[companyName] || null;
}

/* 批量获取行情(控制并发避免限流) */
async function fetchQuotesBatch(companyNames) {
  const results = {};
  const tasks = companyNames.map(async (name) => {
    const ticker = getTicker(name);
    if (!ticker) return;
    results[name] = await fetchQuote(ticker);
  });
  // 分批处理,每批10个(避免60次/分钟限制)
  const batches = [];
  for (let i = 0; i < tasks.length; i += 10) {
    batches.push(tasks.slice(i, i + 10));
  }
  for (const batch of batches) {
    await Promise.all(batch.map(t => t));
  }
  return results;
}
