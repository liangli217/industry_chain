# 合并 company.html + pharma.html，按 8 段 IA 重建公司详情页

## Context

用户提供了完整的公司分析页信息架构设计（8 个 Section），需要将现有的 company.html（通用详情页）和 pharma.html（JPM 23 列表页）合并为一个统一的详情页。决策：删除 pharma.html，列表移入 industry.html；全部免费无付费墙；新 Finnhub 端点先做 UI 骨架。

## 涉及文件

| 文件 | 动作 |
|---|---|
| `company.html` | **完全重建** — 8 段 IA |
| `finnhub.js` | **追加** 3 个新 fetch 函数（骨架） |
| `industry.html` | **微改** — "查看全部"链接改向 company.html |
| `pharma.html` | **删除** |

## 实施步骤

### Step 1: finnhub.js — 新增 fetch 函数骨架

追加 3 个函数，结构同现有 `fetchQuote/fetchMetrics`，但暂时不接数据，返回 `null`：

```
fetchTargetPrice(ticker)   → /stock/price-target (分析师一致目标价)
fetchRecommendations(ticker) → /stock/recommendation (买入/持有/卖出)
fetchNews(ticker)           → /company-news (公司新闻)
```

每个函数走 `FINNHUB_BASE` 代理 + 5 分钟缓存，失败返回 `null`。

### Step 2: company.html — 8 段 IA 重建

**数据源映射：**

| Section | 数据来源 | 新/旧 |
|---|---|---|
| ① Topbar | URL params + TICKER_MAP | 旧 |
| ② Hero 行情 | fetchQuote | 旧，精简为 5 个关键数字 |
| ③ 产业链定位 | BIO_NODES + URL params | 旧数据，新 UI |
| ④ 财务健康度 | fetchMetrics | 旧，改为双组网格 |
| ⑤ 分析师信号 | fetchTargetPrice/fetchRecommendations | 新骨架 |
| ⑥ 风险 & 催化 | PHARMA_META.risks + chainData | 旧数据，新双栏 |
| ⑦ 横向延伸 | BIO_NODES.share + URL params | 旧数据，新卡片 |
| ⑧ 相关新闻 | fetchNews | 新骨架 |

**各 Section 实现要点：**

#### ① Topbar
- 返回产业链按钮（保持 `href="industry.html"`，已接 sessionStorage）
- 公司名中英 + ticker + 行业标签
- 自选按钮（localStorage `watchlist` 数组，toggle 星标）
- 分享按钮（`navigator.share()` + fallback 复制 URL）

#### ② Hero 行情概览
- 精简为 5 个大字号数字：股价 + 涨跌幅 / 市值 / P/E(TTM) / 52周位置 / 成交量
- 52 周位置：用 quote 的 `h`/`l`（日线）做迷你条形图（现价在当日高低间的位置），标注"日内"。真 52 周数据待 API 确认后升级
- Day High/Low、Prev Close 等折叠到 tooltip

#### ③ 产业链定位 ⭐
- **仅 bio 公司**有完整数据（BIO_NODES 已在 company.html 中）
- **非 bio 公司**：显示行业标签 + 节点名，竞争格局区域显示骨架
- 三卡：环节规模 / 环节增速 / 本司份额（从 `share` 数组查找 `co` 名）
- 竞争格局横向条形图：遍历 `share` 数组，本司行高亮 + 箭头
- 竞品可点击 → 跳转 `company.html?name=xxx&ind=bio&node=xxx`
- 底部红色卡片：`bottleneck` 字段

#### ④ 财务健康度
- 双组网格布局：盈利质量（毛利率/净利率/ROE/营收增速）+ 估值（P/E/Forward P/E/PEG/P/B/EV-EBITDA/P/S/股息率）
- 营收增速颜色：≥10% 绿，<3% 红
- 每卡右下角"vs 行业中位数"标记 — 先做 UI 骨架（无数据时隐藏）

#### ⑤ 分析师信号 ⭐
- 一致目标价 + 距现价空间（大数字 + 百分比颜色）
- 买入/持有/卖出条形堆叠图
- 目标价历史趋势 / 分券商明细 / 评级变动时间线 — UI 骨架区域（"数据即将上线"）
- 函数 `fetchTargetPrice` / `fetchRecommendations` 返回 `null` 时显示骨架

#### ⑥ 风险 & 催化
- 左栏 风险（红色边框）：`PHARMA_META[coName].risks` + `BIO_NODES[node].bottleneck`
- 右栏 催化（绿色边框）：近期事件（财报日等）+ `BIO_NODES[node].logic`
- 非 bio 公司：仅显示通用风险提示

#### ⑦ 横向延伸
- 同环节其他公司：从 `BIO_NODES[node].share` 取前 3-4 家（非"其他"），渲染可点击卡片
- 上下游环节：从 URL params `ind` + `node` 推断，暂时显示骨架

#### ⑧ 相关新闻
- 3-5 条标题 + 时间列表（`fetchNews` 返回 null 时显示"暂无新闻"）

### Step 3: industry.html — 更新链接

- 将 `pharma.html` 链接改为 `company.html?ind=bio&mode=list`（或直接保留 bio 产业链节点列表，不再需要独立列表页入口）
- line 1145 的 `href="pharma.html"` 改为 `href="industry.html"`（回到生物医药产业链）

### Step 4: 删除 pharma.html

直接删除文件。

## 验证

1. 浏览器打开 `company.html?name=礼来&ind=bio&node=化学药(创新药/仿制药)` — 验证 8 个 Section 全部渲染
2. 浏览器打开 `company.html?name=汇川技术&ind=robot&node=运动控制芯片·控制器(小脑)` — 验证 fallback 页（无 ticker）仍可用
3. 打开 `industry.html` 点"半导体" → 点公司 chip → 验证跳转到新 company.html
4. 检查 bio 产业链的"查看全部"链接不再指向 pharma.html
5. 控制台无 JS 报错
