-- Business Question:
-- Which states experience the worst delivery delays?
-- Approach: 
-- Create two CTEs one for delivery time and one for aggregate. Using delivery times create the aggregate and show the final tabele and order by delay rank 
WITH delivery_times AS (
    SELECT 
        c.customer_state,
        DATE_DIFF('day', o.order_purchase_timestamp, o.order_delivered_customer_date) AS actual_days,
        DATE_DIFF('day', o.order_purchase_timestamp, o.order_estimated_delivery_date) AS estimated_days
    FROM orders as o
    JOIN customers as c ON o.customer_id = c.customer_id
    WHERE o.order_delivered_customer_date IS NOT NULL -- makes sure there is an order date 
),

aggregated AS (
    SELECT 
        customer_state,
        AVG(actual_days) AS avg_actual,
        AVG(estimated_days) AS avg_estimated,
        AVG(actual_days - estimated_days) AS delay -- cerates the aggregate used in the final table
    FROM delivery_times
    GROUP BY customer_state
)
SELECT * -- show the final table and order by delay
FROM aggregated
ORDER BY delay DESC;
