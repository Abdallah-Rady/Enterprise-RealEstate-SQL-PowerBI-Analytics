-- Q1: ترتيب العملاء والمبيعات (Agent Ranking)
-- السؤال: كيف يمكنك ترتيب المبيعات (Agents) حسب كفاءة تحقيق التارجت المالي خلال الـ 6 أشهر الماضية مع إظهار رتبة كل مبيعات؟
-- المفهوم التقني: DENSE_RANK() Window Function & CTEs

WITH Agent_Performance AS (
    SELECT 
        a.Agent_ID,
        a.Agent_Name,
        SUM(a.Monthly_Target * 6) AS Total_6M_Target,
        SUM(f.Sale_Price) AS Total_Achieved_Sales,
        ROUND((SUM(f.Sale_Price) / SUM(a.Monthly_Target * 6)) * 100, 2) AS Target_Attainment_Pct
    FROM Fact_Sales f
    INNER JOIN Dim_Agents a ON f.Agent_ID = a.Agent_ID
    GROUP BY a.Agent_ID, a.Agent_Name
)
SELECT 
    Agent_Name,
    Total_Achieved_Sales,
    Total_6M_Target,
    Target_Attainment_Pct,
    DENSE_RANK() OVER (ORDER BY Target_Attainment_Pct DESC) AS Agent_Rank
FROM Agent_Performance;


-- Q2: مقارنة المبيعات شهراً بشهر ومعدل النمو (Month-over-Month Growth Rate)
-- السؤال: احسب إجمالي المبيعات لكل شهر ومعدل التغير المئوي (MoM Growth %) مقارنة بالشهر السابق مباشرة.
-- المفهوم التقني: LAG() Window Function
WITH Monthly_Sales AS (
    SELECT 
        FORMAT(Sale_Date, 'yyyy-MM') AS Sales_Month,
        SUM(Sale_Price) AS Current_Month_Sales
    FROM Fact_Sales
    GROUP BY FORMAT(Sale_Date, 'yyyy-MM')
)
SELECT 
    Sales_Month,
    Current_Month_Sales,
    LAG(Current_Month_Sales, 1) OVER (ORDER BY Sales_Month) AS Previous_Month_Sales,
    ROUND(
        ((Current_Month_Sales - LAG(Current_Month_Sales, 1) OVER (ORDER BY Sales_Month)) 
        / LAG(Current_Month_Sales, 1) OVER (ORDER BY Sales_Month)) * 100, 2
    ) AS MoM_Growth_Pct
FROM Monthly_Sales;


