
------------CREATE TABLE AND DATA COLUMNS SO VALUES CAN BE ADDED FROM PYTHON---------------
CREATE TABLE retail_order(
	[order_id] int primary key,
	[order_date] date,
	[ship_mode] varchar(20),
	[segment] varchar(20),
	[country] varchar(20),
	[city] varchar(20),
    [state] varchar(20),
	[postal_code] varchar (20),
	[region] varchar(20),
	[category] varchar(20), 
	[sub_category] varchar(20),
    [product_id] varchar(20),
	[quantity] int,
	[discount] decimal(7,2),
	[sales_price] decimal(7,2),
	[profit] decimal(7,2),
      )

SELECT *
FROM retail_order

---------------DATA ANALYSIS IN SQL AFTER DATA CLEANING  IN PYTHON--------------

----What is the average profit for orders in the consumer segment?
SELECT AVG(profit) AS average_profit
FROM retail_order
WHERE segment = 'Consumer';


----What is the average sales value for orders shipped via second class?
SELECT AVG(sales_price) AS avg_sales_value
FROM retail_order
WHERE ship_mode = 'Second Class'


----What is the total sales amount for the southern region in the year 2022?
SELECT SUM(sales_price) AS total_sales
FROM retail_order
WHERE region = 'South'
  AND YEAR(order_date) = 2022

----Find top 10 highest revenue genrating products
SELECT top 10 product_id, sum(sales_price) as sales
FROM retail_order
GROUP BY product_id
ORDER BY sales DESC

----Find top 5 selling products in each region
WITH CTE AS(
SELECT region,product_id,sum(sales_price) as sales
FROM retail_order
GROUP BY region,product_id)
SELECT * FROM (
SELECT *, ROW_NUMBER() OVER(PARTITION BY region ORDER BY sales DESC) AS row_no
FROM CTE) A
WHERE row_no<=5


----Find month over month growth comparison for 2022 and 2023 sales
WITH CTE AS(
SELECT DISTINCT YEAR(order_date)AS order_year, MONTH(order_date) AS order_month,SUM (sales_price) AS sales
FROM retail_order
GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT order_month,
SUM(CASE WHEN order_year=2022 THEN sales ELSE 0 END) AS sales_2023,
SUM(CASE WHEN order_year=2022 THEN sales ELSE 0 END) AS sales_2023
FROM CTE
GROUP BY order_month
ORDER BY order_month


----Which month had the highest category sales
WITH CTE AS (
SELECT category, format(order_date,'yyyMM') AS order_year_month,
SUM(sales_price) AS sales
FROM retail_order
GROUP BY category,format(order_date,'yyyMM')
)
SELECT *
FROM(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY category ORDER BY sales DESC) AS row_num
FROM CTE
) A
WHERE row_num=1
