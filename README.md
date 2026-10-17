# 🏢 Enterprise Real Estate Analytics System
### *End-to-End BI Pipeline: SQL Server 2019 + Power BI + Advanced Financial Analytics*

![SQL Server](https://img.shields.io/badge/SQL%20Server-2019-red?style=flat&logo=microsoft-sql-server)
![Power BI](https://img.shields.io/badge/Power%20BI-Executive%20Dashboard-yellow?style=flat&logo=power-bi)
![DAX](https://img.shields.io/badge/DAX-Advanced%20Measures-blue)
![Data Modeling](https://img.shields.io/badge/Data%20Model-Star%20Schema-green)

---

## 📌 Executive Summary

This project delivers an end-to-end Business Intelligence solution tailored for executive-level decision-making in the Egyptian real estate market. It evaluates transactional performance across **5 key economic regions** (*New Cairo, Sheikh Zayed, New Capital, North Coast, and Mostakbal City*).

The analytics pipeline addresses three core corporate functions:
1. **Executive Leadership (CEO/Board):** Track macro revenue trends, net profit margins, and overall target attainment.
2. **Sales & Channel Management:** Monitor sales agent performance and measure third-party broker contribution vs. direct acquisition channels.
3. **Financial Leadership (CFO/Finance):** Analyze cash collection cycles, down payment inflows, BUA construction cost dynamics, and long-term receivables portfolio management.

---

## 🗄️ 1. Database Architecture & SQL Engineering (`SQL Server 2019`)

The database was architected from scratch using a normalized **Star Schema** model to optimize Data Query Language (DQL) performance and streamline analytical reporting in Power BI.

### 🔷 A. DDL Schema Definition (`01_Schema_DDL.sql`)
Relational structure enforcing Primary and Foreign Key constraints:

```sql
-- Create Database
CREATE DATABASE RealEstate_Analytics_DB;
GO
USE RealEstate_Analytics_DB;
GO

-- 1. Dim_Regions
CREATE TABLE Dim_Regions (
    Region_ID INT PRIMARY KEY IDENTITY(1,1),
    Region_Name NVARCHAR(100) NOT NULL,
    Governorate NVARCHAR(100) NOT NULL
);

-- 2. Dim_Properties
CREATE TABLE Dim_Properties (
    Property_ID INT PRIMARY KEY IDENTITY(101,1),
    Project_Name NVARCHAR(150) NOT NULL,
    Property_Type NVARCHAR(50) NOT NULL,
    Area_SQM DECIMAL(10,2) NOT NULL,
    BUA_Cost_Per_SQM DECIMAL(10,2) NOT NULL,
    Region_ID INT FOREIGN KEY REFERENCES Dim_Regions(Region_ID)
);

-- 3. Dim_Agents
CREATE TABLE Dim_Agents (
    Agent_ID INT PRIMARY KEY IDENTITY(1,1),
    Agent_Name NVARCHAR(100) NOT NULL,
    Agent_Target DECIMAL(15,2) NOT NULL,
    Agent_Commission_Pct DECIMAL(5,2) DEFAULT 1.00
);

-- 4. Dim_Brokers
CREATE TABLE Dim_Brokers (
    Broker_ID INT PRIMARY KEY IDENTITY(501,1),
    Broker_Name NVARCHAR(150) NOT NULL,
    Broker_Commission_Pct DECIMAL(5,2) DEFAULT 2.50
);

-- 5. Dim_Customers
CREATE TABLE Dim_Customers (
    Customer_ID INT PRIMARY KEY IDENTITY(1001,1),
    Customer_Name NVARCHAR(150) NOT NULL,
    Age INT NOT NULL,
    Gender NVARCHAR(10) CHECK (Gender IN ('Male', 'Female'))
);

-- 6. Fact_Sales Table
CREATE TABLE Fact_Sales (
    Sale_ID INT PRIMARY KEY IDENTITY(1,1),
    Sale_Date DATE NOT NULL,
    Property_ID INT FOREIGN KEY REFERENCES Dim_Properties(Property_ID),
    Customer_ID INT FOREIGN KEY REFERENCES Dim_Customers(Customer_ID),
    Agent_ID INT FOREIGN KEY REFERENCES Dim_Agents(Agent_ID),
    Broker_ID INT NULL FOREIGN KEY REFERENCES Dim_Brokers(Broker_ID),
    Sales_Channel NVARCHAR(20) CHECK (Sales_Channel IN ('Direct', 'Broker')),
    Sale_Price DECIMAL(15,2) NOT NULL,
    Down_Payment_Pct DECIMAL(5,2) NOT NULL,
    Payment_Plan_Years INT NOT NULL
);
🔷 B. Analytical Business SQL Queries (03_Advanced_SQL_Queries.sql)
1️⃣ Regional BUA Cost vs. Net Profit Margin Analysis
SQL
SELECT 
    r.Region_Name,
    SUM(f.Sale_Price) AS Total_Revenue,
    SUM(p.Area_SQM * p.BUA_Cost_Per_SQM) AS Total_BUA_Cost,
    SUM(f.Sale_Price) - SUM(p.Area_SQM * p.BUA_Cost_Per_SQM) AS Net_Profit,
    ROUND((SUM(f.Sale_Price) - SUM(p.Area_SQM * p.BUA_Cost_Per_SQM)) / SUM(f.Sale_Price) * 100, 2) AS Profit_Margin_Pct
FROM Fact_Sales f
JOIN Dim_Properties p ON f.Property_ID = p.Property_ID
JOIN Dim_Regions r ON p.Region_ID = r.Region_ID
GROUP BY r.Region_Name
ORDER BY Total_Revenue DESC;
2️⃣ Sales Channel Revenue Attribution (Window Aggregate Function)
SQL
SELECT 
    f.Sales_Channel,
    COUNT(f.Sale_ID) AS Total_Units_Sold,
    SUM(f.Sale_Price) AS Total_Channel_Revenue,
    ROUND(SUM(f.Sale_Price) * 100.0 / SUM(SUM(f.Sale_Price)) OVER(), 2) AS Revenue_Contribution_Pct
FROM Fact_Sales f
GROUP BY f.Sales_Channel;
📐 2. Power BI Data Modeling & DAX Calculation Engine
🧮 Core DAX Measures Implemented
مقتطف الرمز
// 1. Total Revenue
Total Revenue = SUM(Fact_Sales[Sale_Price])

// 2. Total Down Payment Collected
Total Down Payment = SUMX(Fact_Sales, Fact_Sales[Sale_Price] * (Fact_Sales[Down_Payment_Pct] / 100))

// 3. Remaining Receivables Portfolio
Remaining Receivables = [Total Revenue] - [Total Down Payment]

// 4. Total BUA Construction Cost
Total BUA Cost = SUMX(Fact_Sales, RELATED(Dim_Properties[Area_SQM]) * RELATED(Dim_Properties[BUA_Cost_Per_SQM]))

// 5. Total Broker Commission Expense
Total Broker Commission = 
CALCULATE(
    SUMX(Fact_Sales, Fact_Sales[Sale_Price] * (RELATED(Dim_Brokers[Broker_Commission_Pct]) / 100)),
    Fact_Sales[Sales_Channel] = "Broker"
)

// 6. Net Profit
Net Profit = [Total Revenue] - [Total BUA Cost] - [Total Broker Commission]

// 7. Net Margin Percentage
Net Margin Pct = DIVIDE([Net Profit], [Total Revenue], 0)

// 8. Collection Rate Percentage
Collection Rate Pct = DIVIDE([Total Down Payment], [Total Revenue], 0)

// 9. Target Attainment Percentage
Target Attainment Pct = 
DIVIDE(
    [Total Revenue],
    SUM(Dim_Agents[Agent_Target]),
    0
)
📊 3. Executive Dashboard Architecture (4-Page Suite)
Designed using an Executive Dark Slate Theme (#0F172A background, #1E293B containers, #38BDF8 accents):

Page 1: Executive Overview — Macro revenue trends, MoM growth, and high-level KPIs.

Page 2: Regional & Property Analytics — Price per SQM metrics, unit distributions, and regional revenue share.

Page 3: Sales Performance & Channel Analytics — Agent ranking vs. target, broker commissions, and channel splits.

Page 4: Financial & Cash Collection Overview — CFO cash collection tracker, receivables vs. collected down payments, and P&L breakdown.
