/*Question 26
Interview Question: The marketing team wants to identify high-value customers for a loyalty program.
Write a query to display each customer's name, country, total number of orders, total quantity purchased, and total sales in USD, sorted by highest sales.
Expected Output (Columns):
Output Column
Name
Country
TotalOrders
TotalQuantity
TotalSalesUSD
*/
SELECT C.NAME,C.COUNTRY,COUNT(S.ORDER_NUMBER) TOT_ORDERS,SUM(S.QUANTITY) TOT_QUANTITY,
SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) TOTAL_SALES
FROM Customers C
INNER JOIN 
SALES S
ON C.CustomerKey=S.CustomerKey
INNER JOIN
Products P
ON S.ProductKey=P.ProductKey
GROUP BY C.NAME,C.COUNTRY
ORDER BY TOTAL_SALES DESC
------------------------------------------------------------------
/*Question 27
Interview Question: The procurement department wants to identify products with the highest profit contribution.
Write a query to display product name, brand, revenue, cost, and profit, sorted by profit in descending order.
Expected Output (Columns):
Output Column
Product Name
Brand
Revenue
Cost
Profit
*/
SELECT P.[Product_Name],P.[Brand],SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) REVENUE,
SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_COST_USD],'$','')))) COST,
SUM((S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) )) - (S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_COST_USD,'$','')) ))) PROFIT FROM SALES S
INNER JOIN
PRODUCTS P
ON S.ProductKey=P.ProductKey
GROUP BY P.[Product_Name],P.[Brand]
ORDER BY PROFIT DESC
------------------------------------------------------------------------------------------
/*Question 28 SELECT * FROM STORES
Interview Question: Management wants to know which stores are generating the highest sales.
Write a query to display total revenue for every store along with store country, state, and store size (square meters).
Expected Output (Columns):
Output Column
Country
State
Square Meters
Revenue
*/
SELECT S.COUNTRY,S.STATE,S.SQUARE_METERS,
SUM(SA.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) REVENUE
FROM Products P
INNER JOIN
SALES SA
ON SA.ProductKey=P.ProductKey
INNER JOIN
STORES S
ON S.StoreKey=SA.StoreKey
GROUP BY S.COUNTRY,S.STATE,S.SQUARE_METERS
--------------------------------------------------------------------------
/*Question 29
Interview Question: The CEO wants to identify the best-selling product category in each country. 
Write a query to display the top-selling category (by revenue) for every customer country.
Expected Output (Columns):
Output Column
Country
Category
Revenue
*/
SELECT * FROM (
SELECT C.COUNTRY,P.CATEGORY,SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) REVENUE,
DENSE_RANK() OVER(PARTITION BY C.COUNTRY ORDER BY SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) DESC) RNK
FROM Customers C
INNER JOIN
SALES S
ON C.CustomerKey=S.CustomerKey
INNER JOIN 
Products P
ON P.ProductKey=S.ProductKey
GROUP BY C.COUNTRY,P.CATEGORY
)A WHERE RNK=1
--------------------------------------------------------------------
/*Question 30
Interview Question: Finance wants to calculate revenue in each customer's local currency. 
Write a query to display order number, customer name, currency code, revenue in USD, and revenue in local currency.
Expected Output (Columns):
Output Column
Order Number
Name
Currency Code
RevenueUSD
RevenueLocal
*/
SELECT S.[Order_Number],C.[Name],S.[Currency_Code],
SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) REVENUEUSD,
SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))*E.[Exchange] ) REVENUELOCAL
FROM 
Customers C
INNER JOIN
SALES S
ON C.CustomerKey=S.CustomerKey
INNER JOIN
Exchange_Rates E
ON E.Date=S.Order_Date AND E.Currency=S.Currency_Code
INNER JOIN
Products P
ON P.ProductKey=S.ProductKey
GROUP BY S.[Order_Number],C.[Name],S.[Currency_Code]
---------------------------------------------------------------------------------------
/*Question 31
Interview Question: Write a query to find customers who have purchased products from at least three different brands.
Expected Output (Columns):
Output Column
Name
BrandsPurchased
*/
SELECT C.NAME,COUNT(DISTINCT P.BRAND) BRANDSPURCHASED FROM CUSTOMERS C
INNER JOIN
SALES S
ON C.CustomerKey=S.CustomerKey
INNER JOIN
Products P
ON P.ProductKey=S.ProductKey
GROUP BY C.NAME
HAVING COUNT(DISTINCT P.BRAND)>=3
--------------------------------------------------------------------------------
/*Question 32
Interview Question: Write a query to calculate the average order value for each country.
Expected Output (Columns):
Output Column
Country
AvgOrderValue
*/
SELECT C.COUNTRY, SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$',''))))/COUNT(DISTINCT S.[Order_Number])AVGORDER FROM Customers C
INNER JOIN 
SALES S
ON C.CustomerKey=S.CustomerKey
INNER JOIN
Products P
ON P.ProductKey=S.ProductKey
GROUP BY C.Country
--------------------------------------------------------------------------------
/*Question 33
Interview Question: Write a query to find the oldest customer (by birthday) who has placed at least one order.
Expected Output (Columns):
Output Column
Name
Country
Birthday
*/
SELECT TOP 1 C.NAME,C.COUNTRY,COUNT(S.[Order_Number]) CNT,C.[Birthday] FROM CUSTOMERS C
INNER JOIN
SALES S
ON C.CustomerKey=S.CustomerKey
GROUP BY C.NAME,C.COUNTRY,C.[Birthday]
HAVING COUNT(S.[Order_Number])>=1
ORDER BY C.[Birthday] ASC
--------------------------------------------------------------------------
/*Question 34
Interview Question: Write a query to display yearly revenue for each product category.
Expected Output (Columns):
Output Column
SalesYear
Category
Revenue
*/
SELECT YEAR(S.[Order_Date]) SALESYEAR,P.CATEGORY,SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) REVENUE
FROM SALES S
INNER JOIN 
Products P
ON S.ProductKey=P.ProductKey
GROUP BY YEAR(S.[Order_Date]),P.CATEGORY
----------------------------------------------------------------------------------------
/*Question 35
Interview Question: Write a query to identify products that have never been sold.
Expected Output (Columns):
Output Column
ProductKey
Product Name
*/
SELECT P.[ProductKey],P.[Product_Name],COUNT(S.[Order_Number]) CNT FROM Products P
left join
SALES S
ON S.ProductKey=P.ProductKey
GROUP BY  P.[ProductKey],P.[Product_Name]
HAVING COUNT(S.[Order_Number]) =0
--------------------------------------------------------------------------------------------
/*Question 36
Interview Question: Write a query to identify stores that have never processed an order.
Expected Output (Columns):
Output Column
StoreKey
Country
State
*/
select COUNT(S.[Order_Number])C,S.STOREKEY,ST.COUNTRY,ST.STATE 
FROM STORES ST
LEFT JOIN
SALES S
ON S.StoreKey=ST.StoreKey
GROUP BY S.STOREKEY,ST.COUNTRY,ST.STATE 
HAVING COUNT(S.[Order_Number])=0
-------------------------------------------------------------------------------------------------
/*Question 37
Interview Question: Write a query to display monthly revenue for each product brand.
Expected Output (Columns):
Output Column
SalesYear
SalesMonth
Brand
Revenue
*/
select p.brand,SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) REVENUE,
YEAR(S.[Order_Date]) SALESYEAR,MONTH(S.[Order_Date]) SALESMONTH FROM PRODUCTS P
INNER JOIN 
SALES S
ON P.ProductKey=S.ProductKey
WHERE YEAR(S.[Order_Date]) IS NOT NULL AND MONTH(S.[Order_Date]) IS NOT NULL
GROUP BY P.BRAND,YEAR(S.[Order_Date]),MONTH(S.[Order_Date])
-------------------------------------------------------------------------------------------------
/*Question 38
Interview Question: Write a query to identify customers whose total spending exceeds the overall average customer spending.
Expected Output (Columns):
Output Column
Name
Sales
*/
SELECT * FROM (
SELECT *,AVG(SALES_) OVER() AVG FROM (
SELECT C.NAME,SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) SALES_
FROM CUSTOMERS C
INNER JOIN
SALES S
ON S.CustomerKey=C.CustomerKey
INNER JOIN
Products P
ON P.ProductKey=S.ProductKey
GROUP BY C.NAME
) A
) B
WHERE SALES_>AVG
-------------------------------------------------------------------
/*Question 39
Interview Question: Write a query to rank all stores based on their total revenue.
Expected Output (Columns):
Output Column
StoreKey
Country
Revenue
StoreRank
*/
SELECT S.STOREKEY,ST.COUNTRY,SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) REVENUE,
RANK() OVER(ORDER BY SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) DESC) STORERANK FROM SALES S
INNER JOIN
STORES ST
ON ST.StoreKey=S.StoreKey
INNER JOIN
Products P
ON P.ProductKey=S.ProductKey
GROUP BY S.STOREKEY,ST.Country
---------------------------------------------------------------------------
/*Question 40
Interview Question: Write a query to calculate each customer's percentage contribution to total company revenue.
Expected Output (Columns):
Output Column
Name
Revenue
ContributionPercent
*/
--SELECT *,(REVENUE /TOT_REV)*100 ContributionPercent FROM(
SELECT *,(REVENUE/SUM(REVENUE) OVER() )*100 ContributionPercent FROM (
SELECT C.NAME,SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) REVENUE 
FROM [dbo].[Customers] C
INNER JOIN
SALES S
ON C.[CustomerKey]=S.[CustomerKey]
INNER JOIN
PRODUCTS P
ON P.[ProductKey]=S.[ProductKey]
GROUP BY C.NAME
)A
--)B
-------------------------------------------------------------------------
/*Question 41
Interview Question: The Operations Manager wants to identify which stores consistently deliver orders the fastest. 
Write a query to display store key, country, state, total orders, and average delivery days, sorted by the fastest delivery time.
Expected Output (Columns):
Output Column
StoreKey
Country
State
TotalOrders
AvgDeliveryDays
*/
SELECT ST.[StoreKey],ST.[Country],ST.[State],COUNT(S.[Order_Number]) TOT_ORDS,AVG(DATEDIFF(DW,S.[Order_Date],S.[Delivery_Date]) ) AvgDeliveryDays
FROM STORES ST
INNER JOIN
SALES S
ON ST.StoreKey=S.StoreKey
GROUP BY ST.[StoreKey],ST.[Country],ST.[State]
ORDER BY AvgDeliveryDays ASC
----------------------------------------------------------------------------
/*Question 42
Interview Question: Management wants to investigate stores with poor delivery performance. 
Write a query to display the top 5 stores with the highest average delivery days.
Expected Output (Columns):
Output Column
StoreKey
Country
State
AvgDeliveryDays
*/
SELECT TOP 5 ST.[StoreKey],ST.[Country],ST.[State],COUNT(S.[Order_Number]) TOT_ORDS,AVG(DATEDIFF(DW,S.[Order_Date],S.[Delivery_Date]) ) AvgDeliveryDays
FROM STORES ST
INNER JOIN
SALES S
ON ST.StoreKey=S.StoreKey
GROUP BY ST.[StoreKey],ST.[Country],ST.[State]
ORDER BY AvgDeliveryDays DESC
-----------------------------------------------------------------------------
/*Question 43
Interview Question: Finance wants to know which product categories generate the highest profit margin.
Write a query to display category, revenue, cost, profit, and profit percentage, sorted by profit percentage in descending order.
Expected Output (Columns):
Output Column
Category
Revenue
Cost
Profit
ProfitPercentage
*/
SELECT P.Category, SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) REVENUE,
SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Cost_USD],'$','')))) COST,
SUM((S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) )) - (S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_COST_USD,'$','')) ))) PROFIT,
(SUM((S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) )) - (S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_COST_USD,'$','')) )))/
SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))))*100 PROFIT_PER FROM
SALES S
INNER JOIN
Exchange_Rates E
ON E.Date=S.Order_Date AND  E.Currency=S.Currency_Code
INNER JOIN 
PRODUCTS P
ON P.ProductKey=S.ProductKey
GROUP BY P.CATEGORY
ORDER BY PROFIT_PER DESC
-------------------------------------------------------------------------------
/*Question 44
Interview Question: Marketing wants to know which brands dominate each country. 
Write a query to display the top 5 brands (by revenue) within each country, along with their rank.
Expected Output (Columns):
Output Column
Country
Brand
Revenue
RN
*/
SELECT * FROM (
SELECT C.COUNTRY,P.BRAND,SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) REVENUE,
RANK() OVER(PARTITION BY C.COUNTRY ORDER BY SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) DESC) RN
FROM CUSTOMERS C
INNER JOIN
SALES S
ON C.CustomerKey=S.CustomerKey
INNER JOIN
PRODUCTS P
ON P.ProductKey=S.ProductKey
GROUP BY C.COUNTRY,P.BRAND
)A
WHERE RN<=5
-----------------------------------------------------------------------
/*Question 45
Interview Question: The CFO wants to track cumulative revenue throughout the year.
Write a query to display year, month, monthly revenue, and running (cumulative) revenue.
Expected Output (Columns):
Output Column
SalesYear
SalesMonth
Revenue
RunningRevenue
*/
SELECT *,SUM(REVENUE) OVER(PARTITION BY SALESYEAR ORDER BY SALESMONTH ROWS UNBOUNDED PRECEDING) RunningRevenue FROM(
SELECT YEAR(S.[Order_Date]) SALESYEAR,MONTH(S.[Order_Date]) SALESMONTH,
SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) REVENUE
FROM
SALES S
INNER JOIN
Products P
ON S.ProductKey=P.ProductKey
GROUP BY YEAR(S.[Order_Date]),MONTH(S.[Order_Date])
)A
-------------------------------------------------------------------------------------
/*Question 46
Interview Question: Management wants to compare each month's revenue with the previous month.
Write a query to display year, month, current month revenue, previous month revenue, and month-over-month growth.
Expected Output (Columns):
Output Column
SalesYear
SalesMonth
Revenue
PreviousMonthRevenue
MoMGrowth
*/
SELECT *,((REVENUE- PREVIOUSYEAR)/ PREVIOUSYEAR)*100 MOM FROM (
SELECT *,LAG(REVENUE) OVER(ORDER BY SALESYEAR,SALESMONTH) PREVIOUSYEAR FROM (
SELECT YEAR(S.[Order_Date]) SALESYEAR,MONTH(S.[Order_Date]) SALESMONTH,
SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) REVENUE
FROM Customers C
INNER JOIN 
SALES S
ON C.CustomerKey=S.CustomerKey
INNER JOIN
Products P
ON S.ProductKey=P.ProductKey
GROUP BY YEAR(S.[Order_Date]),MONTH(S.[Order_Date])
)A
)B
----------------------------------------------------------------------------------------
/*Question 47
Interview Question: Write a query to find the highest-selling product color (by quantity) within each product category.
Expected Output (Columns):
Output Column
Category
Color
Qty
RN
*/
WITH CTE AS(
SELECT P.[Category],P.[Color],SUM(S.[Quantity]) QTY,
RANK() OVER(PARTITION BY P.[Category] ORDER BY SUM(S.[Quantity]) DESC) RN
FROM Products P
INNER JOIN
SALES S
ON P.ProductKey=S.ProductKey
GROUP BY P.Category,P.Color
) SELECT * FROM CTE WHERE RN=1
-----------------------------------------------------------------------------------------------
/*Question 48
Interview Question: Write a query to identify customers who have made purchases in more than one store country (e.g., customers who travel and shop internationally).
Expected Output (Columns):
Output Column
Name
CountriesPurchased
*/
SELECT C.NAME,COUNT(DISTINCT ST.[Country]) CountriesPurchased FROM Customers C
INNER JOIN
SALES S
ON S.CustomerKey=C.CustomerKey
INNER JOIN
STORES ST
ON ST.StoreKey=S.StoreKey
GROUP BY C.NAME
HAVING COUNT(DISTINCT ST.[Country]) > 1
--------------------------------------------------------------------------------------------
/*Question 49
Interview Question: Marketing wants age-wise revenue insights.
Write a query to calculate total revenue by customer age group (18-25, 26-35, 36-45, 46-60, 60+) at the time of purchase.
Expected Output (Columns):
Output Column
AgeGroup
Revenue
*/
SELECT AGEGROUP ,SUM(REVENUE) SUM_REVENUE FROM (
SELECT 
CASE 
WHEN DATEDIFF(YEAR,C.[Birthday],S.[Order_Date])  BETWEEN 18 AND 25 THEN '18-25'
WHEN DATEDIFF(YEAR,C.[Birthday],S.[Order_Date])  BETWEEN 26 AND 35 THEN '26-35'
WHEN DATEDIFF(YEAR,C.[Birthday],S.[Order_Date])  BETWEEN 36 AND 45 THEN '36-45'
WHEN DATEDIFF(YEAR,C.[Birthday],S.[Order_Date])  BETWEEN 46 AND 60 THEN '46-60'
ELSE '60+'
END AS AGEGROUP,
S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$',''))) REVENUE 
FROM CUSTOMERS C
INNER JOIN
SALES S
ON C.[CustomerKey]=S.[CustomerKey]
INNER JOIN
PRODUCTS P
ON P.[ProductKey]=S.[ProductKey]
)A
GROUP BY AGEGROUP
------------------------------------------------------------------------------------------
/*Interview Question 50: The CEO requires a single query to power an executive dashboard. Write a query to return total revenue (USD), total cost (USD), total profit (USD), profit percentage, total orders, total customers, total products sold, average order value, and total revenue in local currency.
Expected Output (Columns):
Output Column
TotalRevenueUSD
TotalCostUSD
TotalProfitUSD
ProfitPercentage
TotalOrders
TotalCustomers
TotalProductsSold
AverageOrderValueUSD
TotalRevenueLocalCurrency
*/
WITH DailyExchange AS
(
    SELECT
        [Date],
        Currency,
        AVG(Exchange) AS Exchange
    FROM Exchange_Rates
    GROUP BY [Date], Currency
)
SELECT SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) REVENUE,
SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_COST_USD],'$','')))) COST,
(SUM(S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) )) -
SUM(S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_COST_USD,'$','')) ))) PROFIT ,
((SUM(S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) )) - SUM(S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_COST_USD,'$','')) )))/
SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))))*100 PROFIT_PER,
COUNT(DISTINCT S.[Order_Number]) TOTAL_ORDERS, COUNT(DISTINCT C.[CustomerKey]) TotalCustomers,
SUM(S.QUANTITY) TOTAL_PRODUCTS_SOLD,
SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$',''))))/COUNT(DISTINCT S.[Order_Number]) AVERAGE_ORDER_VALUE,
SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))*COALESCE( E.[Exchange] ,0)) REVENUELOCAL FROM CUSTOMERS C
INNER JOIN
SALES S
ON C.CUSTOMERKEY=S.CUSTOMERKEY
INNER JOIN
PRODUCTS P
ON P.PRODUCTKEY=S.PRODUCTKEY
LEFT JOIN
DailyExchange  E
ON E.Currency=S.Currency_Code AND E.Date=S.Order_Date
