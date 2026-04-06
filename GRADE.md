# Milestone 1 Grade

| Criterion | Score | Max |
|-----------|------:|----:|
| Data Quality Audit | 3 | 3 |
| Query Depth & Correctness | 3 | 3 |
| Business Reasoning & README | 3 | 3 |
| Git Practices | 3 | 3 |
| Code Walkthrough | 3 | 3 |
| **Total** | **15** | **15** |

## Data Quality Audit (3/3)
`data_quality.sql` is a well-structured single CTE chain covering all major audit dimensions: row counts for 6 tables, null rates on key columns, orphaned FK checks (orders without customers, order_items without orders), date range bounds, date gap detection via `generate_series`, duplicate checks on order and customer IDs, and anomaly detection (non-positive prices, delivery before purchase). This is systematic and thorough profiling work.

## Query Depth & Correctness (3/3)
All five SQL files execute without errors against the instructor database.

- **data_quality.sql** — 7 CTEs (including a nested CTE for date gaps), multiple UNION ALL chains, LEFT JOIN orphan checks. Runs cleanly, 18 rows returned.
- **ABC_inventory.sql** — 3 CTEs (`product_revenue`, `revenue_ranked`, `revenue_pct`). Uses window functions (`SUM(...) OVER (ORDER BY ...)` for running total, `SUM(...) OVER ()` for grand total) and a CASE-based tier assignment. 32,216 rows returned.
- **cohort_retention.sql** — 4 CTEs (`customer_first_purchase`, `customer_purchases`, `cohort_time_deltas`, `cohort_sizes`). Uses `DATE_TRUNC`, `DATEDIFF`, and a pivot via `COUNT(DISTINCT CASE WHEN ...)`. Correctly uses `customer_unique_id` to handle the multi-ID-per-customer issue. 23 rows returned.
- **seller_scorecard.sql** — 4 CTEs (`revenue`, `delivery`, `order_reviews_clean`, `reviews`). Uses `RANK() OVER (ORDER BY ...)` window function, LEFT JOINs to combine metrics. Deduplicates reviews per order before averaging. 3,095 rows returned.
- **delivery_time.sql** — 2 CTEs (`delivery_times`, `aggregated`). Uses `DATE_DIFF` and aggregation to compare actual vs. estimated delivery by state. 27 rows returned.

## Business Reasoning & README (3/3)
The README has a clear question for each analysis, explains the approach taken, summarizes the findings, and calls out meaningful limitations: boundary cohort effects on retention rates, NULL category names in ABC analysis, absence of cost/profit data, and date gaps in the dataset. The narrative is coherent and connects methodology to results rather than just listing files.

## Git Practices (3/3)
23 commits demonstrating incremental development. Messages show logical progression: initial CTE scaffolding, business question framing, iterative updates to queries, and README section completions. Work appears to have been built up step-by-step rather than dumped in one commit.
