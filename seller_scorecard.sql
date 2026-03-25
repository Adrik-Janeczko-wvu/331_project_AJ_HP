-- Business Question:
-- Which sellers perform best based on revenue, delivery speed, and reviews?
-- Approach:
-- Complete each given metric using CTEs and the rank by revenue
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
    GROUP BY oi.seller_id  
), 
-- fixing duplication one review per order
order_reviews_clean AS (
    SELECT 
        order_id,
        AVG(review_score) AS review_score
    FROM order_reviews
    GROUP BY order_id
),
-- create review CTE to show average review scores jined with seller id 
reviews AS (
    SELECT 
        oi.seller_id,
        AVG(r.review_score) AS avg_review_score
    FROM order_reviews_clean as r
    JOIN order_items as oi USING (order_id)
    GROUP BY oi.seller_id
)
-- final select for the final table. joining all three ctes onto one table and using rank feature
SELECT 
    r.seller_id,
    r.total_revenue,
    d.avg_delivery_days,
    rv.avg_review_score,
    RANK() OVER (ORDER BY r.total_revenue DESC) AS revenue_rank
FROM revenue as r
LEFT JOIN delivery as d USING (seller_id)
LEFT JOIN reviews as rv USING (seller_id)
ORDER BY revenue_rank;
