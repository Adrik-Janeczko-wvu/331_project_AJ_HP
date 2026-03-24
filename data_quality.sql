-- creating cte's for each of the characteristics required for the data quality audit. Using these ctes to show the overall quality of the data set in an easier manner

WITH

-- counting rows per table by creating unions to put together
-- for each category
table_counts AS (
    SELECT 'table_counts' AS section, 'customers' AS metric, CAST(COUNT(*) AS VARCHAR) AS value FROM customers
    UNION ALL SELECT 'table_counts', 'orders', CAST(COUNT(*) AS VARCHAR) FROM orders
    UNION ALL SELECT 'table_counts', 'order_items', CAST(COUNT(*) AS VARCHAR) FROM order_items
    UNION ALL SELECT 'table_counts', 'products', CAST(COUNT(*) AS VARCHAR) FROM products
    UNION ALL SELECT 'table_counts', 'sellers', CAST(COUNT(*) AS VARCHAR) FROM sellers
    UNION ALL SELECT 'table_counts', 'order_reviews', CAST(COUNT(*) AS VARCHAR) FROM order_reviews
),

-- checking null for tables in customer id 
null_rates AS (
    SELECT 
        'null_rates' AS section,
        'orders.customer_id_null_pct' AS metric,
        CAST(ROUND(100.0 * SUM(customer_id IS NULL) / COUNT(*), 2) AS VARCHAR) AS value
    FROM orders

    UNION ALL

    SELECT 
        'null_rates',
        'orders.purchase_ts_null_pct',
        CAST(ROUND(100.0 * SUM(order_purchase_timestamp IS NULL) / COUNT(*), 2) AS VARCHAR)
    FROM orders

    UNION ALL
    
    SELECT 
        'null_rates',
        'order_items.price_null_pct',
        CAST(ROUND(100.0 * SUM(price IS NULL) / COUNT(*), 2) AS VARCHAR)
    FROM order_items
),

--checking for orphan keys no customer id or order id
orphan_checks AS (
   
    SELECT 
        'orphan_checks' AS section,
        'orders_without_customer' AS metric,
        CAST(COUNT(*) AS VARCHAR) AS value
    FROM orders o
    LEFT JOIN customers c ON o.customer_id = c.customer_id
    WHERE c.customer_id IS NULL

    UNION ALL

    SELECT 
        'orphan_checks',
        'order_items_without_order',
        CAST(COUNT(*) AS VARCHAR)
    FROM order_items oi
    LEFT JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_id IS NULL
),

-- covering date ranges 
date_ranges AS (
    SELECT 
        'date_ranges' AS section,
        'orders_min_date' AS metric,
        CAST(MIN(order_purchase_timestamp) AS VARCHAR) AS value
    FROM orders

    UNION ALL

    SELECT 
        'date_ranges',
        'orders_max_date',
        CAST(MAX(order_purchase_timestamp) AS VARCHAR)
    FROM orders
),

-- showing all of the missing days within the dataset 
date_gaps AS (
    WITH all_dates AS (
        SELECT *
        FROM generate_series(
            (SELECT MIN(order_purchase_timestamp)::DATE FROM orders),
            (SELECT MAX(order_purchase_timestamp)::DATE FROM orders),
            INTERVAL 1 DAY
        ) AS t(date)
    ),
    actual_dates AS (
        SELECT DISTINCT order_purchase_timestamp::DATE AS date
        FROM orders
    )
    SELECT 
        'date_gaps' AS section,
        'missing_days_count' AS metric,
        CAST(COUNT(*) AS VARCHAR) AS value
    FROM all_dates d
    LEFT JOIN actual_dates a ON d.date = a.date
    WHERE a.date IS NULL
),

-- showing duplication within the dataset 
duplicates AS (
    SELECT 
        'duplicates' AS section,
        'duplicate_order_ids' AS metric,
        CAST(COUNT(*) AS VARCHAR) AS value
    FROM (
        SELECT order_id
        FROM orders
        GROUP BY order_id
        HAVING COUNT(*) > 1 -- count more than 1 shows that an item is a duplicate
    )

    UNION ALL

    SELECT 
        'duplicates',
        'duplicate_customer_ids',
        CAST(COUNT(*) AS VARCHAR)
    FROM (
        SELECT customer_id
        FROM customers
        GROUP BY customer_id
        HAVING COUNT(*) > 1
    )
),

-- shwoing any anomolies within the dataset
anomalies AS (
    -- negative or zero prices
    SELECT 
        'anomalies' AS section,
        'non_positive_prices' AS metric,
        CAST(COUNT(*) AS VARCHAR) AS value
    FROM order_items
    WHERE price <= 0

    UNION ALL

    -- delivery before purchase
    SELECT 
        'anomalies',
        'delivery_before_purchase',
        CAST(COUNT(*) AS VARCHAR)
    FROM orders
    WHERE order_delivered_customer_date < order_purchase_timestamp
)
    
SELECT * FROM table_counts
UNION ALL
SELECT * FROM null_rates
UNION ALL
SELECT * FROM orphan_checks
UNION ALL
SELECT * FROM date_ranges
UNION ALL
SELECT * FROM date_gaps
UNION ALL
SELECT * FROM duplicates
UNION ALL
SELECT * FROM anomalies

ORDER BY section, metric
