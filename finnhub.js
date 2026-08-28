/* ============================================================
 * Finnhub API 集成模块
 * 免费层: 60次/分钟, 实时美股行情, 财报surprise, 公司profile, 财务指标
 * 注册: https://finnhub.io/register
 * ============================================================ */

const FINNHUB_API_KEY = 'da8k5ghr01qo86chau50da8k5ghr01qo86chau5g'; // ← 替换为你的API Key
const FINNHUB_BASE = 'https://finnhub.io/api/v1';

/* 公司名 → 股票代码映射 (23家JPM药企 + 其他) */
const TICKER_MAP = {
  '礼来':'LLY','强生':'JNJ','艾伯维':'ABBV','罗氏':'RHHBY',
  '阿斯利康':'AZN','默沙东':'MRK','诺华':'NVS','诺和诺德':'NVO',
  '安进':'AMGN','吉利德':'GILD','辉瑞':'PFE','福泰制药':'VRTX',
  '百时美施贵码':'BMY','赛诺菲':'SNY','GSK':'GSK','再生元':'REGN',
  '默克(德)':'MKKGY','UCB':'UCB','武田':'TAK','拜耳':'BAYRY',
  '第一三共':'DSNKY','渤健':'BIIB','安斯泰来':'ALPMY'
};

/* 23家药企元数据(非财务数据,来自JPM 2026演讲总结) */
const PHARMA_META = {
  '礼来': { areas:['肥胖/代谢','肿瘤','神经'], strategy:'全球肥胖/代谢龙头,Tirzepatide领涨;NVIDIA AI合作,研发速度领先同行3.5年;$55B投资13个生产基地', moat:'原创靶点与全球临床', risks:'GLP-1竞争加剧(诺和诺德)|肥胖药定价压力|Tirzepatide专利悬崖' },
  '强生': { areas:['肿瘤','免疫','神经','心血管'], strategy:'全球最大综合医疗健康公司,肿瘤/免疫/神经/心血管全布局;~12款新产品即将上市', moat:'创新管线执行力', risks:'诉讼风险(Talc)|Keytruda竞争|专利悬崖' },
  '艾伯维': { areas:['免疫','肿瘤'], strategy:'免疫龙头,Skyrizi+Rinvoq 2027合计$31B;肿瘤管线被低估;收购RemeGen PD-1/VEGF双抗', moat:'免疫 franchises 持续性', risks:'Humira专利悬崖持续|免疫竞争加剧|肿瘤管线验证' },
  '罗氏': { areas:['肿瘤','眼科','肥胖'], strategy:'全球肿瘤龙头,2030目标肥胖前三;Vabysmo+Ocrevus锚定增长;2026年10个III期读出', moat:'内部研发引擎', risks:'肿瘤竞争加剧|肥胖管线风险|定价压力' },
  '阿斯利康': { areas:['肿瘤','心血管','呼吸','罕见病'], strategy:'2030营收目标从$67B上调至$80B;104个III期进行中;收购Modela AI推进计算病理', moat:'管线深度与执行力', risks:'肿瘤竞争|专利悬崖|中国集采风险' },
  '默沙东': { areas:['肿瘤','呼吸','感染','免疫'], strategy:'Keytruda 2028 LOE前转型;新增长引擎>$70B机会;~80个III期,>20个潜在重磅新品', moat:'Keytruda后继管线', risks:'Keytruda 2028专利悬崖|肿瘤竞争|BD整合风险' },
  '诺华': { areas:['心血管','免疫','神经','肿瘤'], strategy:'+7% CAGR(2019-2024);8个潜在重磅资产;收购Avidity(AOC技术)', moat:'8大重磅资产兑现', risks:'Entresto专利悬崖|心血管竞争|收购整合' },
  '诺和诺德': { areas:['肥胖','糖尿病','罕见病'], strategy:'口服Wegovy首上市(16.6%减重);新CEO Doustdar战略重置;CagriSema~23%减重', moat:'CagriSema与Amycretin兑现', risks:'礼来GLP-1竞争|口服药接受度|定价压力' },
  '安进': { areas:['代谢','心血管','生物类似药'], strategy:'6大增长引擎;MariTide月度GLP-1;Repatha心血管数据强劲;生物类似药第三波', moat:'MariTide数据兑现', risks:'MariTide安全性|GLP-1竞争|生物类似药价格战' },
  '吉利德': { areas:['HIV','肿瘤','细胞治疗'], strategy:'HIV领导力延续至2040s;Trodelvy ADC扩张;anito-cel CAR-T提交FDA;10年无专利悬崖', moat:'Trodelvy与anito-cel兑现', risks:'HIV竞争|ADC数据风险|CAR-T商业化' },
  '辉瑞': { areas:['代谢','肿瘤','疫苗'], strategy:'2026营收$59.5-62.5B;Metsera超长效GLP-1;$7.2B成本节约;20+III期启动', moat:'Seagen ADC管线兑现', risks:'COVID营收悬崖|GLP-1竞争|Seagen整合' },
  '福泰制药': { areas:['囊性纤维化','基因治疗','疼痛'], strategy:'囊性纤维化龙头(2040专利保护);CASGEVY基因治疗>$100M;JOURNAVX疼痛药;~$12B现金', moat:'疼痛与肾管线兑现', risks:'CF市场饱和|疼痛药接受度|基因治疗竞争' },
  '百时美施贵码': { areas:['免疫','精神分裂','心血管'], strategy:'增长组合+17% YoY;COBENFY(精神分裂首创药)扩张;2030前10+新品上市', moat:'COBENFY与CELMoD兑现', risks:'Revlimid专利悬崖|免疫竞争|COBENFY接受度' },
  '赛诺菲': { areas:['免疫','罕见病','疫苗'], strategy:'AI驱动生物药;ALTUVIIIO 2025破十亿;收购Blueprint/Dynavax;Tolebrutinib待EU审批', moat:'BD整合与管线兑现', risks:'Dupixent竞争|疫苗需求波动|BD整合' },
  'GSK': { areas:['疫苗','HIV','呼吸'], strategy:'疫苗+HIV+呼吸;2025年5/5获批;收购IDRx($1B)布局GIST;AI合作对冲专利悬崖', moat:'HIV与camlipixant兑现', risks:'HIV竞争(吉利德)|疫苗需求波动|专利悬崖' },
  '再生元': { areas:['眼科','免疫'], strategy:'科学优先;~$6B R&D;EYLEA HD+66% YoY;~45个临床项目瞄准$200B市场', moat:'fianlimab与cemdisiran兑现', risks:'EYLEA LOE|BD谨慎|Dupixent依赖' },
  '默克(德)': { areas:['生命科学','医疗','电子'], strategy:'三大板块:医疗/生命科学/电子;生物工艺解决方案服务生物药制造;Bavencio+Mavenclad', moat:'生物工艺需求复苏', risks:'生物工艺周期性|肿瘤竞争|电子业务波动' },
  'UCB': { areas:['神经','免疫'], strategy:'神经+免疫专科;bimekizumab(IL-17A/F)扩张;EVENITY骨质疏松(与安进合作)', moat:'bimekizumab适应症扩张', risks:'bimekizumab竞争(诺华)|癫痫仿制|骨质疏松市场' },
  '武田': { areas:['消化','罕见病','神经','肿瘤'], strategy:'4大核心领域创新驱动;Entyvio IBD领导力;罕见病(溶酶体贮积症);Vyvanse ADHD', moat:'管线推进与外部创新', risks:'Entyvio生物类似药|专利悬崖|日本市场' },
  '拜耳': { areas:['肿瘤','心血管'], strategy:'制药 turnaround;2026最后平年,2027起中个位数增长;Nubeqa €1.7B;asundexian III期', moat:'asundexian与Kerendia兑现', risks:'Xarelto LOE|Eylea LOE|农业业务拖累' },
  '第一三共': { areas:['肿瘤(ADC)'], strategy:'DXd ADC平台核心差异化;与阿斯利康合作Enhertu/Dato-DXd;FY2026营收~¥2.1T(+11%)', moat:'DXd平台新靶点扩张', risks:'ADC竞争加剧|合作依赖阿斯利康|管线验证' },
  '渤健': { areas:['阿尔茨海默','神经'], strategy:'转型完成($1B节约);LEQEMBI阿尔茨海默;4个首创药上市;R&D降低26%', moat:'LEQEMBI与litifilimab兑现', risks:'MS营收下滑|LEQEMBI渗透率|litifilimab数据' },
  '安斯泰来': { areas:['肿瘤','泌尿','移植'], strategy:'VALUE框架;PADCEV膀胱癌扩张;XTANDI前列腺癌;基因治疗(AT132);合作战略', moat:'PADCEV与基因治疗兑现', risks:'PADCEV竞争|XTANDI仿制|基因治疗风险' }
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
      price: quote.c,
      change: quote.d,
      changePct: quote.dp,
      high: quote.h,
      low: quote.l,
      prevClose: quote.pc,
      open: quote.o,
      marketCap: profile.marketCapitalization,
      pe: profile.pe,
      peTTM: profile.peTTM,
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

/* 获取财务指标 (revenue growth, margins, ROE, EPS等) */
async function fetchMetrics(ticker) {
  const cached = getCached('metric:' + ticker);
  if (cached) return cached;
  try {
    const res = await fetch(`${FINNHUB_BASE}/stock/metric?symbol=${ticker}&metric=all&token=${FINNHUB_API_KEY}`);
    const json = await res.json();
    const m = json.metric || {};
    const data = {
      grossMargin: m.grossMarginTTM,           // 毛利率%
      netMargin: m.netProfitMarginTTM,          // 净利率%
      operatingMargin: m.operatingMarginTTM,    // 运营利润率%
      revenueGrowth: m.revenueGrowthTTMYoy,      // 营收增速% (TTM YoY)
      revenueGrowth3Y: m.revenueGrowth3Y,       // 营收CAGR 3年%
      epsTTM: m.epsTTM,                         // 每股收益
      epsGrowth: m.epsGrowthTTMYoy,              // EPS增速%
      roe: m.roeTTM,                            // ROE%
      roa: m.roaTTM,                            // ROA%
      peTTM: m.peTTM,                           // PE TTM
      forwardPE: m.forwardPE,                   // 前瞻PE
      peg: m.pegTTM,                            // PEG
      pb: m.pb,                                 // P/B
      evEbitda: m.evEbitdaTTM,                  // EV/EBITDA
      ps: m.psTTM,                              // P/S
      beta: m.beta,                              // Beta
      dividendYield: m.currentDividendYieldTTM,  // 股息率%
      payoutRatio: m.payoutRatioTTM,            // 派息率%
      high52w: m['52WeekHigh'],                 // 52周高
      low52w: m['52WeekLow'],                    // 52周低
      priceReturn52w: m['52WeekPriceReturnDaily'], // 52周回报%
      revenuePerShare: m.revenuePerShareTTM,     // 每股营收
      cashFlowPerShare: m.cashFlowPerShareTTM,   // 每股现金流
      debtToEquity: m['totalDebt/totalEquityQuarterly'], // 债务/权益
      currentRatio: m.currentRatioQuarterly,     // 流动比率
      ts: Date.now()
    };
    setCached('metric:' + ticker, data);
    return data;
  } catch (e) {
    console.warn('Finnhub metrics failed for', ticker, e);
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

/* 获取公司完整数据(quote + metrics + earnings合并) */
async function fetchCompanyData(ticker) {
  const [quote, metrics, earnings] = await Promise.all([
    fetchQuote(ticker),
    fetchMetrics(ticker),
    fetchEarnings(ticker)
  ]);
  return { quote, metrics, earnings };
}

/* 格式化市值 */
function fmtMcap(m) {
  if (!m) return '—';
  if (m >= 1e6) return '$' + (m / 1e6).toFixed(1) + '万亿';
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

/* 格式化百分比 */
function fmtPct(p) {
  if (p === null || p === undefined) return '—';
  return p.toFixed(1) + '%';
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
  const batches = [];
  for (let i = 0; i < tasks.length; i += 10) {
    batches.push(tasks.slice(i, i + 10));
  }
  for (const batch of batches) {
    await Promise.all(batch.map(t => t));
  }
  return results;
}
