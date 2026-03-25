# Olist SQL Analysis

## Overview
This project overviews the OList dataset using set queries. A data quality audit, cohort retention, seller performance, ABC classification, and delivery analysis were all made into queries. 

## Data Quality Audit
This analysis demonstrates an audit on the dataset in order to determine the quality of it. Created an analysis for Table counts, null rates, orphan checks, date ranges, date gaps, duplicates, and anomalies.
Created multiple CTEs for each of the characteristics above. Taking this approach to have each of the categories allowed for a deeper view into the dataset. It also allows for a complete overview to see the broad spectrum that the dataset reaches with the amount of customer/ order items. 
Results: there were no null rates or orphan ids within the system. There were no anomalies within the dataset. There were 99,441 customers and 112,650 order items. This dataset seems to be clear of issues.
## Analysis 1: Cohort Retention


## Analysis 2: Seller Performance
Determining which sellers performed the best based on revenue, delivery speed, and average review score. 
Created CTE chains for each of the categories above. Join the tables together using the JOIN function . Then using a rank statement, create a ranked view of sellers within the final table. 
Ranks were given based on total revenue for each seller. The other categories were given more as an insight to each seller. High sellers are not always the fastest in delivery time or satisfaction. 

## Analysis 3: ABC Classification

## Analysis 4: Delivery Analysis
Determine which regions experience the most delay. 
Calculated the actual versus estimated delivery times. Then aggregated the results to show the delay and ranked the states. Used a CTE for delivery times to show the actual and estimated times. Then created the aggregated CTE to show delay time. 
Each state is ranked by lowest delay time with Alabama as the highest ranked state. 


## Limitations
There were missing days within the audit check. This can limit how accurate the data is.
There were no cost or profit data points which limits the evaluations to just revenue.
Only have a state level analysis for delivery times

