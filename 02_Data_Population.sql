-- 1. Populate Dim_Regions (المناطق الـ 5 الرئيسية)
INSERT INTO Dim_Regions (Region_Name, City) VALUES
(N'القاهرة الجديدة (New Cairo)', N'القاهرة'),
(N'الشيخ زايد (Sheikh Zayed)', N'الجيزة'),
(N'العاصمة الإدارية (New Capital)', N'القاهرة'),
(N'الساحل الشمالي (North Coast)', N'مطروح'),
(N'مستقبل سيتي (Mostakbal City)', N'القاهرة');
GO

-- 2. Populate Dim_Brokers (شركات البروكرز والعمولات)
INSERT INTO Dim_Brokers (Broker_Name, Broker_Tier, Commission_Rate_Pct) VALUES
(N'Coldwell Banker', 'Tier A', 3.50),
(N'RE/MAX Egypt', 'Tier A', 4.00),
(N'Nawy', 'Tier A', 3.75),
(N'The Address Investments', 'Tier B', 3.00),
(N'B2B Investment', 'Tier B', 3.25),
(N'Era Egypt', 'Tier C', 2.50);
GO

-- 3. Populate Dim_Agents (فريق المبيعات الداخلي)
INSERT INTO Dim_Agents (Agent_Name, Team_Leader, Monthly_Target, Agent_Commission_Pct) VALUES
(N'أحمد ممدوح', N'عمر الشريف', 15000000.00, 0.75),
(N'سارة حسن', N'عمر الشريف', 12000000.00, 0.75),
(N'محمود طاهر', N'خالد الصاوي', 18000000.00, 0.80),
(N'مي عز الدين', N'خالد الصاوي', 10000000.00, 0.70),
(N'كريم عبد العزيز', N'عمر الشريف', 20000000.00, 0.85);
GO

-- 4. Populate Dim_Customers (عينات المشتريين)
INSERT INTO Dim_Customers (Buyer_Name, Lead_Source, Buyer_Nationality) VALUES
(N'محمد علي', N'Social Media', N'مصري'),
(N'خالد عبد الله', N'Referral', N'سعودي'),
(N'طارق الفايد', N'Event', N'إماراتي'),
(N'منى زكي', N'Cold Call', N'مصري'),
(N'حسن الشافعي', N'Social Media', N'كويتي'),
(N'هشام عرفات', N'Referral', N'مصري'),
(N'رانيا يوسف', N'Event', N'مصري'),
(N'يوسف الشريف', N'Social Media', N'ألماني');
GO

-- 5. Populate Dim_Properties (نماذج العقارات والوحدات وتكلفة BUA)
INSERT INTO Dim_Properties (Region_ID, Project_Name, Property_Type, Area_SQM, BUA_Cost_per_SQM, Unit_Status) VALUES
(1, N'Palm Hills New Cairo', 'Apartment', 160.00, 18000.00, 'Sold'),
(1, N'Mivida', 'Villa', 320.00, 22000.00, 'Sold'),
(2, N'Zed Towers', 'Apartment', 140.00, 25000.00, 'Sold'),
(2, N'Allegria', 'Villa', 450.00, 28000.00, 'Sold'),
(3, N'Il Bosco', 'Townhouse', 220.00, 16000.00, 'Sold'),
(3, N'Castle Landmark', 'Apartment', 180.00, 15000.00, 'Sold'),
(4, N'Hacienda Bay', 'Villa', 400.00, 35000.00, 'Sold'),
(4, N'Marassi', 'Townhouse', 250.00, 38000.00, 'Sold'),
(5, N'Bloomfields', 'Apartment', 150.00, 14000.00, 'Sold'),
(5, N'Il Bosco City', 'Townhouse', 210.00, 15500.00, 'Sold'),
(1, N'Villette', 'Commercial', 90.00, 45000.00, 'Sold'),
(3, N'Financial District Mall', 'Commercial', 120.00, 50000.00, 'Sold');
GO

-- 6. Populate Fact_Sales (المبيعات للـ 6 أشهر الأخيرة: أبريل 2026 - سبتمبر 2026)
INSERT INTO Fact_Sales 
(Sale_Date, Property_ID, Buyer_ID, Agent_ID, Broker_ID, Sales_Channel, Sale_Price, Payment_Plan_Years, Down_Payment_Amount) 
VALUES
('2026-04-10', 1001, 1, 201, 501, 'Broker', 4800000.00, 7, 480000.00),
('2026-04-18', 1002, 2, 203, NULL, 'Direct', 14500000.00, 8, 1450000.00),
('2026-05-05', 1003, 3, 202, 502, 'Broker', 6200000.00, 6, 620000.00),
('2026-05-22', 1004, 4, 205, NULL, 'Direct', 22000000.00, 5, 3300000.00),
('2026-06-12', 1005, 5, 204, 503, 'Broker', 7800000.00, 7, 780000.00),
('2026-06-29', 1006, 6, 201, NULL, 'Direct', 5100000.00, 8, 510000.00),
('2026-07-04', 1007, 7, 203, 501, 'Broker', 28000000.00, 6, 4200000.00),
('2026-07-19', 1008, 8, 205, 504, 'Broker', 18500000.00, 7, 2775000.00),
('2026-08-08', 1009, 1, 202, NULL, 'Direct', 4200000.00, 8, 420000.00),
('2026-08-23', 1010, 3, 204, 505, 'Broker', 6900000.00, 7, 690000.00),
('2026-09-02', 1011, 2, 201, 506, 'Broker', 8500000.00, 5, 1700000.00),
('2026-09-27', 1012, 5, 203, NULL, 'Direct', 11000000.00, 6, 2200000.00);
GO
