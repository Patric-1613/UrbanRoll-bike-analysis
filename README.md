# Bike Sharing Network — Operational Analytics

## Project Overview
Comprehensive operational analysis of a bike sharing network using SQL and Google BigQuery.
The analysis covers 15,000 rides across three datasets — ride records, station data, and
user profiles — examining ride behaviour, membership patterns, peak demand, station
performance, and monthly user growth.

## Tools Used
- Google BigQuery (SQL)
- Google Cloud Platform
- Git / GitHub

## Datasets
| Table | Description | Rows |
|-------|-------------|------|
| `rider` | Individual ride records with timestamps, distance, station IDs | ~15,000 |
| `stations` | Station names and IDs across the network | ~50 |
| `users` | User profiles with membership level and signup date | ~1,000 |

## Analysis Performed
| Analysis | Description |
|----------|-------------|
| Data Quality Audit | NULL checks, false start detection |
| Summary Statistics | Min/max/avg distance and travel time |
| Membership Analysis | Casual vs Subscriber behaviour comparison |
| Peak Hour Analysis | Hourly ride demand across the day |
| Station Popularity | Most used departure stations |
| Ride Categorisation | Short / medium / long trip breakdown |
| Net Flow Analysis | Bikes gained/lost per station for rebalancing |
| User Growth | Month-over-month signup growth rates |

## Key Findings
- Casual users make up 71% of rides but ride 2.4x longer than subscribers
- Peak hour is 15:00 (3PM) with 1,617 rides — higher than morning commute
- Jennifer Land St loses 66 bikes daily — most critical rebalancing point
- Amy Park St gains 66 bikes daily — overflow risk
- May is the highest growth month (+22.8%) driven by spring seasonality
- July sees the biggest drop (-19.1%) despite being peak summer
- Medium trips (11-30 mins) dominate at 47% of all rides

## Files in this Repo
| File | Description |
|------|-------------|
| `bike_sharing_analysis.sql` | All BigQuery SQL queries |
| `Bike_Sharing_Analysis_Report.docx` | Full written report with recommendations |
| `rider.csv` | Ride records dataset |
| `stations.csv` | Station data |
| `users.csv` | User profiles |

## Recommendations Summary
1. **Membership** — Convert casual users to subscribers via post-ride conversion prompts
2. **Operations** — Deploy 6AM rebalancing run from Amy Park St to Jennifer Land St daily
3. **Infrastructure** — Pilot intermediate stations to unlock short-trip demand
4. **Growth** — Launch February retention campaign to prevent Q1 signup cliff

## SQL Concepts Used
- JOINs across multiple tables
- TIMESTAMP_DIFF for duration calculations
- EXTRACT for time-based analysis
- CASE WHEN for ride categorisation
- CTEs (WITH clauses) for net flow analysis
- LAG window function for month-over-month growth
- COUNTIF for data quality checks
- NULLIF to handle division by zero
