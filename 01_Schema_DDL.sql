-- 1. Create Database
CREATE DATABASE RealEstate_Analytics_DB;
GO

USE RealEstate_Analytics_DB;
GO

-- 2. Create Dim_Regions
CREATE TABLE Dim_Regions (
    Region_ID INT PRIMARY KEY IDENTITY(1,1),
    Region_Name NVARCHAR(100) NOT NULL,
    City NVARCHAR(50) NOT NULL
);

-- 3. Create Dim_Properties
CREATE TABLE Dim_Properties (
    Property_ID INT PRIMARY KEY IDENTITY(1001,1),
    Region_ID INT FOREIGN KEY REFERENCES Dim_Regions(Region_ID),
    Project_Name NVARCHAR(100) NOT NULL,
    Property_Type NVARCHAR(50) CHECK (Property_Type IN ('Villa', 'Apartment', 'Townhouse', 'Commercial')),
    Area_SQM DECIMAL(10,2) NOT NULL,
    BUA_Cost_per_SQM DECIMAL(10,2) NOT NULL, -- تكلفة المباني لكل متر
    Unit_Status NVARCHAR(20) DEFAULT 'Available'
);

-- 4. Create Dim_Brokers
CREATE TABLE Dim_Brokers (
    Broker_ID INT PRIMARY KEY IDENTITY(501,1),
    Broker_Name NVARCHAR(100) NOT NULL,
    Broker_Tier NVARCHAR(10) CHECK (Broker_Tier IN ('Tier A', 'Tier B', 'Tier C')),
    Commission_Rate_Pct DECIMAL(5,2) NOT NULL -- مثلا 3.50 تعني 3.5%
);

-- 5. Create Dim_Agents
CREATE TABLE Dim_Agents (
    Agent_ID INT PRIMARY KEY IDENTITY(201,1),
    Agent_Name NVARCHAR(100) NOT NULL,
    Team_Leader NVARCHAR(100),
    Monthly_Target DECIMAL(12,2) NOT NULL,
    Agent_Commission_Pct DECIMAL(5,2) NOT NULL
);

-- 6. Create Dim_Customers
CREATE TABLE Dim_Customers (
    Buyer_ID INT PRIMARY KEY IDENTITY(1,1),
    Buyer_Name NVARCHAR(100) NOT NULL,
    Lead_Source NVARCHAR(50),
    Buyer_Nationality NVARCHAR(50)
);

-- 7. Create Fact_Sales
CREATE TABLE Fact_Sales (
    Sale_ID INT PRIMARY KEY IDENTITY(10001,1),
    Sale_Date DATE NOT NULL,
    Property_ID INT FOREIGN KEY REFERENCES Dim_Properties(Property_ID),
    Buyer_ID INT FOREIGN KEY REFERENCES Dim_Customers(Buyer_ID),
    Agent_ID INT FOREIGN KEY REFERENCES Dim_Agents(Agent_ID),
    Broker_ID INT NULL FOREIGN KEY REFERENCES Dim_Brokers(Broker_ID),
    Sales_Channel NVARCHAR(20) CHECK (Sales_Channel IN ('Direct', 'Broker')),
    Sale_Price DECIMAL(12,2) NOT NULL,
    Payment_Plan_Years INT NOT NULL,
    Down_Payment_Amount DECIMAL(12,2) NOT NULL
);
GO
