# SQL-Project-Covid19

This repository contains an SQL data analysis project focused on COVID-19. It uses real-world datasets of confirmed cases, deaths, and vaccinations to explore trends and key metrics with SQL queries.

## Overview

There are:

- **CovidDeaths.csv** – daily case and death counts by location  
- **CovidVaccinations.csv** – daily vaccination counts by location  
- **covid19_data_analysis.sql** – an SQL script with analytical queries

The queries demonstrate how to extract meaningful insights from pandemic data using SQL.

## What You Can Learn

This project shows how to:

- Calculate total cases, total deaths, and death rates by location and date  
- Compute infection percentages relative to population  
- Aggregate global and regional trends  
- Join deaths and vaccinations data to correlate trends  
- Use window functions for rolling totals  
- Convert text to numbers and avoid divide-by-zero errors


## Prerequisites

To run the SQL script:

1. Install a SQL environment such as PostgreSQL, MySQL, Microsoft SQL Server, or Azure Data Studio
2. Load the CSV files into tables named `CovidDeaths` and `CovidVaccinations`  
3. Ensure numeric columns are properly typed or cast in the queries  


## How to Run

1. Import the CSV files into your SQL environment (for example, SQL Server tables).

2. Open `covid19_data_analysis.sql` in your SQL editor.

3. Run the queries incrementally to explore the results.

---

## Query Highlights

The script includes analyses such as:

- **Case and Death Summaries:** total and daily trends
- **Death Percentage:** death rate relative to reported cases
- **Population Impact:** percent of population infected
- **Vaccination Analysis:** rolling totals of vaccinations

These queries Show how to combine multiple datasets and get actionable insights with SQL.

---

## Notes

- Some columns in the CSV files are stored as text and must be cast to numeric types before calculations.
- Zero or missing values are handled using safe division (`NULLIF`) to avoid divide-by-zero errors.





  
