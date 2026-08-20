-- 1. Creating Database

CREATE DATABASE ecommerce_sales_db;

-- 2. Using Database

USE ecommerce_sales_db;

-- 3. Creating Table

CREATE TABLE ecommerce_sales (
    Order_ID VARCHAR(20),
    Order_Date DATE,
    Customer_ID VARCHAR(20),
    Customer_Name VARCHAR(100),
    Product_ID VARCHAR(20),
    Product_Name VARCHAR(100),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Quantity INT,
    Unit_Price DECIMAL(12,2),
    Discount DECIMAL(5,2),
    Sales DECIMAL(15,2),
    Profit DECIMAL(15,2),
    Region VARCHAR(30),
    City VARCHAR(50),
    Payment_Mode VARCHAR(30),
    Order_Status VARCHAR(20)
);

-- 4. Importing Data in to Database

SHOW GLOBAL VARIABLES LIKE 'local_infile';

SHOW SESSION VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'C:/Users/Vaishnavi/Downloads/Ecommerce_Sales_Dataset.csv'
INTO TABLE ecommerce_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    Order_ID,
    Order_Date,
    Customer_ID,
    Customer_Name,
    Product_ID,
    Product_Name,
    Category,
    Sub_Category,
    Quantity,
    Unit_Price,
    @Discount,
    Sales,
    Profit,
    Region,
    City,
    Payment_Mode,
    Order_Status
)
SET Discount = NULLIF(@Discount, '');

-- Total Number of rows

SELECT COUNT(*) AS Total_Rows
FROM ecommerce_sales;

-- checking first records
SELECT *
FROM ecommerce_sales
LIMIT 10;

-- checking columns

DESCRIBE ecommerce_sales;

/* 4. DATA VERIFICATION */

SELECT COUNT(*) AS Total_Rows FROM ecommerce_sales;
SELECT * FROM ecommerce_sales LIMIT 10;
SELECT MIN(Order_Date) AS First_Order_Date, MAX(Order_Date) AS Last_Order_Date
FROM ecommerce_sales;
SELECT COUNT(DISTINCT Order_ID) AS Total_Orders FROM ecommerce_sales;
SELECT COUNT(DISTINCT Customer_ID) AS Total_Customers FROM ecommerce_sales;
SELECT COUNT(DISTINCT Product_ID) AS Total_Products FROM ecommerce_sales;

/* 5. DATA UNDERSTANDING */

SELECT DISTINCT Category FROM ecommerce_sales;
SELECT DISTINCT Sub_Category FROM ecommerce_sales;
SELECT DISTINCT Region FROM ecommerce_sales;
SELECT DISTINCT Payment_Mode FROM ecommerce_sales;
SELECT DISTINCT Order_Status FROM ecommerce_sales;

/* 6. NULL CHECK (Data Quality Analysis)*/

SELECT
    COUNT(*) AS Total_Rows,
    SUM(Order_ID IS NULL) AS Null_Order_ID,
    SUM(Order_Date IS NULL) AS Null_Order_Date,
    SUM(Customer_ID IS NULL) AS Null_Customer_ID,
    SUM(Customer_Name IS NULL) AS Null_Customer_Name,
    SUM(Product_ID IS NULL) AS Null_Product_ID,
    SUM(Product_Name IS NULL) AS Null_Product_Name,
    SUM(Category IS NULL) AS Null_Category,
    SUM(Sub_Category IS NULL) AS Null_Sub_Category,
    SUM(Quantity IS NULL) AS Null_Quantity,
    SUM(Unit_Price IS NULL) AS Null_Unit_Price,
    SUM(Discount IS NULL) AS Null_Discount,
    SUM(Sales IS NULL) AS Null_Sales,
    SUM(Profit IS NULL) AS Null_Profit,
    SUM(Region IS NULL) AS Null_Region,
    SUM(City IS NULL) AS Null_City,
    SUM(Payment_Mode IS NULL) AS Null_Payment_Mode,
    SUM(Order_Status IS NULL) AS Null_Order_Status
FROM ecommerce_sales;

/* 7. Handling Null Values*/
 
