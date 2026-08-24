# SQL Server Interview Practice – 50 Business Analytics Queries

A collection of **50 SQL Server interview questions and solutions** based on a retail/sales dataset.

This project focuses on solving practical business problems using SQL Server, including sales analysis, customer analysis, product analysis, store performance, profitability, currency conversion, and advanced SQL concepts.

---

## 📌 Project Overview

This repository contains 50 SQL queries designed to strengthen SQL Server skills for **Data Analyst, Business Analyst, and BI/SQL interviews**.

The queries cover both fundamental and advanced SQL concepts and are written around a retail sales database containing information about:

- Customers
- Sales
- Products
- Stores
- Exchange Rates

The objective is to convert business requirements into efficient SQL queries and generate meaningful analytical results.

---

## 🗂️ Dataset Tables

The queries primarily use the following tables:

| Table | Description |
|---|---|
| `Customers` | Customer information such as name, country, birthday, and customer key |
| `Sales` | Sales transactions, orders, quantities, dates, currency, customer, product, and store information |
| `Products` | Product details including category, brand, color, price, and cost |
| `Stores` | Store information including country, state, and store key |
| `Exchange_Rates` | Currency exchange rates by date and currency |

---

# 📚 SQL Concepts Covered

The 50 questions demonstrate the following SQL Server concepts:

### 1. Basic SQL
- `SELECT`
- Column aliases
- `WHERE`
- `ORDER BY`
- `DISTINCT`

### 2. Aggregate Functions
- `SUM()`
- `COUNT()`
- `COUNT(DISTINCT)`
- `AVG()`
- `MIN()`
- `MAX()`

### 3. Grouping
- `GROUP BY`
- `HAVING`
- Aggregation by country
- Aggregation by category
- Aggregation by customer
- Aggregation by product
- Aggregation by store

### 4. Joins
- `INNER JOIN`
- `LEFT JOIN`
- Joining multiple tables
- Joining fact and dimension-style tables
- Handling unmatched records

### 5. String and Data Conversion
- `REPLACE()`
- `TRY_CONVERT()`
- Converting currency-formatted values
- Handling numeric values stored as text

### 6. Date Functions
- `YEAR()`
- `MONTH()`
- `DATEDIFF()`
- `DATEADD()`
- Date-based analysis

### 7. Conditional Logic
- `CASE`
- Customer age groups
- Business classification

### 8. Subqueries
- Derived tables
- Filtering aggregated results
- Comparing results against calculated values

### 9. CTEs
- `WITH`
- Common Table Expressions
- Pre-aggregating exchange rates
- Simplifying complex queries

### 10. Window Functions
- `RANK()`
- `LAG()`
- `SUM() OVER()`
- `PARTITION BY`
- Running totals
- Ranking within groups
- Month-over-month analysis

### 11. Business Analytics
- Revenue analysis
- Cost analysis
- Profit analysis
- Profit percentage
- Customer analysis
- Product analysis
- Store analysis
- Delivery performance
- Currency conversion

---

# 📊 Business Problems Covered

The questions solve practical business requirements such as:

- Calculating total sales revenue
- Finding top customers
- Finding top-selling products
- Finding top brands
- Calculating revenue by country
- Calculating revenue by category
- Calculating store performance
- Identifying customers with no purchases
- Identifying products with no sales
- Calculating customer age groups
- Measuring delivery performance
- Calculating profit and profit percentage
- Finding top products within categories
- Finding top brands within countries
- Calculating running revenue
- Calculating month-over-month revenue growth
- Converting sales between currencies
- Creating executive-level business KPIs

---

# 🧠 Advanced SQL Techniques

Some of the more advanced problems involve:

### Ranking

Using:

```sql
RANK() OVER(
    PARTITION BY ...
    ORDER BY ...
)
