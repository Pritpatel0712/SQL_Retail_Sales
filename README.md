# SQL_Retail_Sales

This project focuses on cleaning, exploring, and analyzing retail sales data using SQL. The goal is to uncover business insights such as customer behavior, sales trends, and category performance, which can assist in better decision-making for stakeholders.

## 📁 Dataset Description

The dataset used is a simulated retail sales table named `Retail_Sales`, containing fields such as:

- `transaction_id`
- `sale_date`, `sale_time`
- `customer_id`, `gender`, `age`
- `category`, `quantity`, `price_per_unit`
- `cogs` (Cost of Goods Sold)
- `total_sale`

Each row represents a unique transaction with detailed sales and customer information.

## 🧹 Data Cleaning

Initial steps were taken to clean the data and handle missing or null values.

- Removed records where key fields were null:
  - `transaction_id`, `sale_date`, `sale_time`, `customer_id`, `gender`, `age`, `category`, `quantity`, `price_per_unit`, `cogs`, `total_sale`
- Replaced null values in `age` with the average age of available records.

```sql
DELETE FROM Retail_Sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

UPDATE Retail_Sales
SET age = (SELECT AVG(age) FROM Retail_Sales WHERE age IS NOT NULL)
WHERE age IS NULL;
```

## 🔍 Data Exploration
Basic queries to get an overview of the data:

Total number of sales
Total unique customers
List of distinct product categories

```sql
SELECT COUNT(*) AS total_sales FROM Retail_Sales;

SELECT COUNT(DISTINCT customer_id) AS total_customers FROM Retail_Sales;

SELECT DISTINCT category FROM Retail_Sales;
```

## 📊 Business Questions & Analysis
Below are some key business questions answered using SQL queries:

1. **Write SQL query to retrieve all columns for sales made on "2022-11-05"**

```sql
SELECT * FROM Retail_Sales
WHERE sale_date = '2022-11-05';
```

2.**Write a SQL query to retrieve all transactions where the category is "clothing" and the quantity sold is  more than 10 in the month of nov-2022**

```sql
SELECT * FROM Retail_Sales
WHERE category = 'Clothing' AND quantity >= 4
AND
MONTH(sale_date) = 11;
```

3.**Write a SQL query to calculate the total sales for each category**

```sql
SELECT category,
       SUM(total_sale) AS net_sale,
       COUNT(*) AS total_orders
FROM Retail_Sales
GROUP BY category
ORDER BY total_orders DESC;
```

4.**Write a SQL query to find the average age of customers who purchased items from the 'beauty' category.**

```sql
SELECT AVG(age) AS avg_age
FROM Retail_Sales
WHERE category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000**

```sql
SELECT * FROM Retail_Sales
WHERE total_sale > 1000;
```

6.**Write a SQL Query to find total number of transaction (transaction_Id) made by each gender in each category**

```sql
SELECT category, gender, COUNT(*) AS Total_Transactions
FROM Retail_Sales
GROUP BY category, gender;
```

7.**Write a SQL query to calculate average sales for each month. find out best selling month in each year.**

```sql
SELECT SaleYear, SaleMonth, AverageSales
FROM (
    SELECT YEAR(sale_date) AS SaleYear,
           MONTH(sale_date) AS SaleMonth,
           AVG(total_sale) AS AverageSales,
           RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS SalesRank
    FROM Retail_Sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS MonthlySales
WHERE SalesRank = 1
ORDER BY SaleYear, SaleMonth DESC;
```

8.**Write a SQL query to find the top 5 customer based on the highest total sales**

```sql
SELECT TOP(5) customer_id, SUM(total_sale) AS highest_sale
FROM Retail_Sales
GROUP BY customer_id
ORDER BY highest_sale DESC;
```

9.**Write a SQL query to find the number of unique customers who purchased items from each category**

```sql
SELECT category, COUNT(DISTINCT customer_id) AS total_unique_customers
FROM Retail_Sales
GROUP BY category;
```

10.**Write a SQL query to create each shifts and number of orders**

```sql
SELECT 
    CASE 
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) >= 12 AND DATEPART(HOUR, sale_time) < 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS Shift,
    COUNT(*) AS NumberOfOrders
FROM Retail_Sales
GROUP BY
    CASE 
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) >= 12 AND DATEPART(HOUR, sale_time) < 17 THEN 'Afternoon'
        ELSE 'Evening'
    END
ORDER BY NumberOfOrders DESC;
```

## 🛠️ Tools Used
- SQL Server Management Studio (SSMS) or any compatible SQL editor

- SQL for data cleaning, exploration, and analysis

## 📈 Key Insights
Clothing and Beauty products have high purchase frequencies

Majority of high-value sales occur in the Evening

Specific months show seasonal peaks in average sales

Gender and age demographics influence product preferences
