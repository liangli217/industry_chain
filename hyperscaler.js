/**
 * Hyperscaler CAPEX Tracker — 数据模块
 * 季度资本开支（含融资租赁）+ 指引 + 营收
 *
 * 数据来源: 各公司财报发布 / Earnings Call
 * 更新方式: Agent 从财报新闻/SEC filing 自动更新
 *
 * 命名约定: capex 单位 $B (十亿美元), calendar quarter (日历季度)
 *           MSFT 财年 7/1 起, 已转换为日历季度
 *           "含融资租赁" 口径用于 MSFT/AMZN/META, GOOGL 为现金口径
 */

/* ---- 颜色 ---- */
const HC_COLORS = {
  msft:'#4fc9bd',
  amzn:'#e8a44c',
  googl:'#b98ce6',
  meta:'#6cb4f0',
  aapl:'#e87a6c'
};

/* ---- 季度标签 ---- */
const HC_QUARTERS = [
  '23Q4','24Q1','24Q2','24Q3','24Q4',
  '25Q1','25Q2','25Q3','25Q4','26Q1'
];

/* ---- 公司数据 ---- */
const HC_DATA = [
  {
    name:'Microsoft', cn:'微软', ticker:'MSFT',
    cloud:'Azure',
    color:HC_COLORS.msft,
    // MSFT FY24 Q2-Q4 + FY25 Q1-Q4 + FY26 Q1 (日历季度)
    // "capex incl. finance leases" 口径
    capex:[11.1, 11.0, 13.9, 20.0, 22.3, 17.0, 24.2, 34.9, null, null],
    // 季度营收 ($B)
    revenue:[62.0, 61.9, 64.7, 65.6, 69.6, 70.1, 75.3, 77.7, null, null],
    fyGuidance:'FY2026 约$190B (capex incl. finance leases)',
    fyGuidanceCapex:190,
    note:'Azure + OpenAI 驱动; FY26 Q1 capex $34.9B (+74% YoY)'
  },
  {
    name:'Amazon', cn:'亚马逊', ticker:'AMZN',
    cloud:'AWS',
    color:HC_COLORS.amzn,
    // "capital investments" = cash capex + finance leases
    capex:[null, null, null, null, 26.3, 20.0, 17.6, 23.0, null, null],
    revenue:[169.9, 143.3, 148.0, 158.9, 187.8, 155.7, 167.7, 180.2, null, null],
    fyGuidance:'2026 约$200B (capital investments)',
    fyGuidanceCapex:200,
    note:'AWS Trainium2 + Bedrock 需求; 2025 capex 同比+$50B'
  },
  {
    name:'Alphabet', cn:'谷歌', ticker:'GOOGL',
    cloud:'GCP',
    color:HC_COLORS.googl,
    // 现金口径 "purchases of property and equipment"
    capex:[null, null, 13.2, 13.1, 14.3, 17.2, 22.4, 24.0, 27.9, 35.7],
    revenue:[86.3, 80.5, 84.7, 88.3, 96.5, 90.2, 84.7+11.7, 88.3+11.7, null, 109.9],
    fyGuidance:'2026 $195-205B (updated from $175-185B)',
    fyGuidanceCapex:200,
    note:'Cloud +63% YoY; TPU v8 发布; 2027 capex 将大幅增加'
  },
  {
    name:'Meta', cn:'Meta', ticker:'META',
    cloud:'Reality Labs',
    color:HC_COLORS.meta,
    // "capex incl. principal payments on finance leases"
    capex:[null, null, null, null, null, 13.7, 17.0, 19.4, 22.1, null],
    revenue:[40.1, 36.5, 39.1, 40.6, 48.4, 42.3, 47.5, 51.2, 59.9, null],
    fyGuidance:'2026 $115-135B (up from prior estimate)',
    fyGuidanceCapex:125,
    note:'FY2025 capex $72.2B (+$30B YoY); Superintelligence Labs 大举投入'
  }
];

/* ---- 派生指标 ---- */
function getLatestCapex(co){
  const arr = co.capex.filter(v=>v!=null);
  return arr.length ? arr[arr.length-1] : null;
}
function getPrevYearCapex(co){
  const vals = co.capex.filter(v=>v!=null);
  if(vals.length < 5) return null;
  return vals[vals.length-5];
}
function getCapexYoy(co){
  const latest = getLatestCapex(co);
  const prev = getPrevYearCapex(co);
  if(!latest || !prev) return null;
  return ((latest/prev-1)*100).toFixed(0);
}
function getTotalLatest(){
  return HC_DATA.reduce((s,co)=>{
    const v=getLatestCapex(co);
    return s+(v||0);
  },0);
}
function getTotalGuidance(){
  return HC_DATA.reduce((s,co)=>s+(co.fyGuidanceCapex||0),0);
}

/* ---- 指引表 ---- */
function getGuidanceRows(){
  return HC_DATA.map(co=>{
    const latest=getLatestCapex(co);
    const yoy=getCapexYoy(co);
    return {
      name:co.cn+' '+co.name,
      cloud:co.cloud,
      latestCapex:latest,
      yoy:yoy?`${yoy}%`:'—',
      guidance:co.fyGuidance,
      note:co.note
    };
  });
}
