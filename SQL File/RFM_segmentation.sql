-- Step 1: Calculate RFM Values
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

-- Step 2: Assign RFM Scores
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

-- Step 3: Create Customer Segments
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