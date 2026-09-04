-- ============================================================
-- 删除已被 Finnhub 实时数据替代的静态财务字段
-- 在 Supabase SQL Editor 中执行
-- ============================================================

-- 基础财务字段(已由 Finnhub quote/profile2 实时提供)
ALTER TABLE companies DROP COLUMN IF EXISTS rev;
ALTER TABLE companies DROP COLUMN IF EXISTS profit;
ALTER TABLE companies DROP COLUMN IF EXISTS margin;
ALTER TABLE companies DROP COLUMN IF EXISTS mktcap;
ALTER TABLE companies DROP COLUMN IF EXISTS pe;
ALTER TABLE companies DROP COLUMN IF EXISTS yoy;

-- 财报预期/实际对比字段(已由 Finnhub earnings/metrics 实时提供)
ALTER TABLE companies DROP COLUMN IF EXISTS eps;
ALTER TABLE companies DROP COLUMN IF EXISTS eps_est;
ALTER TABLE companies DROP COLUMN IF EXISTS eps_surp;
ALTER TABLE companies DROP COLUMN IF EXISTS rev_est;
ALTER TABLE companies DROP COLUMN IF EXISTS rev_surp;
ALTER TABLE companies DROP COLUMN IF EXISTS q_date;