-- Customer Name

SELECT *
FROM ecommerce_sales
WHERE Customer_Name IS NULL;

SELECT
    Customer_ID,
    COALESCE(Customer_Name, 'Unknown Customer') AS Customer_Name
FROM ecommerce_sales;

-- Missing Discount

SELECT *
FROM ecommerce_sales
WHERE Discount IS NULL;

SELECT
    Discount,
    COALESCE(Discount, 0) AS Discount 
    FROM ecommerce_sales;

-- 8. Check duplicate orders  
  
SELECT
    Order_ID,
    COUNT(*) AS Order_Count
FROM ecommerce_sales
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- Complete duplicates checking for each column

SELECT *,
       COUNT(*) AS Duplicate_Count
FROM ecommerce_sales
GROUP BY
    Order_ID,
    Order_Date,
    Customer_ID,
    Customer_Name,
    Product_ID,
    Product_Name,
    Category,
    Sub_Category,
    Quantity,
    Unit_Price,
    Discount,
    Sales,
    Profit,
    Region,
    City,
    Payment_Mode,
    Order_Status
HAVING COUNT(*) > 1;

/* 9. INVALID DATA CHECKS */

SELECT * FROM ecommerce_sales WHERE Quantity <= 0;
SELECT * FROM ecommerce_sales WHERE Unit_Price < 0;
SELECT * FROM ecommerce_sales WHERE Sales <= 0;
SELECT * FROM ecommerce_sales WHERE Profit < 0;
SELECT * FROM ecommerce_sales WHERE Discount < 0 OR Discount > 1;

/* 10. Validate Sales Calculation */

SELECT
    Order_ID,
    Quantity,
    Unit_Price,
    Discount,
    Sales,
    Quantity * Unit_Price * (1 - COALESCE(Discount,0)) AS Calculated_Sales
FROM ecommerce_sales
LIMIT 20;

-- Finding Mismatches

SELECT
    Order_ID,
    Sales,
    Quantity * Unit_Price * (1 - COALESCE(Discount,0)) AS Calculated_Sales
FROM ecommerce_sales
WHERE ABS(
    Sales -
    Quantity * Unit_Price * (1 - COALESCE(Discount,0))
) > 0.01;

/* 11. MAIN KPIs */
SELECT
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    COUNT(DISTINCT Product_ID) AS Total_Products,
    ROUND(SUM(Sales) / COUNT(DISTINCT Order_ID), 2) AS Average_Order_Value,
    ROUND(SUM(Profit) / SUM(Sales)  * 100, 2) AS Profit_Margin
FROM ecommerce_sales;

/* SALES ANALYSIS */

-- 12. Sales by Category

SELECT
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM ecommerce_sales
GROUP BY Category
ORDER BY Total_Sales DESC;

-- 13. Sales by Sub Category

SELECT
    Sub_Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM ecommerce_sales
GROUP BY Sub_Category
ORDER BY Total_Sales DESC;

-- 14. Monthly Sales trend

SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS Month,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM ecommerce_sales
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Month;

-- 15. Monthly Sales Analysis

SELECT
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month_Number,
    MONTHNAME(Order_Date) AS Month_Name,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM ecommerce_sales
GROUP BY YEAR(Order_Date), MONTH(Order_Date), MONTHNAME(Order_Date)
ORDER BY Year, Month_Number;

-- 16. Yearly Sales Analysis

SELECT
    YEAR(Order_Date) AS Year,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM ecommerce_sales
GROUP BY YEAR(Order_Date)
ORDER BY Year;

-- 17. QUARTERLY SALES

SELECT
    YEAR(Order_Date) AS Year,
    QUARTER(Order_Date) AS Quarter,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM ecommerce_sales
GROUP BY YEAR(Order_Date), QUARTER(Order_Date)
ORDER BY Year, Quarter;

-- 18. Sales Contribution by Region

SELECT
    Region,
    SUM(Sales) AS Total_Sales,
    ROUND(
        SUM(Sales) * 100.0 /
        (SELECT SUM(Sales) FROM ecommerce_sales),
        2
    ) AS Sales_Contribution_Percentage
