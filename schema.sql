-- ============================================================
-- 链脉 · 产业链分析平台 — Supabase 数据表
-- 表名:companies  (每行一家公司,所属节点投资上下文;财务数据由 Finnhub 实时 API 提供)
-- ============================================================

CREATE TABLE companies (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,       -- 公司名
  industry TEXT NOT NULL,          -- 产业 key (robot/ev/chip/solar)
  industry_name TEXT,              -- 产业中文名
  node_id TEXT,                    -- 所属节点 ID
  node_name TEXT,                  -- 环节名
  tier TEXT,                       -- 层级 (up/mid/down)
  code TEXT,                       -- 股票代码
  mkt TEXT,                        -- 交易所
  description TEXT,                -- 公司描述
  risks JSONB,                     -- 风险数组
  size TEXT,                       -- 环节市场规模
  growth TEXT,                     -- 环节增速
  logic TEXT,                      -- 投资逻辑
  bottleneck TEXT,                 -- 卡点
  moat INT,                        -- 护城河评级 1-3
  sup TEXT,                        -- 供给格局
  supc TEXT,                        -- 供给颜色分类
  why TEXT,                        -- 供给说明
  share JSONB,                     -- 市场份额数据
  peers JSONB                      -- 同环节公司列表
);

-- ============================================================
-- 数据导入 (60 家公司)
-- ============================================================

