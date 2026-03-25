 
WITH delivery_times AS (
    SELECT 
        c.customer_state,
        DATE_DIFF('day', o.order_purchase_timestamp, o.order_delivered_customer_date) AS actual_days,
        DATE_DIFF('day', o.order_purchase_timestamp, o.order_estimated_delivery_date) AS estimated_days
    FROM orders as o
    JOIN customers as c ON o.customer_id = c.customer_id
    WHERE o.order_delivered_customer_date IS NOT NULL -- makes sure there is an order date 
)
