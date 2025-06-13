---Data Cleaning

delete from Retail_Sales
where transactions_id is null
		or
	  sale_date is null
	    or
      sale_time is null
	    or
	  customer_id is null
	    or
	  gender is null
	    or
	  age is null
	    or
	  category is null
	    or
	  quantity is null 
	    or
	  price_per_unit is null
	    or
	  cogs is null
	    or
	  total_sale is null

	  
	  UPDATE Retail_Sales
SET age = (SELECT AVG(age) FROM Retail_Sales WHERE age IS NOT NULL)
WHERE age IS NULL;


---Data Exploration

--How many sales we have?
select COUNT(*) as total_sales from Retail_Sales

---How many customers we have?
select COUNT(Distinct(Customer_ID)) as total_customer from Retail_Sales


select Distinct(category) from Retail_Sales

---Data Analysis & Bussiness Key Problems & Answers

--Question 1 - Write SQL query to retrieve all columns for sales made on "2022-11-05"

Select * from Retail_Sales
where sale_date = '2022-11-05'

--- Question 2 - Write a SQL query to retrieve all transactions where the category is "clothing" and the quantity sold is 
--- more than 10 in the month of nov-2022

Select * from Retail_Sales
where category = 'Clothing'
		And 
      quantity >= 4
	    and
	  MONTH(sale_date) = 11

---- Question 3 - Write a SQL query to calculate the total sales for each category

Select category,
	   SUM(total_sale) as net_sale, 
	   COUNT(*) as total_orders 
from Retail_Sales
group by category
order by total_orders desc

----Question 4 - Write a SQL query to find the average age of customers who purchased items from the 'beauty' category.
select AVG(age) as avg_age from Retail_Sales
where category = 'Beauty'

--- Question 5 - Write a SQL query to find all transactions where the total_sale is greater than 1000

select * from Retail_Sales
where total_sale > 1000


---Question 6 - Write a SQL Query to find total number of transaction (transaction_Id) made by each gender in each category

Select category,
	   gender,
	   COUNT(*) as Total_Tranaction 
from Retail_Sales
group by category,gender

---Question 7 Write a SQL query to calculate average sales for each month. find out best selling month in each year.

SELECT 
    SaleYear,
    SaleMonth,
    AverageSales
FROM (
    SELECT 
        YEAR(sale_date) AS SaleYear,
        MONTH(sale_date) AS SaleMonth,
        AVG(total_sale) AS AverageSales,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS SalesRank
    FROM 
        Retail_Sales
    GROUP BY 
        YEAR(sale_date), MONTH(sale_date)
) AS MonthlySales
WHERE 
    SalesRank = 1
ORDER BY SaleYear,SaleMonth desc

---Question 8 - Write a SQL query to find the top 5 customer based on the highest total sales
select top(5) customer_id,sum(total_sale) as highest_sale from Retail_Sales
group by customer_id
order by highest_sale desc

----Question 9 - Write a SQL query to find the number of unique customers who purchased items from each category
select category,
       count(distinct(customer_id)) as total_unique_customer 
from Retail_Sales
group by category


--- Question 10 - Write a SQL query to create each shifts and number of orders
--- (for example : Morning <= 12, Afternoon between 12 & 17, Evening >17)

Select 
	   Case 
			when DATEPART(Hour,sale_time) < 12 then 'Morning'
			when DATEPART(hour,sale_time) >= 12 AND DATEPART(hour, sale_time) < 17 then 'Afternoon'
			else 'Evening'
	   End as Shifts,
	   COUNT(*) as NumberOfOrders
from Retail_Sales
group by
		Case 
			when DATEPART(Hour,sale_time) < 12 then 'Morning'
			when DATEPART(hour,sale_time) >= 12 AND DATEPART(hour, sale_time) < 17 then 'Afternoon'
			else 'Evening'
		end
order by NumberOfOrders desc
		