-- ===== 机器人产业 (14 家) =====

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('绿的谐波', 'robot', '机器人', 'u01', '谐波减速器', 'up', '688017', '科创板', '国产谐波减速器龙头,受益人形机器人放量', '["谐波减速器齿形与材料工艺壁垒","人形机器人量产进度不及预期","哈默纳科等海外巨头价格竞争"]', '约80亿', '~30%', '国产替代+人形放量核心受益,价值量高', '齿形与材料工艺,超微型仍难点', 3, '日本主导 58%', 'race', '旋转关节核心,技术壁垒高、供给高度集中(日本哈默纳科全球约 58%);国产绿的谐波全球第二(约 15%),国内国产化率已达 70%+,替代成效显著。', '[{"n":"哈默纳科","s":58},{"n":"绿的谐波","s":15},{"n":"来福谐波","s":8},{"n":"其他","s":19}]', '["双环传动","中大力德","来福谐波(未上市)","哈默纳科(日)"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('双环传动', 'robot', '机器人', 'u01', '谐波减速器', 'up', '002472', '深交所', '齿轮与 RV 减速器龙头,新能源+机器人双轮驱动', '["汽车齿轮价格竞争","RV减速器国产替代节奏","原材料价格波动"]', '约80亿', '~30%', '国产替代+人形放量核心受益,价值量高', '齿形与材料工艺,超微型仍难点', 3, '日本主导 58%', 'race', '旋转关节核心,技术壁垒高、供给高度集中(日本哈默纳科全球约 58%);国产绿的谐波全球第二(约 15%),国内国产化率已达 70%+,替代成效显著。', '[{"n":"哈默纳科","s":58},{"n":"绿的谐波","s":15},{"n":"来福谐波","s":8},{"n":"其他","s":19}]', '["绿的谐波","中大力德","来福谐波(未上市)","哈默纳科(日)"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('汇川技术', 'robot', '机器人', 'u14', '运动控制芯片·控制器(小脑)', 'up', '300124', '创业板', '工业自动化与运动控制龙头,通用伺服份额第一', '["宏观经济下行拖累工业自动化需求","外资品牌价格竞争","新能源车业务增速放缓"]', '约50亿', '~25%', '实时运动控制核心,国产化推进中', NULL, 2, '国产较强', 'cn', '实时运动控制("小脑"),国产汇川、埃斯顿在工业级控制器上较强,自主度较高。', NULL, '["埃斯顿","固高科技","英特尔(美)"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('禾川科技', 'robot', '机器人', 'u04', '无框力矩电机', 'up', '688320', '科创板', '伺服系统与无框力矩电机厂商,机器人受益', '["伺服市场份额竞争激烈","毛利率承压","人形机器人订单不确定性"]', '约70亿', '~35%', '单台用量28个,量产降本核心受益', NULL, 2, '国产崛起', 'cn', '关节动力源,国产步科/禾川单价较海外低约 30%,量产阶段成本优势明显,技术壁垒中等。', '[{"n":"科尔摩根/Maxon","s":30},{"n":"步科股份","s":10},{"n":"禾川科技","s":8},{"n":"其他","s":52}]', '["步科股份","鸣志电器","昊志机电"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('固高科技', 'robot', '机器人', 'u14', '运动控制芯片·控制器(小脑)', 'up', '301510', '创业板', '运动控制芯片与系统方案商,机器人小脑受益', '["运动控制芯片国产替代节奏","客户集中度高","研发投入大"]', '约50亿', '~25%', '实时运动控制核心,国产化推进中', NULL, 2, '国产较强', 'cn', '实时运动控制("小脑"),国产汇川、埃斯顿在工业级控制器上较强,自主度较高。', NULL, '["汇川技术","埃斯顿","英特尔(美)"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('鸣志电器', 'robot', '机器人', 'u04', '无框力矩电机', 'up', '603728', '上交所', '步进电机与空心杯电机龙头,灵巧手受益', '["空心杯电机与 Maxon 技术差距","下游需求波动","汇率波动影响海外业务"]', '约70亿', '~35%', '单台用量28个,量产降本核心受益', NULL, 2, '国产崛起', 'cn', '关节动力源,国产步科/禾川单价较海外低约 30%,量产阶段成本优势明显,技术壁垒中等。', '[{"n":"科尔摩根/Maxon","s":30},{"n":"步科股份","s":10},{"n":"禾川科技","s":8},{"n":"其他","s":52}]', '["步科股份","禾川科技","昊志机电"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('兆威机电', 'robot', '机器人', 'u05', '空心杯电机', 'up', '003021', '深交所', '微型传动系统厂商,灵巧手总成核心受益', '["消费电子需求波动","灵巧手量产节奏","精密齿轮加工壁垒"]', '约30亿', '~25%', '灵巧手手指驱动,国产进入头部供应链', '线圈工艺与微型化精度', 2, '海外领先 · 国产追赶', 'race', '灵巧手微型驱动,瑞士 Maxon 技术领先;国产鸣志已进入头部供应链,壁垒中等。', '[{"n":"Maxon/Faulhaber","s":65},{"n":"鸣志电器","s":10},{"n":"兆威机电","s":5},{"n":"其他","s":20}]', '["鸣志电器","Maxon(瑞士)"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('奥普特', 'robot', '机器人', NULL, NULL, NULL, '688686', '科创板', '机器视觉核心部件厂商,3D 视觉受益', '["机器视觉海外巨头竞争","下游 3C 需求波动","技术迭代风险"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('宇树科技', 'robot', '机器人', 'u16', '运动控制算法(小脑)', 'up', '未上市', '一级市场', '四足与人形机器人本体厂商,运动控制领先', '["尚未盈利","人形机器人商业化不确定","融资与估值波动"]', '约15亿', '~60%', '全身协调与步态平衡,自研本体优势', NULL, 1, '分散 · 各厂自研', 'race', '全身协调与平衡控制,多为本体厂自研、路线分散,尚未形成独立的护城河环节。', NULL, '["逐际动力(未上市)","傅利叶"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('优必选', 'robot', '机器人', 'm2', '人形机器人(国产)', 'mid', '09880', '港交所', '国产人形机器人本体第一股,商业化探索中', '["持续亏损","商业化落地节奏","海外市场竞争"]', '约200亿', '~100%', '量产能力全球领先,商业化加速', NULL, 2, '中国量产领先', 'cn', '依托完整供应链,中国整机量产与成本控制全球领先(约海外一半),壁垒中等偏上。', NULL, '["智元机器人","宇树科技","傅利叶","众擎机器人","银河通用"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('贝斯特', 'robot', '机器人', NULL, NULL, NULL, '300580', '创业板', '精密零部件厂商,布局行星滚柱丝杠', '["汽车零部件主业需求波动","丝杠量产节奏","新业务投入大"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('恒立液压', 'robot', '机器人', 'u03', '行星滚柱丝杠', 'up', '601100', '上交所', '液压元件龙头,布局行星滚柱丝杠与精密轴承', '["工程机械周期波动","丝杠新业务不确定性","海外贸易摩擦"]', '约50亿', '~40%', '国产化机会最大环节之一,价值量最高', '磨床工序壁垒最高,良率仅60%', 3, '欧美主导 · 卡脖子', 'risk', '把旋转转直线的核心机械件,磨床工序壁垒极高;欧美 CR5 超 80%,国产良率约 60%(海外 85%+),是当前人形量产最硬的卡点。', '[{"n":"GSA/Rollvis","s":55},{"n":"北特科技","s":8},{"n":"恒立液压","s":6},{"n":"其他","s":31}]', '["北特科技","五洲新春","鼎智科技","新剑传动(未上市)"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('五洲新春', 'robot', '机器人', 'u03', '行星滚柱丝杠', 'up', '603667', '上交所', '精密轴承与滚动体厂商,机器人轴承受益', '["轴承高端市场海外主导","毛利率偏低","客户集中度"]', '约50亿', '~40%', '国产化机会最大环节之一,价值量最高', '磨床工序壁垒最高,良率仅60%', 3, '欧美主导 · 卡脖子', 'risk', '把旋转转直线的核心机械件,磨床工序壁垒极高;欧美 CR5 超 80%,国产良率约 60%(海外 85%+),是当前人形量产最硬的卡点。', '[{"n":"GSA/Rollvis","s":55},{"n":"北特科技","s":8},{"n":"恒立液压","s":6},{"n":"其他","s":31}]', '["北特科技","恒立液压","鼎智科技","新剑传动(未上市)"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('中大力德', 'robot', '机器人', 'u01', '谐波减速器', 'up', '002896', '深交所', '精密减速器厂商,谐波+RV 双路线布局', '["减速器国产替代竞争激烈","下游工业机器人需求波动","规模偏小"]', '约80亿', '~30%', '国产替代+人形放量核心受益,价值量高', '齿形与材料工艺,超微型仍难点', 3, '日本主导 58%', 'race', '旋转关节核心,技术壁垒高、供给高度集中(日本哈默纳科全球约 58%);国产绿的谐波全球第二(约 15%),国内国产化率已达 70%+,替代成效显著。', '[{"n":"哈默纳科","s":58},{"n":"绿的谐波","s":15},{"n":"来福谐波","s":8},{"n":"其他","s":19}]', '["绿的谐波","双环传动","来福谐波(未上市)","哈默纳科(日)"]')
ON CONFLICT (name) DO NOTHING;

-- ===== 新能源汽车产业 (19 家) =====

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('赣锋锂业', 'ev', '新能源汽车', 'u1', '锂资源', 'up', '002460', '深交所', '全球锂资源与锂盐龙头,垂直一体化布局', '["锂价周期波动","海外资源政策风险","下游需求不及预期"]', '约1500亿', '~15%', '锂电产业链上游核心,资源为王', NULL, 2, '中国主导', 'cn', '中国掌握锂盐加工与盐湖提锂,但锂矿资源仍部分依赖进口(澳矿/南美);周期性强,供给弹性大。', '[{"n":"赣锋锂业","s":18},{"n":"天齐锂业","s":12},{"n":"盐湖股份","s":10},{"n":"其他","s":60}]', '["天齐锂业","盐湖股份"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('天齐锂业', 'ev', '新能源汽车', 'u1', '锂资源', 'up', '002466', '深交所', '锂资源龙头,控股 Greenbushes 矿山', '["锂价持续低位","SQM 股权变动","财务杠杆较高"]', '约1500亿', '~15%', '锂电产业链上游核心,资源为王', NULL, 2, '中国主导', 'cn', '中国掌握锂盐加工与盐湖提锂,但锂矿资源仍部分依赖进口(澳矿/南美);周期性强,供给弹性大。', '[{"n":"赣锋锂业","s":18},{"n":"天齐锂业","s":12},{"n":"盐湖股份","s":10},{"n":"其他","s":60}]', '["赣锋锂业","盐湖股份"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('德方纳米', 'ev', '新能源汽车', NULL, NULL, NULL, '300769', '创业板', '磷酸铁锂正极材料龙头,补锂剂布局', '["正极材料价格战","产能过剩","客户集中度高"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('容百科技', 'ev', '新能源汽车', 'u3', '正负极材料', 'up', '688005', '科创板', '三元正极材料龙头,高镍路线领先', '["三元路线被磷酸铁锂挤压","原材料价格波动","海外客户拓展"]', '约2000亿', '~20%', '国产份额领先,规模优势明显', NULL, 2, '中国主导', 'cn', '磷酸铁锂/三元正极、石墨负极国产化率高,龙头规模优势明显;技术壁垒中等。', NULL, '["璞泰来","贝特瑞"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('璞泰来', 'ev', '新能源汽车', 'u3', '正负极材料', 'up', '603659', '上交所', '负极材料与涂覆隔膜一体化龙头', '["负极材料价格竞争","下游需求波动","海外产能爬坡"]', '约2000亿', '~20%', '国产份额领先,规模优势明显', NULL, 2, '中国主导', 'cn', '磷酸铁锂/三元正极、石墨负极国产化率高,龙头规模优势明显;技术壁垒中等。', NULL, '["容百科技","贝特瑞"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('杉杉股份', 'ev', '新能源汽车', NULL, NULL, NULL, '600884', '上交所', '负极材料与偏光片双主业', '["负极价格战","偏光片业务剥离","财务压力"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('天赐材料', 'ev', '新能源汽车', 'u4', '电解液与隔膜', 'up', '002709', '深交所', '电解液龙头,六氟磷酸锂自供', '["电解液价格周期","六氟磷酸锂价格波动","海外份额竞争"]', '约800亿', '~25%', '国产主导,龙头集中度高', NULL, 2, '中国主导', 'cn', '电解液与隔膜国产主导,恩捷等龙头集中度高,壁垒来自规模与工艺。', '[{"n":"恩捷股份","s":35},{"n":"天赐材料","s":25},{"n":"新宙邦","s":12},{"n":"其他","s":28}]', '["恩捷股份","新宙邦"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('新宙邦', 'ev', '新能源汽车', 'u4', '电解液与隔膜', 'up', '300037', '创业板', '电解液与半导体化学品双主业', '["电解液价格竞争","半导体化学品拓展","海外贸易摩擦"]', '约800亿', '~25%', '国产主导,龙头集中度高', NULL, 2, '中国主导', 'cn', '电解液与隔膜国产主导,恩捷等龙头集中度高,壁垒来自规模与工艺。', '[{"n":"恩捷股份","s":35},{"n":"天赐材料","s":25},{"n":"新宙邦","s":12},{"n":"其他","s":28}]', '["天赐材料","恩捷股份"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('恩捷股份', 'ev', '新能源汽车', 'u4', '电解液与隔膜', 'up', '002812', '深交所', '全球锂电隔膜龙头,海外产能扩张', '["隔膜价格战","海外产能爬坡","客户集中度高"]', '约800亿', '~25%', '国产主导,龙头集中度高', NULL, 2, '中国主导', 'cn', '电解液与隔膜国产主导,恩捷等龙头集中度高,壁垒来自规模与工艺。', '[{"n":"恩捷股份","s":35},{"n":"天赐材料","s":25},{"n":"新宙邦","s":12},{"n":"其他","s":28}]', '["天赐材料","新宙邦"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('星源材质', 'ev', '新能源汽车', NULL, NULL, NULL, '300568', '创业板', '干法隔膜龙头,湿法+涂覆协同发展', '["隔膜行业产能过剩","干法份额被湿法挤压","海外竞争"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('宁德时代', 'ev', '新能源汽车', 'm1', '动力电池', 'mid', '300750', '创业板', '全球动力电池龙头,份额超 37%', '["原材料价格波动","海外政策风险(美国IRA)","新技术路线替代"]', '约5000亿', '~25%', '全球龙头集中,中国主导', NULL, 3, '中国主导', 'cn', '中国动力电池全球份额超 65%,宁德时代、比亚迪形成绝对龙头;规模、工艺、产业链一体化构成强护城河。', '[{"n":"宁德时代","s":37},{"n":"比亚迪","s":16},{"n":"LG","s":13},{"n":"其他","s":34}]', '["比亚迪弗迪","国轩高科"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('比亚迪', 'ev', '新能源汽车', 'd1', '整车制造与品牌', 'down', '002594', '深交所', '新能源整车+动力电池一体化龙头', '["价格战加剧","海外市场拓展风险","电池业务外供比例"]', '约2万亿', '~30%', '终端最大价值环节,国产崛起', NULL, 2, '中国崛起', 'cn', '比亚迪、蔚来、理想等中国品牌崛起,壁垒来自品牌、规模与供应链整合;特斯拉为全球标杆。', NULL, '["特斯拉","蔚来","理想"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('亿纬锂能', 'ev', '新能源汽车', NULL, NULL, NULL, '300014', '创业板', '消费+动力+储能电池多元化龙头', '["动力电池价格战","储能业务增速放缓","海外产能爬坡"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('国轩高科', 'ev', '新能源汽车', 'm1', '动力电池', 'mid', '002074', '深交所', '动力电池第二梯队,大众入股', '["市场份额竞争","客户集中度高","海外业务不确定性"]', '约5000亿', '~25%', '全球龙头集中,中国主导', NULL, 3, '中国主导', 'cn', '中国动力电池全球份额超 65%,宁德时代、比亚迪形成绝对龙头;规模、工艺、产业链一体化构成强护城河。', '[{"n":"宁德时代","s":37},{"n":"比亚迪","s":16},{"n":"LG","s":13},{"n":"其他","s":34}]', '["宁德时代","比亚迪弗迪"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('孚能科技', 'ev', '新能源汽车', NULL, NULL, NULL, '688567', '科创板', '软包动力电池厂商,奔驰主供', '["持续亏损","软包路线份额被挤压","客户集中度极高"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('三花智控', 'ev', '新能源汽车', NULL, NULL, NULL, '002050', '深交所', '热管理龙头,新能源车+机器人执行器受益', '["新能源车销量波动","热管理价格竞争","机器人执行器订单不确定"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('宏发股份', 'ev', '新能源汽车', NULL, NULL, NULL, '600885', '上交所', '全球继电器龙头,高压直流继电器受益', '["继电器行业成熟期","新能源车继电器价格竞争","海外贸易摩擦"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('斯达半导', 'ev', '新能源汽车', 'u5', '功率半导体', 'up', '603290', '上交所', 'IGBT 模块龙头,SiC 布局领先', '["IGBT 价格竞争","SiC 器件良率与可靠性","英飞凌等海外巨头竞争"]', '约300亿', '~30%', 'SiC国产替代核心,800V平台受益', '车规SiC器件良率与可靠性', 2, '海外主导 · 国产追赶', 'race', 'IGBT/SiC 器件英飞凌主导,国产斯达、士兰加速替代;车规 SiC 良率与可靠性是关键卡点。', '[{"n":"英飞凌","s":35},{"n":"斯达半导","s":15},{"n":"士兰微","s":8},{"n":"其他","s":42}]', '["士兰微","时代电气"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('时代电气', 'ev', '新能源汽车', 'u5', '功率半导体', 'up', '688187', '科创板', '轨交电气+IGBT 双主业,车规 SiC 受益', '["轨交业务周期波动","IGBT 价格竞争","SiC 量产爬坡"]', '约300亿', '~30%', 'SiC国产替代核心,800V平台受益', '车规SiC器件良率与可靠性', 2, '海外主导 · 国产追赶', 'race', 'IGBT/SiC 器件英飞凌主导,国产斯达、士兰加速替代;车规 SiC 良率与可靠性是关键卡点。', '[{"n":"英飞凌","s":35},{"n":"斯达半导","s":15},{"n":"士兰微","s":8},{"n":"其他","s":42}]', '["斯达半导","士兰微"]')
ON CONFLICT (name) DO NOTHING;

-- ===== 半导体产业 (14 家) =====

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('北方华创', 'chip', '半导体', 'u2', '半导体设备', 'up', '002371', '深交所', '国产半导体设备龙头,刻蚀/薄膜/清洗覆盖', '["美国出口管制升级","半导体周期波动","设备验证周期长"]', '约800亿', '~25%', '设备国产化最关键卡点,价值高', '光刻机被ASML垄断,EUV受限', 3, '海外垄断 · 卡脖子', 'risk', '光刻机被 ASML 垄断,EUV 受出口管制;刻蚀/薄膜沉积国产北方华创、中微追赶,是最受地缘约束的卡点。', '[{"n":"ASML","s":90},{"n":"中微公司","s":5},{"n":"北方华创","s":3},{"n":"其他","s":2}]', '["ASML","中微公司"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('中微公司', 'chip', '半导体', 'u2', '半导体设备', 'up', '688012', '科创板', '刻蚀设备龙头,CCP 刻蚀进入台积电产线', '["刻蚀设备竞争","美国出口管制","下游资本开支波动"]', '约800亿', '~25%', '设备国产化最关键卡点,价值高', '光刻机被ASML垄断,EUV受限', 3, '海外垄断 · 卡脖子', 'risk', '光刻机被 ASML 垄断,EUV 受出口管制;刻蚀/薄膜沉积国产北方华创、中微追赶,是最受地缘约束的卡点。', '[{"n":"ASML","s":90},{"n":"中微公司","s":5},{"n":"北方华创","s":3},{"n":"其他","s":2}]', '["ASML","北方华创"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('华海清科', 'chip', '半导体', NULL, NULL, NULL, '688120', '科创板', 'CMP 设备独家国产化,垄断国内市场', '["CMP 设备单一产品依赖","下游资本开支波动","海外市场拓展受限"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('拓荆科技', 'chip', '半导体', NULL, NULL, NULL, '688072', '科创板', '薄膜沉积设备国产化龙头,PVD/CVD 布局', '["薄膜设备竞争激烈","产品验证周期长","下游资本开支波动"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('华大九天', 'chip', '半导体', 'u3', 'EDA 与 IP', 'up', '301269', '创业板', '国产 EDA 龙头,模拟+平板显示 EDA 领先', '["EDA 海外双寡头垄断","生态壁垒高","先进制程 EDA 突破难"]', '约150亿', '~15%', '海外垄断严重,国产替代空间最大', 'Synopsys/Cadence双寡头,生态壁垒', 3, '海外垄断 · 卡脖子', 'risk', 'Synopsys/Cadence 双寡头主导,生态壁垒极高;国产华大九天份额不足 10%,是设计端最硬的卡点。', '[{"n":"Synopsys","s":32},{"n":"Cadence","s":30},{"n":"Siemens EDA","s":14},{"n":"华大九天","s":5},{"n":"其他","s":19}]', '["Synopsys","Cadence"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('中芯国际', 'chip', '半导体', 'm2', '晶圆制造', 'mid', '688981', '科创板', '国产晶圆代工龙头,成熟制程扩产', '["美国设备出口管制","先进制程受限","代工价格竞争"]', '约5000亿', '~15%', '先进制程国产化关键,战略环节', '先进制程设备受限,7nm以下卡点', 3, '海外主导 · 卡脖子', 'risk', '台积电主导先进制程(约 60%),7nm 以下受设备限制;中芯国际在成熟制程追赶,先进制程是核心卡点。', '[{"n":"台积电","s":60},{"n":"三星","s":15},{"n":"中芯国际","s":6},{"n":"其他","s":19}]', '["台积电","三星"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('华虹半导体', 'chip', '半导体', NULL, NULL, NULL, '688347', '科创板', '特色工艺代工龙头,功率+嵌入式存储', '["成熟制程价格竞争","功率器件需求波动","设备采购受限"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('长电科技', 'chip', '半导体', 'm3', '封装测试', 'mid', '600584', '上交所', '全球第三大封测厂商,先进封装布局', '["封测行业价格竞争","先进封装追赶日月光","客户集中度高"]', '约1500亿', '~12%', '国产化率较高,先进封装追赶', NULL, 2, '国产较强', 'cn', '封测国产化率约 65%,长电、通富规模领先;先进封装(CoWoS 等)仍偏弱,是追赶方向。', '[{"n":"日月光","s":30},{"n":"长电科技","s":14},{"n":"通富微电","s":10},{"n":"其他","s":46}]', '["日月光","通富微电"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('通富微电', 'chip', '半导体', 'm3', '封装测试', 'mid', '002156', '深交所', 'AMD 主要封测合作方,先进封装受益', '["AMD 订单依赖度高","封测价格竞争","先进封装技术迭代"]', '约1500亿', '~12%', '国产化率较高,先进封装追赶', NULL, 2, '国产较强', 'cn', '封测国产化率约 65%,长电、通富规模领先;先进封装(CoWoS 等)仍偏弱,是追赶方向。', '[{"n":"日月光","s":30},{"n":"长电科技","s":14},{"n":"通富微电","s":10},{"n":"其他","s":46}]', '["日月光","长电科技"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('韦尔股份', 'chip', '半导体', 'm1', '芯片设计', 'mid', '603501', '上交所', 'CIS 图像传感器全球第三,车载 CIS 受益', '["智能手机需求波动","CIS 价格竞争","车载 CIS 验证周期长"]', '约3000亿', '~20%', '设计是高价值环节,国产追赶中', NULL, 2, '美国主导 · 中国追赶', 'risk', '英伟达、高通等美国巨头主导高端设计,华为海思受制约;国产韦尔等在中低端追赶。', NULL, '["英伟达","高通","海思"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('兆易创新', 'chip', '半导体', NULL, NULL, NULL, '603986', '上交所', 'NOR Flash+MCU 龙头,DRAM 布局', '["存储芯片周期波动","MCU 价格竞争","DRAM 国产化不确定"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('澜起科技', 'chip', '半导体', NULL, NULL, NULL, '688008', '科创板', '内存接口芯片龙头,DDR5+AI 津渡接口受益', '["服务器需求波动","接口芯片竞争","AI 配套芯片验证节奏"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('沪硅产业', 'chip', '半导体', 'u1', '半导体材料', 'up', '688126', '科创板', '国产大硅片龙头,300mm 硅片扩产', '["硅片价格周期","亏损持续","海外硅片巨头竞争"]', '约500亿', '~15%', '国产替代空间大,材料是基础', '光刻胶与电子特气高端品种', 2, '海外主导 · 国产追赶', 'race', '硅片/光刻胶/电子特气高端品种海外主导,国产沪硅、南大光电等加速替代;光刻胶是关键卡点。', NULL, '["南大光电","华特气体"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('TCL中环', 'chip', '半导体', NULL, NULL, NULL, '002129', '深交所', '光伏硅片+半导体硅片双主业', '["光伏硅片产能过剩","半导体硅片高端依赖进口","财务压力"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

-- ===== 光伏产业 (13 家) =====

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('通威股份', 'solar', '光伏', 'u1', '多晶硅料', 'up', '600438', '上交所', '硅料+电池片一体化龙头,成本领先', '["硅料价格周期","电池片技术迭代","一体化经营杠杆"]', '约1500亿', '~10%', '国产主导,全球份额超80%', NULL, 3, '中国主导', 'cn', '中国多晶硅全球份额超 80%,通威、协鑫、大全形成龙头集中;规模与能耗管控构成强壁垒。', '[{"n":"通威股份","s":25},{"n":"协鑫科技","s":18},{"n":"大全能源","s":12},{"n":"其他","s":45}]', '["大全能源","协鑫科技"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('大全能源', 'solar', '光伏', 'u1', '多晶硅料', 'up', '688303', '科创板', '高纯多晶硅龙头,内蒙古基地扩产', '["硅料价格持续低位","产能过剩","电力成本波动"]', '约1500亿', '~10%', '国产主导,全球份额超80%', NULL, 3, '中国主导', 'cn', '中国多晶硅全球份额超 80%,通威、协鑫、大全形成龙头集中;规模与能耗管控构成强壁垒。', '[{"n":"通威股份","s":25},{"n":"协鑫科技","s":18},{"n":"大全能源","s":12},{"n":"其他","s":45}]', '["通威股份","协鑫科技"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('协鑫科技', 'solar', '光伏', 'u1', '多晶硅料', 'up', '03800', '港交所', '颗粒硅+硅片龙头,FBR 技术领先', '["颗粒硅市场接受度","硅料价格周期","海外产能爬坡"]', '约1500亿', '~10%', '国产主导,全球份额超80%', NULL, 3, '中国主导', 'cn', '中国多晶硅全球份额超 80%,通威、协鑫、大全形成龙头集中;规模与能耗管控构成强壁垒。', '[{"n":"通威股份","s":25},{"n":"协鑫科技","s":18},{"n":"大全能源","s":12},{"n":"其他","s":45}]', '["通威股份","大全能源"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('隆基绿能', 'solar', '光伏', 'u2', '硅片', 'up', '601012', '上交所', '全球单晶硅片+组件龙头,BC 技术布局', '["光伏价格战","BC 技术量产节奏","海外贸易壁垒"]', '约2000亿', '~15%', '国产绝对主导,龙头集中', NULL, 3, '中国主导', 'cn', '中国硅片全球份额超 95%,隆基、中环双寡头;单晶拉棒与切片工艺壁垒高,是光伏链上最硬的筹码。', '[{"n":"隆基绿能","s":30},{"n":"TCL中环","s":25},{"n":"其他","s":45}]', '["TCL中环"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('爱旭股份', 'solar', '光伏', NULL, NULL, NULL, '600732', '上交所', 'ABC 电池技术领先,高效电池片厂商', '["ABC 技术市场接受度","电池片价格战","PERC 资产减值"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('钧达股份', 'solar', '光伏', NULL, NULL, NULL, '002865', '深交所', 'TOPCon 电池片龙头,捷泰科技核心', '["TOPCon 价格战","客户集中度高","海外产能爬坡"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('晶科能源', 'solar', '光伏', 'm1', '电池片与组件', 'mid', '688223', '科创板', '全球组件出货第一,N 型 TOPCon 领先', '["组件价格战","海外贸易壁垒(美国双反)","汇率波动"]', '约3000亿', '~20%', 'TOPCon/HJT技术迭代受益', NULL, 2, '中国主导', 'cn', '电池片与组件国产主导,隆基、晶科、天合等龙头;TOPCon/HJT 技术迭代期,壁垒中等。', '[{"n":"隆基绿能","s":20},{"n":"晶科能源","s":15},{"n":"天合光能","s":14},{"n":"晶澳科技","s":12},{"n":"其他","s":39}]', '["隆基绿能","天合光能"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('天合光能', 'solar', '光伏', 'm1', '电池片与组件', 'mid', '688599', '科创板', '全球组件龙头,210 组件+储能布局', '["组件价格战","储能业务亏损","海外贸易壁垒"]', '约3000亿', '~20%', 'TOPCon/HJT技术迭代受益', NULL, 2, '中国主导', 'cn', '电池片与组件国产主导,隆基、晶科、天合等龙头;TOPCon/HJT 技术迭代期,壁垒中等。', '[{"n":"隆基绿能","s":20},{"n":"晶科能源","s":15},{"n":"天合光能","s":14},{"n":"晶澳科技","s":12},{"n":"其他","s":39}]', '["隆基绿能","晶科能源"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('晶澳科技', 'solar', '光伏', NULL, NULL, NULL, '002459', '深交所', '全球组件第一梯队,垂直一体化布局', '["组件价格战","海外贸易壁垒","一体化经营杠杆"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('阳光电源', 'solar', '光伏', 'm2', '逆变器', 'mid', '300274', '创业板', '全球逆变器龙头,储能系统集成受益', '["逆变器价格竞争","储能业务毛利波动","海外贸易壁垒"]', '约800亿', '~25%', '国产龙头全球领先,出海受益', NULL, 2, '中国领先', 'cn', '阳光电源、华为全球领先,出海受益;壁垒来自电力电子技术与品牌。', '[{"n":"阳光电源","s":30},{"n":"华为","s":20},{"n":"固德威","s":10},{"n":"其他","s":40}]', '["华为","固德威"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('锦浪科技', 'solar', '光伏', NULL, NULL, NULL, '300763', '创业板', '组串式逆变器龙头,户用市场受益', '["逆变器价格竞争","户用光伏需求波动","海外市场份额"]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('福斯特', 'solar', '光伏', 'u3', '玻璃与胶膜', 'up', '603806', '上交所', '全球 EVA/POE 胶膜龙头,份额超 50%', '["胶膜价格竞争","原材料价格波动","海外份额竞争"]', '约800亿', '~15%', '辅材国产主导,龙头集中', NULL, 2, '中国主导', 'cn', '光伏玻璃与胶膜国产主导,福莱特、信义、福斯特龙头集中;壁垒来自规模与窑炉产能。', '[{"n":"福莱特","s":30},{"n":"信义光能","s":25},{"n":"福斯特","s":20},{"n":"其他","s":25}]', '["福莱特","信义光能"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('信义光能', 'solar', '光伏', 'u3', '玻璃与胶膜', 'up', '00968', '港交所', '全球光伏玻璃龙头,双玻组件受益', '["光伏玻璃产能过剩","价格竞争","纯碱等原材料波动"]', '约800亿', '~15%', '辅材国产主导,龙头集中', NULL, 2, '中国主导', 'cn', '光伏玻璃与胶膜国产主导,福莱特、信义、福斯特龙头集中;壁垒来自规模与窑炉产能。', '[{"n":"福莱特","s":30},{"n":"信义光能","s":25},{"n":"福斯特","s":20},{"n":"其他","s":25}]', '["福莱特","福斯特"]')
ON CONFLICT (name) DO NOTHING;

-- ============================================================
-- 新增美国/海外上市公司 (财务数据由 Finnhub 实时 API 提供)
-- ============================================================

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('英特尔', 'robot', '机器人', 'u14', '运动控制芯片·控制器(小脑)', 'up', 'INTC', '纳斯达克', '全球最大半导体芯片制造商,工业控制与机器人核心芯片供应商', '["PC市场持续低迷","数据中心竞争加剧","代工模式转型风险"]', '约50亿', '~25%', '实时运动控制核心,国产化推进中', NULL, 2, '美国主导', 'race', '英特尔在工业控制与机器人芯片领域占据重要地位,但正面临英伟达等竞争者冲击。', NULL, '["英伟达","AMD","德州仪器"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('特斯拉', 'ev', '新能源汽车', 'd1', '整车制造与品牌', 'down', 'TSLA', '纳斯达克', '全球新能源汽车与人形机器人双龙头,技术与品牌壁垒极高', '["价格战加剧","FSD进展不及预期","马斯克精力分散"]', '约2万亿', '~30%', '终端最大价值环节,全球标杆', NULL, 3, '全球垄断', 'risk', '特斯拉是全球新能源车与人形机器人的绝对龙头,品牌与技术壁垒极高,Optimus是潜在百亿级新业务。', NULL, '["比亚迪","蔚来","理想"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('英伟达', 'chip', '半导体', 'm1', '芯片设计', 'mid', 'NVDA', '纳斯达克', '全球 AI 与 GPU 计算霸主,数据中心与机器人核心算力供应商', '["AI 数据中心增速放缓","AMD 竞争加剧","出口管制风险"]', '约3000亿', '~20%', '高端算力绝对垄断,价值量最高', NULL, 3, '美国绝对主导', 'risk', '英伟达在高端 AI 芯片领域占据绝对垄断地位,全球份额超 80%;但机器人领域 Isaac 平台尚未完全落地。', NULL, '["AMD","高通","海思"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('谷歌', 'chip', '半导体', 'm1', '芯片设计', 'mid', 'GOOGL', '纳斯达克', '全球搜索与 AI 巨头,TPU 芯片自研+DeepMind 机器人布局', '["搜索增速放缓","AI 投入回报不确定","监管风险"]', '约3000亿', '~20%', 'AI 算法与芯片协同,生态壁垒', NULL, 2, '美国主导', 'race', '谷歌在 AI 算法与自研芯片(TPU)上领先,DeepMind 机器人是潜在变量;但硬件非核心业务。', NULL, '["英伟达","AMD","苹果"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('亚马逊', 'robot', '机器人', 'd3', '服务机器人·物流', 'down', 'AMZN', '纳斯达克', '全球电商与云服务巨头,仓储物流机器人最大应用方', '["AWS 增速放缓","零售利润率低","机器人 ROI 不确定"]', '约500亿', '~25%', '物流机器人最大场景方,数据积累优势', NULL, 2, '美国主导', 'race', '亚马逊是仓储物流机器人的最大应用方,Kiva 机器人规模领先;但自研能力有限,依赖第三方。', NULL, '["京东","顺丰","极智嘉"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('苹果', 'chip', '半导体', 'd1', '消费电子', 'down', 'AAPL', '纳斯达克', '全球消费电子龙头,自研 M 系列芯片+Vision Pro XR 布局', '["iPhone 增速放缓","AI 投入回报不确定","中国市场风险"]', '约2000亿', '~10%', '消费电子核心卡位,生态壁垒极高', NULL, 3, '美国绝对主导', 'risk', '苹果在消费电子领域的生态壁垒极高,自研芯片能力领先;但 XR/机器人布局尚早。', NULL, '["小米","华为","联想"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('超微', 'chip', '半导体', 'm1', '芯片设计', 'mid', 'AMD', '纳斯达克', '全球第二大 GPU 厂商,MI300 挑战英伟达 AI 垄断', '["AI 市场份额争夺激烈","数据中心客户获取慢","毛利率低于英伟达"]', '约3000亿', '~20%', 'AI 算力老二,追赶英伟达', NULL, 2, '美国主导', 'race', 'AMD 通过 MI300 系列挑战英伟达 AI 垄断,但份额仍不足 10%;机器人领域布局尚早。', NULL, '["英伟达","高通"]')
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES
('高通', 'chip', '半导体', 'm1', '芯片设计', 'mid', 'QCOM', '纳斯达克', '全球手机 SoC 龙头,机器人与汽车电子布局加速', '["手机市场增速放缓","汽车芯片竞争加剧","License 模式承压"]', '约3000亿', '~20%', '移动芯片王者,拓展机器人/汽车', NULL, 2, '美国主导', 'race', '高通在移动芯片领域垄断地位稳固,正在积极拓展汽车电子与机器人领域;但面临联发科竞争。', NULL, '["英伟达","联发科","海思"]')
ON CONFLICT (name) DO NOTHING;

-- ============================================================
-- 启用 RLS + 匿名读取策略
-- ============================================================

ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
CREATE POLICY "anon read" ON companies FOR SELECT TO anon USING (true);
