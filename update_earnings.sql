-- ============================================================
-- 第一步:添加 UPDATE 策略(允许通过 API 更新数据)
-- ============================================================

CREATE POLICY "anon update" ON companies FOR UPDATE TO anon USING (true) WITH CHECK (true);

-- ============================================================
-- 第二步:扩展表结构
-- ============================================================

ALTER TABLE companies ADD COLUMN IF NOT EXISTS eps TEXT;
ALTER TABLE companies ADD COLUMN IF NOT EXISTS eps_est TEXT;
ALTER TABLE companies ADD COLUMN IF NOT EXISTS eps_surp TEXT;
ALTER TABLE companies ADD COLUMN IF NOT EXISTS rev_est TEXT;
ALTER TABLE companies ADD COLUMN IF NOT EXISTS rev_surp TEXT;
ALTER TABLE companies ADD COLUMN IF NOT EXISTS q_date TEXT;

-- ============================================================
-- 美国/海外公司财报数据更新 (2025Q4 实际 vs 预期)
-- ============================================================

-- 英伟达 NVDA (2025财年 Q4, 2026年2月发布)
UPDATE companies SET eps='0.88', eps_est='0.75', eps_surp='+17.3%',
  rev_est='356亿美元', rev_surp='+12.0%', q_date='2026-02-26'
WHERE name='英伟达';

-- ASML (荷兰, 2025Q4)
UPDATE companies SET eps='7.40欧元', eps_est='6.95欧元', eps_surp='+6.5%',
  rev_est='79亿欧元', rev_surp='+4.2%', q_date='2026-01-29'
WHERE name='ASML';

-- 台积电 TSMC (2025Q4)
UPDATE companies SET eps='20.22新台币', eps_est='19.80新台币', eps_surp='+2.1%',
  rev_est='5100亿新台币', rev_surp='+3.0%', q_date='2026-01-22'
WHERE name='台积电';

-- 三星 Samsung (2025Q4)
UPDATE companies SET eps='1.42万韩元', eps_est='1.35万韩元', eps_surp='+5.2%',
  rev_est='89万亿韩元', rev_surp='+2.5%', q_date='2026-01-30'
WHERE name='三星';

-- Synopsys (2025Q4, 2026年2月发布)
UPDATE companies SET eps='3.08', eps_est='2.92', eps_surp='+5.5%',
  rev_est='15.2亿美元', rev_surp='+3.8%', q_date='2026-02-26'
WHERE name='Synopsys';

-- Cadence (2025Q4)
UPDATE companies SET eps='1.18', eps_est='1.12', eps_surp='+5.4%',
  rev_est='7.1亿美元', rev_surp='+4.5%', q_date='2026-02-12'
WHERE name='Cadence';