FROM ecommerce_sales
GROUP BY Region
ORDER BY Total_Sales DESC;

/* PRODUCT ANALYSIS */

-- 19. Top 10 Products

SELECT 
      Product_ID, 
      Product_Name, 
      ROUND(SUM(Sales), 2) AS Total_Sales
FROM ecommerce_sales
GROUP BY Product_ID, Product_Name
ORDER BY Total_Sales DESC
LIMIT 10;

-- 20. Bottom 10 Products

SELECT
      Product_ID, 
      Product_Name, 
      ROUND(SUM(Sales), 2) AS Total_Sales
FROM ecommerce_sales
GROUP BY Product_ID, Product_Name
ORDER BY Total_Sales 
LIMIT 10;

-- 21. Ranking Products

WITH product_sales AS (
    SELECT
        Product_ID,
        Product_Name,
        SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY Product_ID, Product_Name
)

SELECT
    Product_ID,
    Product_Name,
    Total_Sales,
    RANK() OVER (ORDER BY Total_Sales DESC) AS Sales_Rank
FROM product_sales;

-- 22. Category wise product ranking

WITH product_sales AS (
    SELECT
        Category,
        Product_ID,
        Product_Name,
        SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY
        Category,
        Product_ID,
        Product_Name
)

SELECT
    Category,
    Product_ID,
    Product_Name,
    Total_Sales,
    RANK() OVER (
        PARTITION BY Category
        ORDER BY Total_Sales DESC
    ) AS Category_Rank
FROM product_sales;

-- 23. Top 3 product ranking

WITH product_sales AS (
    SELECT
        Category,
        Product_ID,
        Product_Name,
        SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY
        Category,
        Product_ID,
        Product_Name
),

ranked_products AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            PARTITION BY Category
            ORDER BY Total_Sales DESC
        ) AS Product_Rank
    FROM product_sales
)

SELECT *
FROM ranked_products
WHERE Product_Rank <= 3
ORDER BY Category, Product_Rank;

-- 24. Monthly Top Selling Products

WITH monthly_category AS (
    SELECT
        YEAR(Order_Date) AS Year,
        MONTH(Order_Date) AS Month,
        Category,
        SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY
        YEAR(Order_Date),
        MONTH(Order_Date),
        Category
),

ranked AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY Year, Month
            ORDER BY Total_Sales DESC
        ) AS Category_Rank
    FROM monthly_category
)

SELECT *
FROM ranked
WHERE Category_Rank = 1
ORDER BY Year, Month;

/* Customer Ranking */

-- 25. Top 10 Customers

SELECT
    Customer_ID,
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM ecommerce_sales
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;

-- 26. Customer Ranking

WITH customer_sales AS (
    SELECT
        Customer_ID,
        MAX(Customer_Name) AS Customer_Name,
        SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY Customer_ID
)

SELECT
    Customer_ID,
    Customer_Name,
    Total_Sales,
    RANK() OVER (
        ORDER BY Total_Sales DESC
    ) AS Customer_Rank
FROM customer_sales;

-- 27 Customer Segmentation

WITH customer_sales AS (
    SELECT
        Customer_ID,
        MAX(Customer_Name) AS Customer_Name,
        SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY Customer_ID
)

SELECT
    Customer_ID,
    Customer_Name,
    Total_Sales,
    CASE
        WHEN Total_Sales >= 100000 THEN 'High Value'
        WHEN Total_Sales >= 50000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Customer_Segment
FROM customer_sales;

-- 28. Customer Order Frequency

SELECT
    Customer_ID,
    MAX(Customer_Name) AS Customer_Name,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM ecommerce_sales
GROUP BY Customer_ID
ORDER BY Total_Orders DESC;

-- 29. Repeat Customers

SELECT
    Customer_ID,
    MAX(Customer_Name) AS Customer_Name,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Sales) AS Total_Sales
FROM ecommerce_sales
GROUP BY Customer_ID
HAVING COUNT(DISTINCT Order_ID) > 1
ORDER BY Total_Orders DESC;


