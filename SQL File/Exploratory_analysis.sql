-- Exploratory Data Analysis (EDA)
-- Total Sales & Number of Customers
SELECT SUM(sales) AS total_sales, COUNT(DISTINCT customer_id) AS unique_customers
FROM superstore_sales;

-- Purchase Frequency per Customer
SELECT customer_id, COUNT(order_id) AS purchase_count
FROM superstore_sales
GROUP BY customer_id
ORDER BY purchase_count DESC;

-- Identify Outliers (High Sales or Low Profit)

SELECT * FROM superstore_sales
WHERE sales > 5000 OR profit < 0
ORDER BY sales DESC;