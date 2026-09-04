-- ============================================================
-- 23家全球药企(JPM 2026) 数据导入
-- 来源: https://liangchang.substack.com/p/i-summarized-23-global-pharma-presentations
-- ============================================================

INSERT INTO companies (name, industry, industry_name, node_id, node_name, tier, code, mkt, description, risks, size, growth, logic, bottleneck, moat, sup, supc, why, share, peers) VALUES

-- 1. Eli Lilly 礼来
('礼来', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'LLY', '纽交所', '全球肥胖/代谢龙头,Tirzepatide领涨;NVIDIA AI合作,研发速度领先同行3.5年;$55B投资13个生产基地', '["GLP-1竞争加剧(诺和诺德)","肥胖药定价压力","Tirzepatide专利悬崖"]', '约$1万亿', '~20%', '肥胖赛道绝对龙头,定价权极强', '原创靶点与全球临床', 3, '美国主导', 'risk', '礼来在肥胖/代谢领域绝对领先,Tirzepatide扩展OSA/CV/肾/肝/疼痛等适应症;39笔BD交易($4B+),NVIDIA AI合作加速研发。', '[]', '["礼来","强生","艾伯维","罗氏","诺和诺德"]'),

-- 2. Johnson & Johnson 强生
('强生', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'JNJ', '纽交所', '全球最大综合医疗健康公司,肿瘤/免疫/神经/心血管全布局;~12款新产品即将上市', '["诉讼风险(Talc)","Keytruda竞争","专利悬崖"]', '约$1万亿', '~7%', '多元化龙头,产品线深厚', '创新管线执行力', 3, '美国主导', 'risk', '强生CEO看好5-7%年增长,Icotrokinra(口服IL-23)2026上市为关键催化;~12款新产品覆盖6大治疗领域。', '[]', '["礼来","艾伯维","罗氏","默沙东","辉瑞"]'),

-- 3. AbbVie 艾伯维
('艾伯维', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'ABBV', '纽交所', '免疫龙头,Skyrizi+Rinvoq 2027合计$31B;肿瘤管线被低估;收购RemeGen PD-1/VEGF双抗', '["Humira专利悬崖持续","免疫竞争加剧","肿瘤管线验证"]', '约$6000亿', '~10%', '免疫双星驱动,肿瘤管线低估', '免疫 franchises 持续性', 3, '美国主导', 'risk', '艾伯维Skyrizi+Rinvoq 2027合计$31B($20B+$11B);Emrelis(c-Met ADC)已获批;收购RemeGen(~$5B)布局PD-1/VEGF。', '[]', '["礼来","强生","罗氏","默沙东","辉瑞"]'),

-- 4. Roche 罗氏
('罗氏', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'RHHBY', 'OTC', '全球肿瘤龙头,2030目标肥胖前三;Vabysmo+Ocrevus锚定增长;2026年10个III期读出', '["肿瘤竞争加剧","肥胖管线风险","定价压力"]', '约$7000亿', '~5%', '肿瘤+眼科+肥胖三线并进', '内部研发引擎', 3, '欧洲主导', 'risk', '罗氏目标2030肥胖全球前三,优先内部研发;2026年10个关键III期读出;$700M北卡工厂用于肥胖药生产。', '[]', '["礼来","强生","艾伯维","阿斯利康","默沙东"]'),

-- 5. AstraZeneca 阿斯利康
('阿斯利康', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'AZN', '纳斯达克', '2030营收目标从$67B上调至$80B;104个III期进行中;收购Modela AI推进计算病理', '["肿瘤竞争","专利悬崖","中国集采风险"]', '约$5500亿', '~12%', '管线最厚,2030目标$80B', '管线深度与执行力', 3, '欧洲主导', 'risk', '阿斯利康2030营收目标~$80B,104个III期进行中;Baxdrostat/Camizestrant/Garadacimab待审批;与第一三共合作Enhertu/Dato-DXd。', '[]', '["礼来","罗氏","默沙东","诺华","辉瑞"]'),

-- 6. Merck & Co. 默沙东
('默沙东', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'MRK', '纽交所', 'Keytruda 2028 LOE前转型;新增长引擎>$70B机会;~80个III期,>20个潜在重磅新品', '["Keytruda 2028专利悬崖","肿瘤竞争","BD整合风险"]', '约$6500亿', '~6%', 'Keytruda最后的辉煌+转型期', 'Keytruda后继管线', 3, '美国主导', 'risk', '默沙东应对Keytruda 2028 LOE,新增长引擎>$70B(上调$20B);10大项目占70%机会,包括sacituzumab tirumotecan、ifinatamab deruxtecan等ADC。', '[]', '["礼来","强生","艾伯维","罗氏","辉瑞"]'),

