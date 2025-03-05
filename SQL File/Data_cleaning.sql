-- 1. Check Data Types
DESCRIBE superstore_sales;

-- 2. Handle Missing Values
UPDATE superstore_sales 
SET postal_code = '' 
WHERE postal_code IS NULL;

-- 3. Ensure Correct Date Format
UPDATE superstore_sales 
SET order_date = STR_TO_DATE(order_date, '%Y-%m-%d'),
    ship_date = STR_TO_DATE(ship_date, '%Y-%m-%d');

-- 4. Remove Duplicates (If Any)
DELETE FROM superstore_sales 
WHERE order_id IN (
    SELECT order_id FROM (
        SELECT order_id, ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY order_id) AS row_num
        FROM superstore_sales
    ) AS temp_table
    WHERE row_num > 1
);

-- 5. Standardize Column Names (Optional)
ALTER TABLE superstore_sales 
CHANGE COLUMN `customer_name` `Customer_Name` VARCHAR(100),
CHANGE COLUMN `sales` `Sales` DECIMAL(10,2),
CHANGE COLUMN `profit` `Profit` DECIMAL(10,2);

-- 6. Verify Cleaned Data
SELECT * FROM superstore_sales LIMIT 10;