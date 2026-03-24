/*
Question: How well does Olist retain its customers over time?

Appoarch: Assign customers to cohorts by first purchase month, then measure what percentage returns in the next months 1,2, and 3 after their original month. 
Using customer_unique_id becayse the same customer can have multiple customer_ids in the dataset. only 'delivered' orders are counted as completed transactions. 

limitation: first and last months will have lower retention because less time as passed for repeat purchases to happen.
*/
WITH customer_first_purchase AS (
    -- One row per unique customer: their cohort month (month of first purchase)
    SELECT
        c.customer_unique_id,
        MIN(DATE_TRUNC('month', o.order_purchase_timestamp)) AS cohort_month
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),

customer_purchases AS (
    -- All delivered purchases per unique customer, including their first
    SELECT
        c.customer_unique_id,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS purchase_month
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),
cohort_time_deltas AS (
    -- how many months after their cohort month did each purchase occur?
    -- month_number = 0 is the cohort month itself; 1, 2, 3 are return visits
    SELECT
        cfp.cohort_month,
        cfp.customer_unique_id,
        DATEDIFF('month', cfp.cohort_month, cp.purchase_month) AS month_number
    FROM customer_first_purchase cfp
    JOIN customer_purchases cp ON cfp.customer_unique_id = cp.customer_unique_id
),

cohort_sizes AS (
    -- Total customers per cohort, used as the denominator for retention rates
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_unique_id) AS initial_customers
    FROM customer_first_purchase
    GROUP BY cohort_month
)