-- 7. Novartis 诺华
('诺华', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'NVS', '纽交所', '+7% CAGR(2019-2024);8个潜在重磅资产;收购Avidity(AOC技术)', '["Entresto专利悬崖","心血管竞争","收购整合"]', '约$5200亿', '~6%', '心肾代谢龙头,利润率扩张', '8大重磅资产兑现', 2, '欧洲主导', 'race', '诺华+7% CAGR(2019-2024),利润率38.7%→40%+(2029);8大潜在重磅资产:ianalumab、pelacarsen、abelacimab等;收购Avidity布局AOC。', '[]', '["礼来","罗氏","默沙东","辉瑞","阿斯利康"]'),

-- 8. Novo Nordisk 诺和诺德
('诺和诺德', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'NVO', '纽交所', '口服Wegovy首上市(16.6%减重);新CEO Doustdar战略重置;CagriSema~23%减重', '["礼来GLP-1竞争","口服药接受度","定价压力"]', '约$4500亿', '~10%', 'GLP-1双雄之一,口服破局', 'CagriSema与Amycretin兑现', 3, '欧洲主导', 'race', '诺和诺德新CEO战略重置,口服Wegovy(16.6%减重,7%停药率vs竞品24%)上市;CagriSema~23%减重;与Costco/Amazon/WeightWatchers合作扩大渠道。', '[]', '["礼来","强生","罗氏","安进"]'),

-- 9. Amgen 安进
('安进', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'AMGN', '纳斯达克', '6大增长引擎;MariTide月度GLP-1;Repatha心血管数据强劲;生物类似药第三波', '["MariTide安全性","GLP-1竞争","生物类似药价格战"]', '约$3500亿', '~8%', '生物类似药+肥胖双驱动', 'MariTide数据兑现', 2, '美国主导', 'race', '安进MariTide(月度GLP-1)6个全球III期;Repatha VESALIUS-CV降低25% MACE;第三波生物类似药(OPDIVO/KEYTRUDA/OCREVUS仿制药)在III期。', '[]', '["礼来","诺和诺德","罗氏","辉瑞"]'),

-- 10. Gilead Sciences 吉利德
('吉利德', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'GILD', '纳斯达克', 'HIV领导力延续至2040s;Trodelvy ADC扩张;anito-cel CAR-T提交FDA;10年无专利悬崖', '["HIV竞争","ADC数据风险","CAR-T商业化"]', '约$3000亿', '~5%', 'HIV+ADC+细胞治疗三线', 'Trodelvy与anito-cel兑现', 2, '美国主导', 'race', '吉利德HIV领导力延续至2040s,Yeztugo 6个月85%医保覆盖;Trodelvy 1L mTNBC(2026)/1L NSCLC(2027)扩张;anito-cel CAR-T(与Arcellx)已提交FDA。', '[]', '["礼来","默沙东","百时美施贵宝","辉瑞"]'),

-- 11. Pfizer 辉瑞
('辉瑞', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'PFE', '纽交所', '2026营收$59.5-62.5B;Metsera超长效GLP-1;$7.2B成本节约;20+III期启动', '["COVID营收悬崖","GLP-1竞争"," Seagen整合"]', '约$6500亿', '~4%', '后COVID转型,GLP-1+ADC', 'Seagen ADC管线兑现', 2, '美国主导', 'race', '辉瑞2026营收指引$59.5-62.5B(~4%增长);收购Metsera获超长效GLP-1(MET-097i月度/周度);ELREXFIO骨髓瘤III期;LITFULO白癜风数据。', '[]', '["礼来","默沙东","强生","艾伯维","诺华"]'),

-- 12. Vertex Pharmaceuticals 福泰制药
('福泰制药', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'VRTX', '纳斯达克', '囊性纤维化龙头(2040专利保护);CASGEVY基因治疗>$100M;JOURNAVX疼痛药;~$12B现金', '["CF市场饱和","疼痛药接受度","基因治疗竞争"]', '约$1200亿', '~12%', 'CF垄断+基因治疗+疼痛三线', '疼痛与肾管线兑现', 3, '美国主导', 'risk', '福泰CF专利保护至~2040,ALYFTREK上市推动升级;CASGEVY基因治疗>$100M营收(SCD+31年/TDT+18年生存);JOURNAVX疼痛药90.9%无阿片率;povetacicept IgAN BLA 2026H1。', '[]', '["礼来","罗氏","渤健","安进"]'),

