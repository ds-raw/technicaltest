
WITH rfm_base AS (
    SELECT
        customer_id,
        MAX(order_date) AS last_order_date,
        COUNT(order_id) AS frequency,
        SUM(payment_value) AS monetary
    FROM df
    GROUP BY customer_id
),
current_ref AS (
    SELECT DATE('2024-07-01') AS current_date
),
rfm AS (
    SELECT
        r.customer_id,
        julianday(c.current_date) - julianday(r.last_order_date) AS recency,
        r.frequency,
        r.monetary
    FROM rfm_base r
    JOIN current_ref c
)
SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    CASE
        WHEN recency <= 30 AND frequency >= 3 THEN 'Champions'
        WHEN recency <= 60 AND frequency >= 2 THEN 'Loyal'
        WHEN recency <= 90 AND frequency = 1 THEN 'Recent Buyer'
        WHEN recency > 180 AND frequency = 1 THEN 'Lost'
        WHEN monetary >= 300 THEN 'Big Spender'
        WHEN frequency >= 5 THEN 'Frequent Buyer'
        ELSE 'Others'
    END AS customer_segment
FROM rfm;