/* REGIONAL ANALYSIS */

-- 30. Sales by region

SELECT
    Region,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM ecommerce_sales
GROUP BY Region
ORDER BY Total_Sales DESC;

-- 31. Profit by region

SELECT
    Region,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM ecommerce_sales
GROUP BY Region
ORDER BY Total_Profit DESC;

-- 32. Sales by city

SELECT
    City,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM ecommerce_sales
GROUP BY City
ORDER BY Total_Sales DESC;

-- 33. Sales Contribution by region

SELECT
    Region,
    SUM(Sales) AS Total_Sales,
    ROUND(
        SUM(Sales) * 100.0 /
        (SELECT SUM(Sales) FROM ecommerce_sales),
        2
    ) AS Sales_Contribution_Percentage
FROM ecommerce_sales
GROUP BY Region
ORDER BY Total_Sales DESC;

/* ORDER ANALYSIS */

-- 34. Order status analysis
SELECT
    Order_Status,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    Round(SUM(Sales),2) AS Total_Sales,
    Round(SUM(Profit),2) AS Total_Profit
FROM ecommerce_sales
GROUP BY Order_Status;

-- 35. Cancellation Rate

SELECT
    ROUND(
        SUM(CASE
            WHEN Order_Status = 'Cancelled' THEN 1
            ELSE 0
        END) * 100.0
        / COUNT(*),
        2
    ) AS Cancellation_Rate
FROM ecommerce_sales;

-- 36. Return Rate

SELECT
    ROUND(
        SUM(CASE
            WHEN Order_Status = 'Returned' THEN 1
            ELSE 0
        END) * 100.0
        / COUNT(*),
        2
    ) AS Return_Rate
FROM ecommerce_sales;

-- 37. Category wise return rate

SELECT
    Category,
    COUNT(*) AS Total_Orders,
    SUM(CASE
        WHEN Order_Status = 'Returned' THEN 1
        ELSE 0
    END) AS Returned_Orders,
    ROUND(
        SUM(CASE
            WHEN Order_Status = 'Returned' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS Return_Rate
FROM ecommerce_sales
GROUP BY Category
ORDER BY Return_Rate DESC;

 /* 38. Payment Mode Analysis */

SELECT
    Payment_Mode,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM ecommerce_sales
GROUP BY Payment_Mode
ORDER BY Total_Sales DESC;

/* 39. Discuont Analysis */

SELECT
    Discount,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin
FROM ecommerce_sales
GROUP BY Discount
ORDER BY Discount;

--  40. Does Higher discount affect profit

SELECT
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount <= 0.05 THEN '0-5%'
        WHEN Discount <= 0.10 THEN '5-10%'
        WHEN Discount <= 0.15 THEN '10-15%'
        ELSE '15%+'
    END AS Discount_Band,

    COUNT(*) AS Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND(AVG(Profit), 2) AS Average_Profit

FROM ecommerce_sales
GROUP BY
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount <= 0.05 THEN '0-5%'
        WHEN Discount <= 0.10 THEN '5-10%'
        WHEN Discount <= 0.15 THEN '10-15%'
        ELSE '15%+'
    END
ORDER BY Total_Sales DESC;

-- 41.Creating An analysis Viwe

CREATE VIEW ecommerce_analysis AS
SELECT
    Order_ID,
    Order_Date,
    Customer_ID,
    COALESCE(Customer_Name, 'Unknown Customer') AS Customer_Name,
    Product_ID,
    Product_Name,
    Category,
    Sub_Category,
    Quantity,
    Unit_Price,
    COALESCE(Discount, 0) AS Discount,
    Sales,
    Profit,
    Region,
    City,
    Payment_Mode,
    Order_Status
FROM ecommerce_sales;

-- 42 Creating A KPI query
SELECT
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    COUNT(DISTINCT Product_ID) AS Total_Products,
    SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Sales) / COUNT(DISTINCT Order_ID),
        2
    ) AS Average_Order_Value,
    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS Profit_Margin
FROM ecommerce_analysis;

SELECT *
FROM ecommerce_analysis;