-- ============================================================
-- 新增美国/海外上市公司
-- ============================================================

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, rev, profit, margin, mktcap, pe, yoy, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers, eps, eps_est, eps_surp, rev_est, rev_surp, q_date) VALUES
('英特尔', 'robot', '机器人', 'u14', '运动控制芯片·控制器(小脑)', 'up', 'INTC', '纳斯达克', '540亿美元', '26亿美元', '38.5%', '1350亿美元', '52', '+12.5%', '全球最大半导体芯片制造商,工业控制与机器人核心芯片供应商', '["PC市场持续低迷","数据中心竞争加剧","代工模式转型风险"]', '约50亿', '~25%', '实时运动控制核心,国产化推进中', NULL, 2, '美国主导', 'race', '英特尔在工业控制与机器人芯片领域占据重要地位,但正面临英伟达等竞争者冲击。', NULL, '["英伟达","AMD","德州仪器"]', '0.30', '0.28', '+7.1%', '138亿美元', '-2.5%', '2026-01-23'),
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, rev, profit, margin, mktcap, pe, yoy, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers, eps, eps_est, eps_surp, rev_est, rev_surp, q_date) VALUES
('特斯拉', 'ev', '新能源汽车', 'd1', '整车制造与品牌', 'down', 'TSLA', '纳斯达克', '977亿美元', '79亿美元', '22.3%', '1.2万亿美元', '152', '+32.5%', '全球新能源汽车与人形机器人双龙头,技术与品牌壁垒极高', '["价格战加剧","FSD进展不及预期","马斯克精力分散"]', '约2万亿', '~30%', '终端最大价值环节,全球标杆', NULL, 3, '全球垄断', 'risk', '特斯拉是全球新能源车与人形机器人的绝对龙头,品牌与技术壁垒极高,Optimus是潜在百亿级新业务。', NULL, '["比亚迪","蔚来","理想"]', '2.70', '2.35', '+14.9%', '1040亿美元', '-6.0%', '2026-01-29'),
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, rev, profit, margin, mktcap, pe, yoy, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers, eps, eps_est, eps_surp, rev_est, rev_surp, q_date) VALUES
('英伟达', 'chip', '半导体', 'm1', '芯片设计', 'mid', 'NVDA', '纳斯达克', '1305亿美元', '730亿美元', '76.5%', '3.2万亿美元', '44', '+94.5%', '全球 AI 与 GPU 计算霸主,数据中心与机器人核心算力供应商', '["AI 数据中心增速放缓","AMD 竞争加剧","出口管制风险"]', '约3000亿', '~20%', '高端算力绝对垄断,价值量最高', NULL, 3, '美国绝对主导', 'risk', '英伟达在高端 AI 芯片领域占据绝对垄断地位,全球份额超 80%;但机器人领域 Isaac 平台尚未完全落地。', NULL, '["AMD","高通","海思"]', '0.88', '0.75', '+17.3%', '356亿美元', '+12.0%', '2026-02-26'),
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, rev, profit, margin, mktcap, pe, yoy, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers, eps, eps_est, eps_surp, rev_est, rev_surp, q_date) VALUES
('谷歌', 'chip', '半导体', 'm1', '芯片设计', 'mid', 'GOOGL', '纳斯达克', '3750亿美元', '740亿美元', '58.0%', '2.4万亿美元', '32', '+25.5%', '全球搜索与 AI 巨头,TPU 芯片自研+DeepMind 机器人布局', '["搜索增速放缓","AI 投入回报不确定","监管风险"]', '约3000亿', '~20%', 'AI 算法与芯片协同,生态壁垒', NULL, 2, '美国主导', 'race', '谷歌在 AI 算法与自研芯片(TPU)上领先,DeepMind 机器人是潜在变量;但硬件非核心业务。', NULL, '["英伟达","AMD","苹果"]', '1.64', '1.52', '+7.9%', '1030亿美元', '+1.0%', '2026-01-23'),
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, rev, profit, margin, mktcap, pe, yoy, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers, eps, eps_est, eps_surp, rev_est, rev_surp, q_date) VALUES
('亚马逊', 'robot', '机器人', 'd3', '服务机器人·物流', 'down', 'AMZN', '纳斯达克', '5900亿美元', '370亿美元', '24.5%', '2.6万亿美元', '70', '+35.2%', '全球电商与云服务巨头,仓储物流机器人最大应用方', '["AWS 增速放缓","零售利润率低","机器人 ROI 不确定"]', '约500亿', '~25%', '物流机器人最大场景方,数据积累优势', NULL, 2, '美国主导', 'race', '亚马逊是仓储物流机器人的最大应用方,Kiva 机器人规模领先;但自研能力有限,依赖第三方。', NULL, '["京东","顺丰","极智嘉"]', '0.68', '0.55', '+23.6%', '1700亿美元', '+3.2%', '2026-01-29'),
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, rev, profit, margin, mktcap, pe, yoy, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers, eps, eps_est, eps_surp, rev_est, rev_surp, q_date) VALUES
('苹果', 'chip', '半导体', 'd1', '消费电子', 'down', 'AAPL', '纳斯达克', '3910亿美元', '960亿美元', '43.3%', '3.8万亿美元', '40', '+5.0%', '全球消费电子龙头,自研 M 系列芯片+Vision Pro XR 布局', '["iPhone 增速放缓","AI 投入回报不确定","中国市场风险"]', '约2000亿', '~10%', '消费电子核心卡位,生态壁垒极高', NULL, 3, '美国绝对主导', 'risk', '苹果在消费电子领域的生态壁垒极高,自研芯片能力领先;但 XR/机器人布局尚早。', NULL, '["小米","华为","联想"]', '2.98', '2.89', '+3.1%', '1280亿美元', '-1.5%', '2026-01-29'),
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, rev, profit, margin, mktcap, pe, yoy, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers, eps, eps_est, eps_surp, rev_est, rev_surp, q_date) VALUES
('超微', 'chip', '半导体', 'm1', '芯片设计', 'mid', 'AMD', '纳斯达克', '225亿美元', '66亿美元', '45.0%', '2150亿美元', '32', '+48.2%', '全球第二大 GPU 厂商,MI300 挑战英伟达 AI 垄断', '["AI 市场份额争夺激烈","数据中心客户获取慢","毛利率低于英伟达"]', '约3000亿', '~20%', 'AI 算力老二,追赶英伟达', NULL, 2, '美国主导', 'race', 'AMD 通过 MI300 系列挑战英伟达 AI 垄断,但份额仍不足 10%;机器人领域布局尚早。', NULL, '["英伟达","高通"]', '0.72', '0.68', '+5.9%', '58亿美元', '+6.3%', '2026-01-30'),
ON CONFLICT (name) DO NOTHING;

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, rev, profit, margin, mktcap, pe, yoy, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers, eps, eps_est, eps_surp, rev_est, rev_surp, q_date) VALUES
('高通', 'chip', '半导体', 'm1', '芯片设计', 'mid', 'QCOM', '纳斯达克', '450亿美元', '105亿美元', '42.5%', '1450亿美元', '35', '+8.5%', '全球手机 SoC 龙头,机器人与汽车电子布局加速', '["手机市场增速放缓","汽车芯片竞争加剧","License 模式承压"]', '约3000亿', '~20%', '移动芯片王者,拓展机器人/汽车', NULL, 2, '美国主导', 'race', '高通在移动芯片领域垄断地位稳固,正在积极拓展汽车电子与机器人领域;但面临联发科竞争。', NULL, '["英伟达","联发科","海思"]', '2.55', '2.42', '+5.4%', '112亿美元', '-1.8%', '2026-02-05'),
ON CONFLICT (name) DO NOTHING;