-- Q3: إجمالي المبيعات التراكمي عبر الزمن (Running Total / Cumulative Sales)
-- السؤال: احسب المبيعات اليومية مع حساب الإيراد التراكمي المستمر (Running Total) على مدار الفترة التشغيلية.
-- المفهوم التقني: SUM() OVER (ORDER BY ...) Cumulative Aggregation
SELECT 
    Sale_Date,
    SUM(Sale_Price) AS Daily_Sales,
    SUM(SUM(Sale_Price)) OVER (ORDER BY Sale_Date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_Total_Sales
FROM Fact_Sales
GROUP BY Sale_Date;


-- Q4: تحليل صافي الربحية لقنوات البيع (Broker vs. Direct Margin & Leakage)
-- السؤال: قارن بين أداء المبيعات المباشرة (Direct) والبروكورز (Brokers) من حيث صافي الربح بعد خصم عمولات البروكر وتكلفة الإنشاء (BUA).
-- المفهوم التقني: Conditional Aggregation & Multi-Table Joins

SELECT 
    f.Sales_Channel,
    COUNT(f.Sale_ID) AS Total_Units_Sold,
    SUM(f.Sale_Price) AS Gross_Revenue,
    SUM(p.Area_SQM * p.BUA_Cost_per_SQM) AS Total_Construction_Cost,
    SUM(CASE WHEN f.Sales_Channel = 'Broker' THEN f.Sale_Price * (b.Commission_Rate_Pct / 100.0) ELSE 0 END) AS Total_Broker_Commissions,
    SUM(f.Sale_Price) - (SUM(p.Area_SQM * p.BUA_Cost_per_SQM) + SUM(CASE WHEN f.Sales_Channel = 'Broker' THEN f.Sale_Price * (b.Commission_Rate_Pct / 100.0) ELSE 0 END)) AS Net_Profit,
    ROUND(
        ((SUM(f.Sale_Price) - (SUM(p.Area_SQM * p.BUA_Cost_per_SQM) + SUM(CASE WHEN f.Sales_Channel = 'Broker' THEN f.Sale_Price * (b.Commission_Rate_Pct / 100.0) ELSE 0 END))) / SUM(f.Sale_Price)) * 100, 2
    ) AS Net_Margin_Pct
FROM Fact_Sales f
INNER JOIN Dim_Properties p ON f.Property_ID = p.Property_ID
LEFT JOIN Dim_Brokers b ON f.Broker_ID = b.Broker_ID
GROUP BY f.Sales_Channel;


-- Q5: تحليل أداء المناطق الـ 5 وسعر المتر (Regional Price & SQM Benchmark)
-- السؤال: احسب متوسط سعر المتر المربع (Avg Price / SQM) وحصة كل منطقة مئوية من إجمالي مبيعات الشركة (Market Share %).
-- المفهوم التقني: Window Subqueries / RATIO_TO_REPORT simulation

WITH Regional_Summary AS (
    SELECT 
        r.Region_Name,
        SUM(f.Sale_Price) AS Region_Revenue,
        SUM(p.Area_SQM) AS Total_Area_Sold
    FROM Fact_Sales f
    INNER JOIN Dim_Properties p ON f.Property_ID = p.Property_ID
    INNER JOIN Dim_Regions r ON p.Region_ID = r.Region_ID
    GROUP BY r.Region_Name
)
SELECT 
    Region_Name,
    Region_Revenue,
    ROUND(Region_Revenue / Total_Area_Sold, 2) AS Avg_Price_Per_SQM,
    ROUND((Region_Revenue / SUM(Region_Revenue) OVER()) * 100, 2) AS Revenue_Share_Pct
FROM Regional_Summary
ORDER BY Region_Revenue DESC;


-- Q6: تصنيف شركات البروكرز (Broker Tier Performance & Average Ticket Size)
-- السؤال: ما هي الفئات الأكثر ربحية من البروكرز (Tier A, B, C) وما هو متوسط قيمة الصفقة الواحدة (Average Deal Size) لكل فئة؟
-- المفهوم التقني: Aggregations over Foreign Hierarchies

SELECT 
    b.Broker_Tier,
    COUNT(f.Sale_ID) AS Total_Deals,
    SUM(f.Sale_Price) AS Total_Broker_Sales,
    AVG(f.Sale_Price) AS Avg_Deal_Size,
    SUM(f.Sale_Price * (b.Commission_Rate_Pct / 100.0)) AS Total_Commissions_Earned
FROM Fact_Sales f
INNER JOIN Dim_Brokers b ON f.Broker_ID = b.Broker_ID
GROUP BY b.Broker_Tier
ORDER BY Total_Broker_Sales DESC;


-- Q7: تحويل المناطق إلى أعمدة (Cross-Tabulation / Regional Sales Matrix)
-- السؤال: اعرض جدول مبيعات شهري يوضح إجمالي المبيعات لكل منطقة في عمود منفصل لكل شهر (Monthly Sales Matrix).
-- المفهوم التقني: Dynamic Pivot / Conditional CASE WHEN Aggregation

SELECT 
    FORMAT(f.Sale_Date, 'yyyy-MM') AS Sales_Month,
    SUM(CASE WHEN r.Region_Name LIKE N'%القاهرة الجديدة%' THEN f.Sale_Price ELSE 0 END) AS [New_Cairo],
    SUM(CASE WHEN r.Region_Name LIKE N'%الشيخ زايد%' THEN f.Sale_Price ELSE 0 END) AS [Sheikh_Zayed],
    SUM(CASE WHEN r.Region_Name LIKE N'%العاصمة الإدارية%' THEN f.Sale_Price ELSE 0 END) AS [New_Capital],
    SUM(CASE WHEN r.Region_Name LIKE N'%الساحل الشمالي%' THEN f.Sale_Price ELSE 0 END) AS [North_Coast],
    SUM(CASE WHEN r.Region_Name LIKE N'%مستقبل سيتي%' THEN f.Sale_Price ELSE 0 END) AS [Mostakbal_City]
FROM Fact_Sales f
INNER JOIN Dim_Properties p ON f.Property_ID = p.Property_ID
INNER JOIN Dim_Regions r ON p.Region_ID = r.Region_ID
GROUP BY FORMAT(f.Sale_Date, 'yyyy-MM')
ORDER BY Sales_Month;

-- Q8: كشف كبار المشتريين المصنفين حسب الجنسية والدفع المقدم (High-Value Buyers)
-- السؤال: استخرج المشتريين الذين تجاوزت قيمة مشترياتهم 10 مليون جنيه مع تحديد نسبة المقدم المدفوع (Down Payment Ratio %).
-- المفهوم التقني: HAVING Clause & Mathematical Ratios

SELECT 
    c.Buyer_Name,
    c.Buyer_Nationality,
    c.Lead_Source,
    COUNT(f.Sale_ID) AS Total_Properties_Bought,
    SUM(f.Sale_Price) AS Total_Spent,
    ROUND((SUM(f.Down_Payment_Amount) / SUM(f.Sale_Price)) * 100, 2) AS Avg_Down_Payment_Pct
FROM Fact_Sales f
INNER JOIN Dim_Customers c ON f.Buyer_ID = c.Buyer_ID
GROUP BY c.Buyer_Name, c.Buyer_Nationality, c.Lead_Source
HAVING SUM(f.Sale_Price) >= 10000000.00
ORDER BY Total_Spent DESC


-- Q9: تصنيف نوع العقار الأكثر مبيعاً والأعلى ربحاً (Property Type Profitability)
-- السؤال: قارن بين الفيلات، الشقق، التجاري، والتاون هاوس من حيث حجم المبيعات ونسبة هامش الربح التشغيلي لكل نوع.
-- المفهوم التقني: Multi-Metric Aggregation & Category Analysis

SELECT 
    p.Property_Type,
    COUNT(f.Sale_ID) AS Units_Sold,
    SUM(f.Sale_Price) AS Total_Revenue,
    AVG(p.Area_SQM) AS Avg_Unit_Area,
    SUM(f.Sale_Price - (p.Area_SQM * p.BUA_Cost_per_SQM)) AS Estimated_Gross_Profit,
    ROUND((SUM(f.Sale_Price - (p.Area_SQM * p.BUA_Cost_per_SQM)) / SUM(f.Sale_Price)) * 100, 2) AS Gross_Margin_Pct
FROM Fact_Sales f
INNER JOIN Dim_Properties p ON f.Property_ID = p.Property_ID
GROUP BY p.Property_Type
ORDER BY Total_Revenue DESC;

-- Q10: تحديد المبيعات الأفضل في كل منطقة (Top Agent per Region)
-- السؤال: ما هو اسم أفضل مسؤول مبيعات (Top Agent) تحقق أعلى إيراد في كل منطقة على حدة؟
-- المفهوم التقني: ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)

WITH Regional_Agent_Sales AS (
    SELECT 
        r.Region_Name,
        a.Agent_Name,
        SUM(f.Sale_Price) AS Total_Agent_Regional_Sales,
        ROW_NUMBER() OVER (PARTITION BY r.Region_Name ORDER BY SUM(f.Sale_Price) DESC) AS Sales_Rank
    FROM Fact_Sales f
    INNER JOIN Dim_Agents a ON f.Agent_ID = a.Agent_ID
    INNER JOIN Dim_Properties p ON f.Property_ID = p.Property_ID
    INNER JOIN Dim_Regions r ON p.Region_ID = r.Region_ID
    GROUP BY r.Region_Name, a.Agent_Name
)
SELECT 
    Region_Name,
    Agent_Name AS Top_Regional_Agent,
    Total_Agent_Regional_Sales
FROM Regional_Agent_Sales
WHERE Sales_Rank = 1
ORDER BY Total_Agent_Regional_Sales DESC;
