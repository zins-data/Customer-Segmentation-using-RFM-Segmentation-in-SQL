# 📊 Superstore RFM Segmentation in SQL

## 📌 Project Overview
This project performs **Customer Segmentation** using **RFM Analysis** (Recency, Frequency, Monetary) on the **Superstore Sales** dataset in MySQL. The key objectives include:

1. **Database Setup** 📂
2. **Data Cleaning & Preprocessing** 🛠️
3. **Exploratory Data Analysis (EDA)** 📈
4. **RFM Segmentation** 🏷️
5. **Findings & Documentation** 📝

---

## 1️⃣ Database Setup
### **Create a New Database**
```sql
CREATE DATABASE superstore_db;
USE superstore_db;
```

### **Create Table Schema**
```sql
CREATE TABLE superstore_sales (
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(10),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2)
);
```

### **Import Data Using MySQL Import Wizard**
- Use `superstore_sales.csv`
- Ensure correct column mappings

### **Verify Data Import**
```sql
SELECT COUNT(*) FROM superstore_sales;
-- Expected Output: 9426 rows
```

---

## 2️⃣ Data Cleaning & Preprocessing
### **Check Data Types**
```sql
DESCRIBE superstore_sales;
```

### **Handle Missing Values**
```sql
UPDATE superstore_sales SET postal_code = '' WHERE postal_code IS NULL;
```

### **Ensure Correct Date Format**
```sql
UPDATE superstore_sales 
SET order_date = STR_TO_DATE(order_date, '%Y-%m-%d'),
    ship_date = STR_TO_DATE(ship_date, '%Y-%m-%d');
```

### **Check for Duplicates**
```sql
SELECT order_id, COUNT(*) 
FROM superstore_sales 
GROUP BY order_id 
HAVING COUNT(*) > 1;
```

---

## 3️⃣ Exploratory Data Analysis (EDA)
### **Total Sales & Customers**
```sql
SELECT COUNT(DISTINCT customer_id) AS total_customers, SUM(sales) AS total_sales FROM superstore_sales;
```

### **Most Profitable Customers**
```sql
SELECT customer_id, customer_name, SUM(profit) AS total_profit
FROM superstore_sales
GROUP BY customer_id
ORDER BY total_profit DESC
LIMIT 10;
```

### **Top-Selling Products**
```sql
SELECT product_name, SUM(quantity) AS total_quantity
FROM superstore_sales
GROUP BY product_name
ORDER BY total_quantity DESC
LIMIT 10;
```

---

## 4️⃣ RFM Segmentation
### **Step 1: Calculate RFM Values**
```sql
WITH rfm_data AS (
    SELECT 
        customer_id,
        MAX(order_date) AS last_purchase,
        COUNT(order_id) AS frequency,
        SUM(sales) AS monetary
    FROM superstore_sales
    GROUP BY customer_id
)
SELECT 
    customer_id,
    DATEDIFF((SELECT MAX(order_date) FROM superstore_sales), last_purchase) AS recency,
    frequency,
    monetary
FROM rfm_data;
```

### **Step 2: Assign RFM Scores**
```sql
WITH rfm_scores AS (
    SELECT 
        customer_id,
        NTILE(5) OVER (ORDER BY DATEDIFF((SELECT MAX(order_date) FROM superstore_sales), last_purchase) ASC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency DESC) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary DESC) AS monetary_score
    FROM (
        SELECT 
            customer_id,
            MAX(order_date) AS last_purchase,
            COUNT(order_id) AS frequency,
            SUM(sales) AS monetary
        FROM superstore_sales
        GROUP BY customer_id
    ) AS rfm
)
SELECT *, (recency_score + frequency_score + monetary_score) AS rfm_total
FROM rfm_scores;
```

### **Step 3: Create Customer Segments**
```sql
SELECT customer_id,
       CASE 
           WHEN rfm_total >= 12 THEN 'Loyal Customer'
           WHEN rfm_total BETWEEN 9 AND 11 THEN 'Potential Loyalist'
           WHEN rfm_total BETWEEN 6 AND 8 THEN 'At Risk'
           ELSE 'Churn Risk'
       END AS customer_segment
FROM (
    SELECT customer_id, (recency_score + frequency_score + monetary_score) AS rfm_total
    FROM rfm_scores
) AS rfm_with_segments;
```

---

## 5️⃣ Findings & Documentation
### **Key Insights**
- **Loyal Customers**: Customers with the highest RFM scores, contributing most to revenue.
- **Potential Loyalists**: Regular customers who could become loyal with engagement.
- **At-Risk Customers**: Decreasing purchases but still valuable.
- **Churn Risk**: Low frequency and recency, needing re-engagement strategies.
---

## 📂 Files
### **SQL Files**
- `/SQL File/Data_cleaning.sql`
- `/SQL File/Exploratory_analysis.sql`
- `/SQL File/RFM_segmentation.sql`
- `/SQL File/Superstore_data.sql`

### **Dataset**
- `/Dataset/superstore_sales.csv`

### **Documentation**
- `Documentation`
- `README.md`
- `LICENSE`

---

## 📞 Contact Details
**Zunnun Zihan**  
Instructor, BITA - Bangladesh Institute of Theatre Arts  
✉ Email: zins.data.science@gmail.com
