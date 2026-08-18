CREATE DATABASE ecommerce_sales_db;
USE ecommerce_sales_db;

CREATE TABLE ecommerce_sales (
    Order_ID VARCHAR(50),
    Order_Date DATE,
    Customer_ID VARCHAR(50),
    Customer_Name VARCHAR(100),
    Product_ID VARCHAR(50),
    Product_Name VARCHAR(200),
    Category VARCHAR(100),
    Sub_Category VARCHAR(100),
    Quantity INT,
    Sales DECIMAL(10,2),
    Discount DECIMAL(5,2),
    Profit DECIMAL(10,2),
    Region VARCHAR(100),
    City VARCHAR(100),
    Payment_Mode VARCHAR(50)
);

/* 1. DATA VERIFICATION */

SELECT COUNT(*) AS Total_Rows FROM ecommerce_sales;
SELECT * FROM ecommerce_sales LIMIT 10;
SELECT MIN(Order_Date) AS First_Order_Date, MAX(Order_Date) AS Last_Order_Date
FROM ecommerce_sales;
SELECT COUNT(DISTINCT Order_ID) AS Total_Orders FROM ecommerce_sales;
SELECT COUNT(DISTINCT Customer_ID) AS Total_Customers FROM ecommerce_sales;
SELECT COUNT(DISTINCT Product_ID) AS Total_Products FROM ecommerce_sales;

/* 2. DATA UNDERSTANDING */
SELECT DISTINCT Category FROM ecommerce_sales;
SELECT DISTINCT Sub_Category FROM ecommerce_sales;
SELECT DISTINCT Region FROM ecommerce_sales;
SELECT DISTINCT Payment_Mode FROM ecommerce_sales;
SELECT DISTINCT Order_Status FROM ecommerce_sales;

/* 3. NULL CHECK */
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

/* 4. DUPLICATE CHECK */
SELECT Order_ID, COUNT(*) AS Occurrences
FROM ecommerce_sales
GROUP BY Order_ID
HAVING COUNT(*) > 1
ORDER BY Occurrences DESC;

SELECT
    Order_ID, Order_Date, Customer_ID, Customer_Name, Product_ID,
    Product_Name, Category, Sub_Category, Quantity, Unit_Price,
    Discount, Sales, Profit, Region, City, Payment_Mode, Order_Status,
    COUNT(*) AS Duplicate_Count
FROM ecommerce_sales
GROUP BY
    Order_ID, Order_Date, Customer_ID, Customer_Name, Product_ID,
    Product_Name, Category, Sub_Category, Quantity, Unit_Price,
    Discount, Sales, Profit, Region, City, Payment_Mode, Order_Status
HAVING COUNT(*) > 1;

/* 5. INVALID DATA CHECKS */
SELECT * FROM ecommerce_sales WHERE Quantity <= 0;
SELECT * FROM ecommerce_sales WHERE Unit_Price < 0;
SELECT * FROM ecommerce_sales WHERE Sales < 0;
SELECT * FROM ecommerce_sales WHERE Profit < 0;
SELECT * FROM ecommerce_sales WHERE Discount < 0 OR Discount > 1;

/* 6. MAIN KPIs */
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

/* 7. CATEGORY ANALYSIS */
SELECT
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales),0)  * 100, 2) AS Profit_Margin
FROM ecommerce_sales
GROUP BY Category
ORDER BY Total_Sales DESC;

/* 8. SUB-CATEGORY ANALYSIS */
SELECT
    Sub_Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM ecommerce_sales
GROUP BY Sub_Category
ORDER BY Total_Sales DESC;

/* 9. PRODUCT ANALYSIS */
SELECT Product_ID, Product_Name, ROUND(SUM(Sales), 2) AS Total_Sales
FROM ecommerce_sales
GROUP BY Product_ID, Product_Name
ORDER BY Total_Sales DESC
LIMIT 10;

SELECT Product_ID, Product_Name, ROUND(SUM(Profit), 2) AS Total_Profit
FROM ecommerce_sales
GROUP BY Product_ID, Product_Name
ORDER BY Total_Profit DESC
LIMIT 10;