-- 13. Bristol-Myers Squibb 百时美施贵宝
('百时美施贵宝', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'BMY', '纽交所', '增长组合+17% YoY;COBENFY(精神分裂首创药)扩张;2030前10+新品上市', '["Revlimid专利悬崖","免疫竞争","COBENFY接受度"]', '约$5000亿', '~3%', '精神分裂首创药+免疫管线', 'COBENFY与CELMoD兑现', 2, '美国主导', 'race', 'BMS增长组合+17% YoY(4个>$10亿资产);COBENFY(KarXT)首创M1/M4激动剂,扩张至AD精神病/躁郁;milvexian(与J&J)口服FXIa抑制剂;CELMoD平台骨髓瘤。', '[]', '["礼来","默沙东","辉瑞","吉利德","安进"]'),

-- 14. Sanofi 赛诺菲
('赛诺菲', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'SNY', '纳斯达克', 'AI驱动生物药;ALTUVIIIO 2025破十亿;收购Blueprint/Dynavax;Tolebrutinib待EU审批', '["Dupixent竞争","疫苗需求波动","BD整合"]', '约$5000亿', '~7%', '免疫+罕见病+疫苗三线', 'BD整合与管线兑现', 2, '欧洲主导', 'race', '赛诺菲2025 +8.7%增长,12个新药/疫苗贡献€3.9B;ALTUVIIIO血友病破十亿;收购Blueprint(2026Q1关闭)/Dynavax;amlitelimab AD III期阳性。', '[]', '["礼来","诺华","GSK","阿斯利康","辉瑞"]'),

-- 15. GSK 葛兰素史克
('GSK', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'GSK', '纽交所', '疫苗+HIV+呼吸;2025年5/5获批;收购IDRx($1B)布局GIST;AI合作对冲专利悬崖', '["HIV竞争(吉利德)","疫苗需求波动","专利悬崖"]', '约$4200亿', '~5%', '疫苗龙头+HIV加速', 'HIV与camlipixant兑现', 2, '欧洲主导', 'race', 'GSK 2025年5/5获批率,13个III期阳性;camlipixant慢性咳嗽CALM-2 2026年中;cabotegravir HIV开发半年/年制剂;收购IDRx($1.15B)获GIST药物(53%响应率)。', '[]', '["赛诺菲","辉瑞","吉利德","默沙东"]'),

-- 16. Regeneron 再生元
('再生元', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'REGN', '纳斯达克', '科学优先;~$6B R&D;EYLEA HD+66% YoY;~45个临床项目瞄准$200B市场', '["EYLEA LOE(拜耳/罗氏竞争)","BD谨慎","Dupixent依赖"]', '约$1500亿', '~8%', '眼科+免疫双龙头,内部研发', 'fianlimab与cemdisiran兑现', 2, '美国主导', 'race', '再生元~$6B R&D(2026),对行业BD持谨慎态度(行业交易IRR~8%,licensing 18%>M&A 4%);EYLEA HD占美国净销售47%(+66% YoY);fianlimab+Libtayo黑色素瘤III期(2026H1)。', '[]', '["礼来","罗氏","诺华","艾伯维"]'),

-- 17. Merck KGaA 默克(德)
('默克(德)', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'MKKGY', 'OTC', '三大板块:医疗/生命科学/电子;生物工艺解决方案服务生物药制造;Bavencio+Mavenclad', '["生物工艺周期性","肿瘤竞争","电子业务波动"]', '约$2300亿', '~4%', '生命科学(生物工艺)+医疗双轮', '生物工艺需求复苏', 2, '欧洲主导', 'race', '默克(德)三大板块均衡:医疗(Bavencio/Mavenclad/Erbitux)、生命科学(生物工艺培养基/色谱)、电子;生物工艺需求复苏预期;生殖领域全球领先(Gonal-f)。', '[]', '["赛诺菲","辉瑞","赛默飞","赛多利斯"]'),

