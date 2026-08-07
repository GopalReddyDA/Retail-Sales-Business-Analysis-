-- Retail Sales Data Analysis - SQL Project (POC)


-- Data Exploration

-- View all records
SELECT *
FROM [retail_sales_data];

-- Total number of records
SELECT
    COUNT(*) AS total_records
FROM [retail_sales_data];

-- View distinct transaction IDs
SELECT DISTINCT
    transactions_id
FROM [retail_sales_data];

-- Total sales by gender and category
SELECT
    gender,
    category,
    SUM(total_sale) AS sales
FROM [retail_sales_data]
GROUP BY
    gender,
    category;

-- View distinct product categories
SELECT DISTINCT
    category
FROM [retail_sales_data];

-- View complete dataset
SELECT *
FROM [retail_sales_data];

-- Find dataset date range
SELECT
    MAX(sale_date) AS end_date,
    MIN(sale_date) AS start_date
FROM [retail_sales_data];

-- Preview top 10 records
SELECT TOP 10 *
FROM [retail_sales_data];


-- Data Cleaning


-- Checking NULL values (Method 1)

SELECT *
FROM [retail_sales_data]
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Delete rows containing NULL values

DELETE
FROM [retail_sales_data]
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Total records after cleaning

SELECT
    COUNT(*) AS total_records
FROM [retail_sales_data];

-- View cleaned dataset

SELECT *
FROM [retail_sales_data];

-- Basic Analysis

-- Number of unique customers

SELECT
    COUNT(DISTINCT customer_id) AS distinct_customers
FROM [retail_sales_data];


-- Business Problems & SQL Analysis


-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'.

SELECT *
FROM [retail_sales_data]
WHERE sale_date = '2022-11-05';


-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing'
-- and the quantity sold is more than 3 in the month of November 2022.

SELECT *
FROM [retail_sales_data]
WHERE category = 'Clothing'
  AND quantiy > 3
  AND DATEPART(MONTH, sale_date) = 11
  AND DATEPART(YEAR, sale_date) = 2022;


-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT
    category,
    SUM(total_sale) AS total_sales
FROM [retail_sales_data]
GROUP BY
    category;


-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    AVG(age) AS customer_avg_age
FROM [retail_sales_data]
WHERE category = 'Beauty';


-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM [retail_sales_data]
WHERE total_sale > 1000;


-- Q6. Write a SQL query to find the total number of transactions made by each gender in each category.

SELECT
    gender,
    category,
    COUNT(*) AS total_transactions
FROM [retail_sales_data]
GROUP BY
    gender,
    category;


-- Q7. Write a SQL query to calculate the average sale for each month.
-- Find the best-selling month in each year.

WITH cte AS
(
    SELECT
        DATEPART(MONTH, sale_date) AS months,
        DATEPART(YEAR, sale_date) AS years,
        AVG(total_sale) AS avg_sales
    FROM [retail_sales_data]
    GROUP BY
        DATEPART(MONTH, sale_date),
        DATEPART(YEAR, sale_date)
),

cte2 AS
(
    SELECT
        *,
        DENSE_RANK() OVER
        (
            PARTITION BY years
            ORDER BY avg_sales DESC
        ) AS dn
    FROM cte
)

SELECT
    years,
    months,
    avg_sales
FROM cte2
WHERE dn = 1
ORDER BY avg_sales DESC;


-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT TOP 5
    customer_id,
    SUM(total_sale) AS total_sales
FROM [retail_sales_data]
GROUP BY
    customer_id
ORDER BY
    total_sales DESC;


-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT
    category,
    COUNT(customer_id) AS unique_no_customers
FROM [retail_sales_data]
GROUP BY
    category;


-- Q10. Write a SQL query to classify transactions into different shifts
-- and calculate the number of orders in each shift.
-- Morning : Before 12 PM
-- Afternoon : Between 12 PM and 5 PM
-- Evening : After 5 PM

WITH hourlysales AS
(
    SELECT
        *,
        CASE
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shifts
    FROM [retail_sales_data]
)

SELECT
    shifts,
    COUNT(*) AS shiftwisesales
FROM hourlysales
GROUP BY
    shifts;