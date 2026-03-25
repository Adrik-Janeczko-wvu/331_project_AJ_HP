WITH revenue AS (
    SELECT 
        seller_id,
        SUM(price) AS total_revenue
    FROM order_items
    GROUP BY seller_id
), -- created the revenue value from each seller

delivery AS (
    SELECT 
        oi.seller_id,
        AVG(DATE_DIFF('day', o.order_purchase_timestamp, o.order_delivered_customer_date)) AS avg_delivery_days
    FROM orders as o
    JOIN order_items as oi USING (order_id)
    WHERE o.order_delivered_customer_date IS NOT NULL
    GROUP BY oi.seller_id -- 
)