/* 10. CUSTOMER ANALYSIS */
SELECT Customer_ID, Customer_Name, ROUND(SUM(Sales), 2) AS Total_Sales
FROM ecommerce_sales
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;

SELECT
    Customer_ID, Customer_Name,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM ecommerce_sales
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Orders DESC
LIMIT 10;

/* 11. REGIONAL ANALYSIS */
SELECT
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM ecommerce_sales
GROUP BY Region
ORDER BY Total_Sales DESC;

SELECT City, ROUND(SUM(Sales), 2) AS Total_Sales,
       ROUND(SUM(Profit), 2) AS Total_Profit
FROM ecommerce_sales
GROUP BY City
ORDER BY Total_Sales DESC;

/* 12. PAYMENT ANALYSIS */
SELECT
    Payment_Mode,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM ecommerce_sales
GROUP BY Payment_Mode
ORDER BY Total_Sales DESC;

/* 13. ORDER STATUS */
SELECT
    Order_Status,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM ecommerce_sales
GROUP BY Order_Status
ORDER BY Total_Orders DESC;

SELECT
    Order_Status,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(
        COUNT(DISTINCT Order_ID) * 100.0 /
        NULLIF((SELECT COUNT(DISTINCT Order_ID) FROM ecommerce_sales), 0), 2
    ) AS Order_Percentage
FROM ecommerce_sales
GROUP BY Order_Status
ORDER BY Order_Percentage DESC;

/* 14. YEARLY SALES */
SELECT
    YEAR(Order_Date) AS Year,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM ecommerce_sales
GROUP BY YEAR(Order_Date)
ORDER BY Year;

/* 15. MONTHLY SALES */
SELECT
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month_Number,
    MONTHNAME(Order_Date) AS Month_Name,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM ecommerce_sales
GROUP BY YEAR(Order_Date), MONTH(Order_Date), MONTHNAME(Order_Date)
ORDER BY Year, Month_Number;

/* 16. QUARTERLY SALES */
SELECT
    YEAR(Order_Date) AS Year,
    QUARTER(Order_Date) AS Quarter,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM ecommerce_sales
GROUP BY YEAR(Order_Date), QUARTER(Order_Date)
ORDER BY Year, Quarter;

/* 17. CTE - MONTH OVER MONTH GROWTH */
WITH monthly_sales AS (
    SELECT YEAR(Order_Date) AS Year, MONTH(Order_Date) AS Month_Number,
           SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY YEAR(Order_Date), MONTH(Order_Date)
),
sales_with_previous AS (
    SELECT Year, Month_Number, Total_Sales,
           LAG(Total_Sales) OVER (ORDER BY Year, Month_Number) AS Previous_Month_Sales
    FROM monthly_sales
)
SELECT
    Year, Month_Number,
    ROUND(Total_Sales, 2) AS Total_Sales,
    ROUND(Previous_Month_Sales, 2) AS Previous_Month_Sales,
    ROUND(
        (Total_Sales - Previous_Month_Sales) /
        NULLIF(Previous_Month_Sales, 0) * 100, 2
    ) AS Growth_Percentage
FROM sales_with_previous
ORDER BY Year, Month_Number;

/* 18. SUBQUERY - PRODUCTS ABOVE AVERAGE SALES */
SELECT Product_ID, Product_Name, ROUND(SUM(Sales), 2) AS Total_Sales
FROM ecommerce_sales
GROUP BY Product_ID, Product_Name
HAVING SUM(Sales) > (
    SELECT AVG(Product_Total_Sales)
    FROM (
        SELECT Product_ID, SUM(Sales) AS Product_Total_Sales
        FROM ecommerce_sales
        GROUP BY Product_ID
    ) AS product_summary
)
ORDER BY Total_Sales DESC;

