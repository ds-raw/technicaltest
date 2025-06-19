
WITH monthly_orders AS (
    SELECT
        customer_id,
        SUBSTR(order_date, 1, 7) AS month,
        COUNT(order_id) AS order_count
    FROM df
    GROUP BY customer_id, month
),
repeat_customers AS (
    SELECT customer_id
    FROM monthly_orders
    GROUP BY customer_id
    HAVING COUNT(*) >= 2
)
SELECT
    mo.month,
    COUNT(DISTINCT mo.customer_id) AS repeat_customers_count
FROM monthly_orders mo
JOIN repeat_customers rc ON mo.customer_id = rc.customer_id
GROUP BY mo.month
ORDER BY mo.month;
