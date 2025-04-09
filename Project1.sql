--SQL Retail Sales Analysis
CREATE DATABASE sql_project_p1;

CREATE TABLE retail_sales
            (
              transactions_id INT PRIMARY KEY , 
              sale_date	DATE,
              sale_time	TIME,
              customer_id INT,
              gender VARCHAR(15), 
              age INT,
              category VARCHAR(15),	
              quantiy INT,	
              price_per_unit FLOAT,	
              cogs FLOAT,	
              total_sale FLOAT 
           )

-- Basic Data exploration 
SELECT * FROM retail_sales LIMIT 10; 

SELECT COUNT(*) FROM retail_sales;

-- Data Cleaning
-- CHECK IF THERE ARE NULL VALUES
SELECT * FROM retail_sales
WHERE transactions_id IS NULL 
OR sale_date IS NULL	
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL 
OR category IS NULL
OR quantiy IS NULL 	
OR price_per_unit IS NULL	
OR cogs IS NULL	
OR total_sale IS NULL;

--deleting null value rows 
DELETE FROM retail_sales
WHERE transactions_id IS NULL 
OR sale_date IS NULL	
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL 
OR category IS NULL
OR quantiy IS NULL 	
OR price_per_unit IS NULL	
OR cogs IS NULL	
OR total_sale IS NULL; 

-- EDA 
-- how many customers do we have ? 
SELECT COUNT(DISTINCT customer_id) AS customer_count FROM retail_sales

-- how many categories do we have and what are they ? 
SELECT COUNT(DISTINCT category) AS total FROM retail_sales
SELECT DISTINCT category FROM retail_sales

-- data analysis and business key problems 
-- Q1. write a SQL Query to retrieve all columns for sales made on ' 2022-11-05'
SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05' ; 

-- Q2. write a SQL query to retrieve all transactions were the category is 'clothing' and the quantity sold is more than 4 in the month of november 2022 
SELECT * 
FROM retail_sales 
WHERE category = 'Clothing' AND  TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' AND quantiy >= 4; 

-- Q3. write a SQL query to calculate (total_sale) for each category 
SELECT category , SUM(total_sale) as sales , count(*) as total_orders
FROM retail_sales 
GROUP BY category

-- Q4. write a SQL query to find the average age of customers who purchased items from the 'Beauty' category. 
SELECT ROUND(AVG(age),2) 
FROM retail_sales
WHERE category = 'Beauty'

-- Q5. write a  SQL query to find out all transactions where the total_sales is greater than 1000.
SELECT *
FROM retail_sales 
WHERE total_sale > 1000

--Q6. write SQl to find out total number of transactions(transactions_id) made by each gender in each category 
SELECT category, gender, COUNT(transactions_id) 
FROM retail_sales
GROUP BY  category,gender
ORDER BY 1;

--window functions 
-- Q7. Calculate the average sale for each month. Find out the best selling month in each year
SELECT year, month , avg_sale
FROM (
SELECT EXTRACT(YEAR FROM sale_date) as year, 
EXTRACT(MONTH FROM sale_date) as month, 
AVG(total_sale) as avg_sale ,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1,2 
) as t1 
WHERE rank = 1 
-- ORDER BY 1,3 DESC; 

-- Q8. write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id, SUM(total_sale) as total_sales
FROM retail_sales 
GROUP BY 1 
ORDER BY total_sales DESC
LIMIT 5; 

-- Q.9 write a SQL query to find out the number of unique customers who purchased items from each category
SELECT COUNT(DISTINCT(customer_id)), category 
FROM retail_sales 
GROUP BY category

--customer segmentation , CTE 
-- Q10. write a SQL query to create each shift and number of orders (Eg: Morning <=12 , Afternoon Between 12 & 17 , Evening > 17) 
-- and then find out total sales in each shift 
WITH hourly_sales
AS
(
SELECT *,
CASE 
  WHEN EXTRACT(HOUR from sale_time) < 12 THEN 'Morning'
  WHEN EXTRACT(HOUR from sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
  ELSE 'Evening'
END as shift 
FROM retail_sales 
) 
SELECT shift, COUNT(*) AS total_orders 
FROM hourly_sales 
GROUP BY shift  

--end of project 