/* 19. WINDOW FUNCTION - PRODUCT RANK */
WITH product_sales AS (
    SELECT Product_ID, Product_Name, SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY Product_ID, Product_Name
)
SELECT
    Product_ID, Product_Name, ROUND(Total_Sales, 2) AS Total_Sales,
    RANK() OVER (ORDER BY Total_Sales DESC) AS Sales_Rank
FROM product_sales
ORDER BY Sales_Rank;

/* 20. TOP PRODUCT IN EACH CATEGORY */
WITH product_sales AS (
    SELECT Category, Product_ID, Product_Name, SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY Category, Product_ID, Product_Name
),
ranked_products AS (
    SELECT *,
           RANK() OVER (
               PARTITION BY Category
               ORDER BY Total_Sales DESC
           ) AS Product_Rank
    FROM product_sales
)
SELECT Category, Product_ID, Product_Name,
       ROUND(Total_Sales, 2) AS Total_Sales, Product_Rank
FROM ranked_products
WHERE Product_Rank = 1
ORDER BY Category;

/* 21. CUSTOMER SEGMENTATION */
WITH customer_sales AS (
    SELECT Customer_ID, Customer_Name, SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY Customer_ID, Customer_Name
)
SELECT
    Customer_ID, Customer_Name, ROUND(Total_Sales, 2) AS Total_Sales,
    CASE
        WHEN Total_Sales >= 50000 THEN 'High Value'
        WHEN Total_Sales >= 20000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Customer_Segment
FROM customer_sales
ORDER BY Total_Sales DESC;

/* 22. CUSTOMER SEGMENT SUMMARY */
WITH customer_sales AS (
    SELECT Customer_ID, SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY Customer_ID
),
customer_segments AS (
    SELECT Customer_ID, Total_Sales,
           CASE
               WHEN Total_Sales >= 50000 THEN 'High Value'
               WHEN Total_Sales >= 20000 THEN 'Medium Value'
               ELSE 'Low Value'
           END AS Customer_Segment
    FROM customer_sales
)
SELECT
    Customer_Segment,
    COUNT(*) AS Number_of_Customers,
    ROUND(SUM(Total_Sales), 2) AS Segment_Sales
FROM customer_segments
GROUP BY Customer_Segment
ORDER BY Segment_Sales DESC;

/* 23. DISCOUNT VS PROFITABILITY */
SELECT
    Discount,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS Profit_Margin
FROM ecommerce_sales
GROUP BY Discount
ORDER BY Discount;

/* 24. REGION + CATEGORY */
SELECT
    Region, Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM ecommerce_sales
GROUP BY Region, Category
ORDER BY Region, Total_Sales DESC;

/* 25. CATEGORY RANK WITHIN REGION */
WITH region_category AS (
    SELECT Region, Category, SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY Region, Category
)
SELECT
    Region, Category, ROUND(Total_Sales, 2) AS Total_Sales,
    RANK() OVER (
        PARTITION BY Region ORDER BY Total_Sales DESC
    ) AS Category_Rank
FROM region_category
ORDER BY Region, Category_Rank;

/* 26. VIEW - CATEGORY PERFORMANCE */
CREATE OR REPLACE VIEW category_performance AS
SELECT
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS Profit_Margin
FROM ecommerce_sales
GROUP BY Category;

SELECT * FROM category_performance
ORDER BY Total_Sales DESC;

/* 27. VIEW - MONTHLY PERFORMANCE */
CREATE OR REPLACE VIEW monthly_performance AS
SELECT
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month_Number,
    MONTHNAME(Order_Date) AS Month_Name,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM ecommerce_sales
GROUP BY YEAR(Order_Date), MONTH(Order_Date), MONTHNAME(Order_Date);

SELECT * FROM monthly_performance
ORDER BY Year, Month_Number;

/* 28. FINAL DASHBOARD KPI */
SELECT
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    COUNT(DISTINCT Product_ID) AS Total_Products,
    SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Sales) / COUNT(DISTINCT Order_ID), 2) AS Average_Order_Value,
    ROUND(SUM(Profit) / SUM(Sales)  * 100, 2) AS Profit_Margin
FROM ecommerce_sales;
