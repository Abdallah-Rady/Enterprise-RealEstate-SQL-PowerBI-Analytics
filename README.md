# 🏢 Enterprise Real Estate Analytics System
### *End-to-End Business Intelligence Pipeline: SQL Server 2019 + Power BI*

![SQL Server](https://img.shields.io/badge/SQL%20Server-2019-red?style=flat&logo=microsoft-sql-server)
![Power BI](https://img.shields.io/badge/Power%20BI-Executive%20Dashboard-yellow?style=flat&logo=power-bi)
![DAX](https://img.shields.io/badge/DAX-Advanced%20Measures-blue)
![Data Modeling](https://img.shields.io/badge/Data%20Model-Star%20Schema-green)

---

## 📌 Executive Summary

This project delivers an end-to-end Enterprise Business Intelligence pipeline analyzing transactional performance across **5 premier real estate regions** in Egypt (*New Cairo, Sheikh Zayed, New Capital, North Coast, and Mostakbal City*).

The solution covers the entire data lifecycle: **Database Architecture & DDL Design ➡️ Advanced SQL Analytics ➡️ Star-Schema Data Modeling ➡️ Executive Financial Reporting in Power BI**.

---

## 🗂️ Project Repository Structure

* [`01_Schema_DDL.sql`](./01_Schema_DDL.sql): Relational DDL script defining Primary/Foreign Keys, Constraints, and Star Schema tables (`Fact_Sales`, `Dim_Properties`, `Dim_Regions`, `Dim_Agents`, `Dim_Brokers`, `Dim_Customers`).
* [`02_Data_Population.sql`](./02_Data_Population.sql): Synthetic transaction dataset simulating realistic real estate sales, down payments, BUA costs, and payment plans.
* [`03_Advanced_SQL_Queries.sql`](./03_Advanced_SQL_Queries.sql): Complex DQL queries utilizing SQL Window Functions, Multi-table Joins, and Regional Profitability Aggregations.
* **`Real_Estate_Executive_Dashboard.pbix`**: Interactive 4-page Power BI dashboard file.

---

## 🛠️ Data Pipeline & Technical Architecture

### 1️⃣ Database & Data Engineering (SQL Server 2019)
* Designed a normalized **Star Schema** with `Fact_Sales` at the grain of individual unit transactions.
* Established strict data integrity constraints and indexed foreign key relationships.
* Authored analytical queries to validate regional BUA (Built-Up Area) construction costs, broker commissions, and channel margins directly at the database layer.

### 2️⃣ Power BI Data Modeling & DAX Calculation Engine
* Connected Power BI to SQL Server with a clean 1-to-Many single-direction relationship model.
* Engineered 10+ advanced DAX measures to support dynamic business logic and time intelligence.

#### 🧮 Key DAX Measures Implemented:

```dax
// Total Revenue Generated
Total Revenue = SUM(Fact_Sales[Sale_Price])

// Cash Collected via Down Payments
Total Down Payment = SUMX(Fact_Sales, Fact_Sales[Sale_Price] * (Fact_Sales[Down_Payment_Pct] / 100))

// Future Installments Receivable Portfolio
Remaining Receivables = [Total Revenue] - [Total Down Payment]

// Total Construction Cost (Area SQM * BUA Cost/SQM)
Total BUA Cost = SUMX(Fact_Sales, RELATED(Dim_Properties[Area_SQM]) * RELATED(Dim_Properties[BUA_Cost_Per_SQM]))

// Broker Commission Expense Leakage
Total Broker Commission = 
CALCULATE(
    SUMX(Fact_Sales, Fact_Sales[Sale_Price] * (RELATED(Dim_Brokers[Broker_Commission_Pct]) / 100)),
    Fact_Sales[Sales_Channel] = "Broker"
)

// Net Profit After Costs & Commissions
Net Profit = [Total Revenue] - [Total BUA Cost] - [Total Broker Commission]

// Profitability & Cash Flow Percentages
Net Margin Pct = DIVIDE([Net Profit], [Total Revenue], 0)
Collection Rate Pct = DIVIDE([Total Down Payment], [Total Revenue], 0)
