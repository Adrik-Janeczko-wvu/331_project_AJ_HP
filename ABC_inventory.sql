/*
Business Question: Which products drive the most revenue, and how should
  inventory focus be prioritized?

  Approach: Calculate total revenue per product, calculated a running total using
  a window function, then assign A,B,C tiers based on total revenue share.
  A = top 80% of revenue, B = then 15%, C = last 5%.

  Possible error: Products with NULL category names are included but may skew
  category-level interpretation.
*/

WITH product_revenue AS (
    -- Total revenue per product across all delivered orders
    SELECT
        oi.product_id,
        p.product_category_name,
        SUM(oi.price) AS total_revenue
    FROM order_items oi
    JOIN orders AS o ON oi.order_id = o.order_id
    JOIN products AS p ON oi.product_id = p.product_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.product_id, p.product_category_name
),
