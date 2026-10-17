# 🏢 Enterprise Real Estate Analytics System (SQL Server & Power BI)

![Database Architecture](https://img.shields.io/badge/SQL%20Server-2019-red?style=for-the-badge&logo=microsoftsqlserver)
![Analytics Tool](https://img.shields.io/badge/Power%20BI-Desktop-yellow?style=for-the-badge&logo=powerbi)
![Domain](https://img.shields.io/badge/Domain-Real%20Estate-blue?style=for-the-badge)

## 📌 Executive Overview
An enterprise-grade, End-to-End Business Intelligence & Strategic Decision-Support System designed for a leading Real Estate Developer in Egypt. The system processes transactional data across **5 key regions** (New Cairo, Sheikh Zayed, New Capital, North Coast, and Mostakbal City) covering operational performance, channel efficiency (Direct Sales vs. Brokers), BUA construction cost dynamics, and regional pricing metrics over a **6-month operational period**.

---

## 🗄️ Database Architecture & Star Schema (SQL Server 2019)
The relational database was designed in **SQL Server 2019** using a normalized **Star Schema** to ensure high query performance, data integrity, and strict Foreign Key constraints:

- **`Fact_Sales`**: Central transactional table storing property sales, down payments, payment plan tenure, and sales channel identifiers.
- **`Dim_Properties`**: Contains property specs, area ($SQM$), BUA construction costs per $SQM$, and project association.
- **`Dim_Regions`**: Maps properties to the 5 targeted geographic hubs.
- **`Dim_Brokers`**: Stores external brokerage firm details and tiered commission structures (Tier A, B, C).
- **`Dim_Agents`**: Details internal sales team targets, team leads, and commission percentages.
- **`Dim_Customers`**: Tracks buyer demographics, nationalities, and lead acquisition channels.
- **`Dim_Calendar`**: Dedicated date hierarchy for Time Intelligence calculations.

---

## ⚡ 10 Advanced SQL Analytical Queries Included
The SQL engineering phase includes 10 production-grade analytical queries answering critical business questions:
1. **Agent Performance Ranking**: `DENSE_RANK()` window function evaluating sales target attainment %.
2. **Month-over-Month (MoM) Growth**: `LAG()` function tracking monthly revenue velocity and trend shifts.
3. **Cumulative Revenue Velocity**: Running total calculations using `SUM() OVER(ORDER BY...)`.
4. **Channel Profitability & Leakage**: CTEs calculating Net Profit Margins after deducting BUA costs and broker commission payouts.
5. **Regional Market Share & SQM Benchmarks**: Calculating average price per $SQM$ and revenue contribution share per region.
6. **Broker Tier Performance**: Evaluating deal volume and average deal size across Broker Tiers (A, B, C).
7. **Monthly Regional Sales Matrix**: Cross-tabulation using conditional aggregation to display monthly regional performance in dynamic columns.
8. **High-Value Buyer Segmentation**: Identifying buyers spending $\ge 10M$ EGP and analyzing down payment ratios.
9. **Property Type Profitability**: Gross margin % comparison between Villas, Apartments, Townhouses, and Commercial units.
10. **Top Regional Agent Analysis**: `ROW_NUMBER() PARTITION BY` identifying the top-performing agent in each region.

---

## 📊 Power BI Analytics & Data Pipeline
- **Direct/Import Connection**: Integrated directly with SQL Server 2019.
- **Advanced DAX Metrics**: Time Intelligence (YoY / MoM), Dynamic Target Attainment Signals, Broker Commission Leakage, and BUA Net Margin Calculations.
- **Strategic What-If Simulator**: Interactive scenario modeling allowing executives to dynamically adjust price per $SQM$, broker commission rates, and construction cost fluctuations to forecast net profit impacts in real-time.

---

## 📁 Repository File Structure# Enterprise-RealEstate-SQL-PowerBI-Analytics
End-to-End Enterprise Real Estate Analytics System (SQL Server 2019 &amp; Power BI) featuring 10 advanced SQL analytical queries, Star Schema data modeling, and interactive strategic decision-support dashboards.