-- 18. UCB 优时比
('UCB', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'UCB', '布鲁塞尔', '神经+免疫专科;bimekizumab(IL-17A/F)扩张;EVENITY骨质疏松(与安进合作)', '["bimekizumab竞争(诺华)","癫痫仿制","骨质疏松市场"]', '约$700亿', '~8%', '神经+免疫专科龙头', 'bimekizumab适应症扩张', 2, '欧洲主导', 'race', 'UCB"十年以上增长轨迹",bimekizumab(IL-17A/F)银屑病/PsA/axSpA扩张;EVENITY骨质疏松(与安进合作);Briviact/Vimpat癫痫 franchise。', '[]', '["诺华","安进","渤健","礼来"]'),

-- 19. Takeda 武田
('武田', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'TAK', '纽交所', '4大核心领域创新驱动;Entyvio IBD领导力;罕见病(溶酶体贮积症);Vyvanse ADHD', '["Entyvio生物类似药","专利悬崖","日本市场"]', '约$3000亿', '~2%', '消化+罕见病龙头', '管线推进与外部创新', 2, '日本主导', 'race', '武田4大核心领域(肿瘤/罕见病/神经/消化)创新驱动;Entyvio IBD持续领导;罕见病溶酶体贮积症(Hunter/Fabry/HAE);Vyvanse ADHD franchise。', '[]', '["礼来","安进","阿斯利康","诺华"]'),

-- 20. Bayer 拜耳
('拜耳', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'BAYRY', 'OTC', '制药 turnaround;2026最后平年,2027起中个位数增长;Nubeqa €1.7B;asundexian III期', '["Xarelto LOE","Eylea LOE","农业业务拖累"]', '约$5000亿', '~3%', '肿瘤+心血管 turnaround', 'asundexian与Kerendia兑现', 2, '欧洲主导', 'race', '拜耳制药"clear proof points" turnaround,2026最后平年,2027起中个位数增长;asundexian口服抗凝药III期(2026末潜在FDA获批);Nubeqa €1.7B;Kerendia~€600M。', '[]', '["礼来","辉瑞","强生","罗氏","诺华"]'),

-- 21. Daiichi Sankyo 第一三共
('第一三共', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'DSNKY', 'OTC', 'DXd ADC平台核心差异化;与阿斯利康合作Enhertu/Dato-DXd;FY2026营收~¥2.1T(+11%)', '["ADC竞争加剧","合作依赖阿斯利康","管线验证"]', '约$1100亿', '~11%', 'ADC平台全球领导者,中国biotech对标', 'DXd平台新靶点扩张', 3, '日本主导', 'race', '第一三共DXd(deruxtecan)ADC平台为核心差异化;Enhertu(HER2 ADC)持续扩适应症;Dato-DXd(TROP2 ADC)乳腺/NSCLC;与阿斯利康合作;FY2026营收~¥2.1T(+11%)。', '[]', '["阿斯利康","礼来","罗氏","辉瑞","默沙东"]'),

-- 22. Biogen 渤健
('渤健', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'BIIB', '纳斯达克', '转型完成($1B节约);LEQEMBI阿尔茨海默;4个首创药上市;R&D降低26%', '["MS营收下滑","LEQEMBI渗透率","litifilimab数据"]', '约$1000亿', '~3%', '阿尔茨海默+神经专科', 'LEQEMBI与litifilimab兑现', 2, '美国主导', 'race', '渤健Fit for Growth转型完成($1B节约,~15%裁员);LEQEMBI SC-AI 2026Q2-Q3审批;litifilimab SLE III期(TOPAZ-1/2)年底读出;4个首创药(LEQEMBI/SKYCLARYS/ZURZUVAE/QALSODY)。', '[]', '["礼来","罗氏","福泰制药","UCB"]'),

-- 23. Astellas Pharma 安斯泰来
('安斯泰来', 'bio', '生物医药', 'm6', '全球创新药龙头(JPM 23)', 'down', 'ALPMY', 'OTC', 'VALUE框架;PADCEV膀胱癌扩张;XTANDI前列腺癌;基因治疗(AT132);合作战略', '["PADCEV竞争","XTANDI仿制","基因治疗风险"]', '约$1300亿', '~4%', '肿瘤+泌尿+移植专科', 'PADCEV与基因治疗兑现', 2, '日本主导', 'race', '安斯泰来VALUE框架(创新科学→患者价值);PADCEV(与辉瑞/Seagen)膀胱癌扩张;XTANDI前列腺癌生命周期管理;Prograf移植 franchise;基因治疗AT132。', '[]', '["辉瑞","礼来","默沙东","第一三共","武田"]')

ON CONFLICT (name) DO NOTHING;
