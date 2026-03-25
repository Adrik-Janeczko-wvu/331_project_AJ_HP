# Olist SQL Analysis

## Overview
This project overviews the OList dataset using set queries. A data quality audit, cohort retention, seller performance, ABC classification, and delivery analysis were all made into queries. 

## Data Quality Audit
This analysis demonstrates an audit on the dataset in order to determine the quality of it. Created an analysis for Table counts, null rates, orphan checks, date ranges, date gaps, duplicates, and anomalies.
Created multiple CTEs for each of the characteristics above. Taking this approach to have each of the categories allowed for a deeper view into the dataset. It also allows for a complete overview to see the broad spectrum that the dataset reaches with the amount of customer/ order items. 
Results: there were no null rates or orphan ids within the system. There were no anomalies within the dataset. There were 99,441 customers and 112,650 order items. This dataset seems to be clear of issues.

## Analysis 1: Cohort Retention
How well does Olist retain its customers over time? 
Assigning the customers to cohorts by the first month purchase, measuring the percentages of customers returning within the next three months. Using CTEs to identify the customers first purchase date, the time differences between the order, and the aggregated retention. 
Customer retention declined after the first purchase. 


## Analysis 2: Seller Performance
Determining which sellers performed the best based on revenue, delivery speed, and average review score. 
Created CTE chains for each of the categories above. Join the tables together using the JOIN function . Then using a rank statement, create a ranked view of sellers within the final table. 
Ranks were given based on total revenue for each seller. The other categories were given more as an insight to each seller. High sellers are not always the fastest in delivery time or satisfaction. 

## Analysis 3: ABC Classification
which products drive the most revenue and how should this inventory be prioritized?
Calculate total revenue per product, then use a window to have running total. Products are then assigned to a tier from the products running total compared to the total revenue with A being the top 80%, B the following 15% and C tier being the last 5%. Making a final table with all categories and using CASE assigns the grade for each tier based on revenue.
Not many products generate the majority of the revenue. This means the inventory and marketing efforts should prioritize high performing products.

## Analysis 4: Delivery Analysis
Determine which regions experience the most delay. 
Calculated the actual versus estimated delivery times. Then aggregated the results to show the delay and ranked the states. Used a CTE for delivery times to show the actual and estimated times. Then created the aggregated CTE to show delay time. 
Each state is ranked by lowest delay time with Alabama as the highest ranked state. 


## Limitations
There were missing days within the audit check. This can limit how accurate the data is.
There were no cost or profit data points which limits the evaluations to just revenue.
Only have a state level analysis for delivery times

