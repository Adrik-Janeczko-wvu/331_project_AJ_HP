-- Creating  a table using with statements to create different categories. 
-- Table counts counts the customers and returns a number value for the amount of customers. 
WITH table_counts AS (
    SELECT 'customers' AS metric, COUNT(*) AS value FROM customers
    UNION ALL
    SELECT 'orders', COUNT(*) FROM orders
),
-- This checks all of the nulls within the data and returns the amount of nulls
null_checks AS (
    SELECT 
        'null_customer_id' AS metric,
        SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS value
    FROM orders
),
-- orphaned orders counts the amount of customer_ids that have ni origin key to them. 
orphaned_orders AS (
    SELECT 
        'orphan_orders' AS metric,
        COUNT(*) AS value
    FROM orders o
    LEFT JOIN customers c ON o.customer_id = c.customer_id
    WHERE c.customer_id IS NULL
)
-- Displaying the final table by unioning the created tables together.
SELECT * FROM table_counts
UNION ALL
SELECT * FROM null_checks
UNION ALL
SELECT * FROM orphaned_orders;
