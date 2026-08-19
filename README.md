## 🛒 E-Commerce Sales & Customer Behavior Analysis

Analyzing e-commerce sales, customer behavior, product performance, regional trends, and profitability using SQL and Power BI to generate actionable business insights.

---

## 📌 Project Overview

This project analyzes an e-commerce sales dataset using MySQL to identify sales trends, customer behavior, product performance, regional performance, profitability, discounts, and order status.

The analysis focuses on transforming raw transactional data into meaningful business insights that can support sales growth, customer retention, profitability, and operational decision-making.

--- 

## 🎯 Project Objectives

- Analyze overall sales and profit performance
- Identify top-performing products and categories
- Analyze customer purchasing behavior
- Identify high-value and repeat customers
- Compare sales performance across regions and cities
- Analyze payment methods and order status
- Calculate return and cancellation rates
- Analyze the relationship between discounts and profitability
- Identify monthly and yearly sales trends
- Prepare cleaned SQL data for Power BI visualization

## 📑 Table of Contents

- Dataset Summary
- Data Cleaning & Preparation
- Business Analysis
- Dashboard Development
- SQL Analysis
- Key Insights
- Business Recommendations
- Business Impact
- Tools & Technologies
- My Role
- Project Files
- Author

---

## 🗂️ Dataset Summary

The dataset contains e-commerce transaction information including:

- **Records:** 50,000
- **Customers:** 8,000
- **Products:** 500
- **Categories:** 4
- **Sub-Categories:** 16
- **Regions:** 5
- **Cities:** 15
- **Period:** January 2024 – December 2025

**Main Columns**

- Order_ID
- Order_Date	
- Customer_ID	
- Customer_Name	
- Product_ID	
- Product_Name	
- Category	
- Sub_Category	
- Quantity	
- Unit_Price	
- Discount
- Sales	
- Profit	
- Region	
- City	
- Payment_Mode	
- Order_Status	

---

## 🔄 Project Workflow

Raw CSV Dataset
      ↓
Data Import into MySQL
      ↓
Table Creation
      ↓
Data Validation
      ↓
NULL & Duplicate Analysis
      ↓
Data Cleaning
      ↓
Exploratory Data Analysis
      ↓
Business KPI Analysis
      ↓
Sales & Profit Analysis
      ↓
Customer Analysis
      ↓
Product Analysis
      ↓
Regional Analysis
      ↓
Discount & Order Analysis
      ↓
Advanced SQL Analysis
      ↓
SQL View Creation
      ↓
Power BI Dashboard
      ↓
Business Insights

---

## 🧹 Data Cleaning & Validation

The following data-quality checks were performed:

- Verified total row count
- Checked for NULL values
- Identified missing customer names
- Identified missing discount values
- Checked duplicate records
- Checked duplicate Order_IDs
- Validated quantity values
- Validated unit prices
- Checked sales and profit values
- Validated discount ranges
- Verified sales calculations

Missing values were handled using COALESCE() where appropriate.

Example:

COALESCE(Customer_Name, 'Unknown Customer')

and

COALESCE(Discount, 0)

---

## 🔍 SQL Analysis Performed

**1. Overall KPI Analysis**

**Calculated:**

- Total Sales
- Total Profit
- Total Orders
- Total Customers
- Total Products
- Total Quantity
- Average Order Value
- Profit Margin
  
**2. Sales Analysis**

**Analyzed:**

- Sales by category
- Sales by sub-category
- Monthly sales
- Yearly sales
- Sales contribution by region
  
**3. Product Analysis**

**Identified:**

- Top 10 products
- Bottom 10 products
- Top products within each category
- Product sales ranking
- Product profitability
  
**4. Customer Analysis**

**Analyzed:**

- Top customers by sales
- Customer order frequency
- Repeat customers
- Customer segmentation
- Customer profitability
  
**5. Regional Analysis**

**Analyzed:**

- Sales by region
- Profit by region
- Sales by city
- Regional sales contribution
  
**6. Order Analysis**

**Analyzed:**

- Delivered orders
- Returned orders
- Cancelled orders
- Cancellation rate
- Return rate
- Category-wise return rate
  
**7. Payment Analysis**

**Compared:**

- UPI
- Credit Card
- Debit Card
- Net Banking
- Cash on Delivery

  **8. Discount Analysis**

**Analyzed:**

- Average discount
- Sales by discount level
- Profit by discount level
- Impact of discounts on profitability

---

## 📈 Dashboard Development (Power BI)

Developed an interactive Power BI dashboard covering:

- **Executive Overview**
- **Product & Customer Analysis**
- **Regional & Sales Analysis**

**Dashboard Analysis Includes:**

**KPIs**

- Total Sales
- Total Profit
- Total Orders
- Total Customers
- Total Products
- Total Quantity
- Average Order Value
- Profit Margin
  
**Deep-Dive Analysis**

- Top Products
- Top Customers
- Category Performance
- Regional Performance
- Sales Trends
- Customer Segmentation
- Payment Mode Analysis
- Order Status Analysis
- Discount vs Profitability

---

## 🔑 Key Insights

- Identified overall sales and profitability performance
- Identified top-performing products based on sales and profit
- Identified high-value customers based on sales contribution
- Compared category and sub-category performance
- Analyzed regional and city-level sales performance
- Evaluated monthly, quarterly, and yearly sales trends
- Analyzed customer segments based on sales contribution
- Evaluated discount levels against profitability
- Analyzed payment-mode and order-status patterns

---

## 💡 Business Recommendations

- Focus on high-performing products and categories
- Strengthen engagement with high-value customers
- Develop targeted strategies for low-value customer segments
- Optimize discount strategies to protect profitability
- Focus marketing efforts on high-performing regions and cities
- Monitor monthly and quarterly sales trends for planning
- Promote products and categories with strong profit contribution


---

## 🛠️ Tools & Technologies

Power BI · DAX · Power Query · SQL / MySQL · Excel · Data Modeling

---

## 👩‍💻 My Role – Data Analyst

As a Data Analyst, I worked on this project to transform raw e-commerce transaction data into meaningful business insights. My responsibilities included:

- Cleaning and validating the dataset
- Performing data analysis using SQL
- Checking null values, duplicates, and invalid records
- Developing SQL queries for KPIs and business analysis
- Using CTEs, subqueries, window functions, ranking, and SQL views
- Creating data models and relationships in Power BI
- Developing measures for key business KPIs
- Designing interactive dashboards and reports using Power BI
- Analyzing sales, profit, products, customers, categories, and regions
- Performing customer segmentation based on sales contribution
- Analyzing sales trends and discount profitability
- Generating insights to support data-driven business decisions

---

## 🚀 Conclusion

This project demonstrates how SQL can be used to transform raw e-commerce transaction data into actionable business insights.

The project covers the complete analytics workflow, from data validation and cleaning to advanced SQL analysis and preparation of data for Power BI visualization.

It demonstrates practical skills in SQL, data cleaning, exploratory analysis, business KPI development, customer analysis, product analysis, and data visualization.

## 🙋 Author

**Vaishnavi Mallayolla**

**👩‍💻 Skills Demonstrated**

SQL | MySQL | Data Cleaning | Data Analysis | Business Intelligence | KPI Analysis | Customer Analysis | Sales Analysis | Window Functions | CTEs | Power BI | Data Visualization

---

⭐ If you find this project useful, feel free to explore the repository and give it a star!
