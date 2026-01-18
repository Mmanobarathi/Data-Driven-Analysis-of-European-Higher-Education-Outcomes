# Data-Driven-Analysis-of-European-Higher-Education-Outcomes
European Higher Education Analytics
Gender, Degree & Country-Level Insights
📌 Project Overview

This project is an end-to-end data analytics and SQL project focused on understanding higher education patterns across European countries. The analysis explores how students are distributed by degree level, gender, origin, programme type, and field of study, and demonstrates a complete data workflow from data cleaning in Python to analytical querying in MySQL and dashboard readiness for Power BI.

The primary goal of this project is to showcase strong SQL fundamentals, including database design, clean querying, joins, aggregations, and analytical thinking, supported by Python-based data preparation.

🧠 Business / Analytical Motivation

Higher education data is widely used by:
----------------------------------------

policymakers,

educational institutions,

and international organizations

to understand:
--------------

gender imbalance,

degree-level participation,

cross-country differences,

and long-term education trends.

This project answers real analytical questions, such as:
-----------------------------------------------------------

1.Which countries have higher female participation in higher education?

2.How do education structures differ across European countries?

3.How can countries be grouped based on education profiles?

🗂 Dataset Description
----------------------

The dataset is sourced from European higher education statistics and consists of aggregated country-level data.
The original data was provided in a multi-sheet Excel file and later cleaned and structured.

Tables used in MySQL:
1. clean_gender

Country-level student counts by:

short-cycle
bachelor
master
doctoral
Gender split:
men
women
total

Includes derived metrics such as women share and gender gap

2. cleaned_origin

Student origin distribution:
domestic
international

Used for mobility and internationalization analysis

3. cleaned_programmes
Student distribution by programme types

Helps understand structural differences in education systems

4. cleaned_fields

Student counts across major academic fields:

education
business
engineering
ICT
health
social sciences
humanities

🧹 Data Cleaning & Preparation (Python)
---------------------------------------

Before loading data into MySQL, all datasets were cleaned using Python (pandas):
Standardized column names using snake_case
Removed formatting artifacts (line breaks, hyphens, inconsistent spacing)
Converted numeric columns safely using pd.to_numeric(errors="coerce")
Handled missing and invalid values
Created analytical features such as:
gender gap (women − men)
women share (%) per degree level

The cleaned datasets were exported as CSV files and imported into MySQL Workbench.
