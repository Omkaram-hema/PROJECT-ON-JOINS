/*Interview Question: Write a query to display every sales order along with the corresponding customer name, product name, and quantity purchased.
Expected Output (Columns):
Output Column
Order Number
Name
Product Name
Quantity
*/
SELECT S.ORDER_NUMBER,C.NAME,P.PRODUCT_NAME,S.QUANTITY  FROM CUSTOMERS C
INNER JOIN
SALES S
ON C.CustomerKey=S.CustomerKey
INNER JOIN 
PRODUCTS P
ON S.ProductKey=P.ProductKey
--------------------------------------------------------------
/*2 Interview Question: Write a query to display, for every sale, the customer name, customer country, product name, product category, and quantity sold.
Name
Country
Product Name
Category
Quantity*/

SELECT C.NAME,C.COUNTRY,P.PRODUCT_NAME,P.CATEGORY,S.QUANTITY FROM Customers C
INNER  JOIN
SALES S
ON C.CustomerKey=S.CustomerKey
LEFT JOIN
Products P
ON S.ProductKey=P.ProductKey
----------------------------------------------------------------------
/*Question 3
Interview Question: Write a query to calculate the total quantity sold for each combination of store country and product category.
Expected Output (Columns):
Output Column
Country
Category
TotalQty
*/
SELECT SUM(S.QUANTITY) Q,P.CATEGORY,ST.COUNTRY  FROM STORES ST
INNER JOIN
SALES S
ON ST.StoreKey=S.StoreKey
INNER JOIN
Products P
ON P.ProductKey=S.ProductKey
GROUP BY P.CATEGORY,ST.COUNTRY
---------------------------------------------------------------------------------------
/*
Q-4
Interview Question: Write a query to calculate the total sales revenue (in USD) generated across all orders.
Expected Output (Columns):
Output Column
TotalSalesUSD */
SELECT SUM(S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) )) REVENUE FROM SALES S
INNER JOIN 
PRODUCTS P
ON S.ProductKey=P.ProductKey
--------------------------------------------------------------------------------------
/* Q-5
Interview Question: Write a query to calculate total sales converted into each order's local currency,
using the exchange rate matched by currency code and order date.
Expected Output (Columns):
Output Column
Order Number
Currency Code
LocalSales*/
WITH CTE AS (
SELECT 
[Currency],[Date],AVG([Exchange]) E_AVG  FROM [dbo].[Exchange_Rates] 
GROUP BY [Currency],[Date]
)
SELECT S.ORDER_NUMBER,D.[Currency],SUM(D.E_AVG*S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) ))  LOCAL_REVENUE FROM 
CTE D
INNER JOIN
SALES S
ON S.CURRENCY_CODE=D.CURRENCY AND S.Order_Date=D.Date
INNER JOIN
Products P
ON P.ProductKey=S.ProductKey
GROUP BY S.ORDER_NUMBER,D.[Currency]
--------------------------------------------------------------------------------------
/*Question 6
Interview Question: Write a query to display, for each order, the total sales in both USD and the local currency side by side.
Expected Output (Columns):
Output Column
Order Number
SalesUSD
LocalSales
*/
WITH EXCHANGE AS (
SELECT 
[Currency],[Date],AVG([Exchange]) E_AVG  FROM [dbo].[Exchange_Rates] 
GROUP BY [Currency],[Date]
)
SELECT S.ORDER_NUMBER,SUM(D.E_AVG*S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) ))  LOCAL_REVENUE,
SUM(S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) )) SALESUSD
FROM 
EXCHANGE D
INNER JOIN
SALES S
ON S.CURRENCY_CODE=D.CURRENCY AND S.Order_Date=D.Date
INNER JOIN
Products P
ON P.ProductKey=S.ProductKey
GROUP BY S.ORDER_NUMBER
--------------------------------------------------------------------------------------
/*Question 7
Interview Question: Assume the Sales table stores the order amount in local currency. 
Write a query to convert this local currency amount into USD for each order using the applicable exchange rate.
Expected Output (Columns):
Output Column
Order Number
USDAmount*/
WITH EXCHANGE AS (
SELECT 
[Currency],[Date],AVG([Exchange]) E_AVG  FROM [dbo].[Exchange_Rates] 
GROUP BY [Currency],[Date]
)
SELECT S.ORDER_NUMBER,(SUM(S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) ))/MAX(E_AVG)) USDAMOUNT FROM SALES S
INNER JOIN
EXCHANGE E
ON S.Currency_Code=E.CURRENCY AND S.Order_Date=E.DATE
INNER JOIN
Products P
ON P.ProductKey=S.ProductKey
GROUP BY S.ORDER_NUMBER
--------------------------------------------------------------------------------------
/*
Question 8
Interview Question: Write a query to identify the top 10 customers ranked by total sales revenue.
Expected Output (Columns):
Output Column
Name
Sales
*/
SELECT TOP 10  C.NAME,SUM(S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) )) REVENUE FROM CUSTOMERS C
INNER JOIN
SALES S
ON C.CustomerKey=S.CustomerKey
INNER JOIN
Products P
ON S.ProductKey=P.ProductKey
GROUP BY C.NAME
ORDER BY REVENUE DESC
--------------------------------------------------------------------------------------

/*
Question 9
Interview Question: Write a query to find the best-selling product (by revenue) within each product category.
Expected Output (Columns):
Output Column
Category
Product Name
Sales
RN
*/
WITH CTE AS (
SELECT P.CATEGORY,P.PRODUCT_NAME,SUM(S.QUANTITY*TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) )) SALES ,
ROW_NUMBER() OVER(PARTITION BY P.CATEGORY ORDER BY SUM(S.QUANTITY*TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) )) DESC) RN
FROM Products P
INNER JOIN
SALES S
ON P.ProductKey=S.ProductKey
GROUP BY P.CATEGORY,P.PRODUCT_NAME
) SELECT * FROM CTE WHERE RN=1
--------------------------------------------------------------------------------------

/*
Question 10
Interview Question: Write a query to calculate the number of days taken to deliver each order, along with the customer name.
Expected Output (Columns):
Output Column
Order Number
DeliveryDays
Name
*/
SELECT * FROM (
SELECT S.ORDER_NUMBER,C.NAME,DATEDIFF(DW,S.ORDER_DATE,S.DELIVERY_DATE) AS DELIVER_DAYS FROM Customers C
INNER JOIN
SALES S
ON C.CustomerKey=S.CustomerKey
) A WHERE DELIVER_DAYS IS NOT NULL 
--------------------------------------------------------------------------------------

/* Question 11
Interview Question: Write a query to calculate the average order delivery time (in days) for each customer country.
Expected Output (Columns):
Output Column
Country
AvgDays
*/
select C.COUNTRY,AVG(DATEDIFF(DW,S.ORDER_DATE,S.DELIVERY_DATE)) AS AVERAGE_ORD FROM Customers C
INNER JOIN
SALES S
ON C.CustomerKey=S.CustomerKey
WHERE S.DELIVERY_DATE IS NOT NULL
GROUP BY C.Country
-------------------------------------------------------------------------
/* Question 12
Interview Question: Write a query to identify the top 5 product brands ranked by total revenue.
Expected Output (Columns):
Output Column
Brand
Revenue
*/
SELECT TOP 5 P.BRAND,SUM(S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) ))  REVENUE FROM Products P
INNER JOIN 
SALES S
ON P.ProductKey=S.ProductKey
GROUP BY P.BRAND
ORDER BY REVENUE DESC
---------------------------------------------------
/* Question 13
Interview Question: Write a query to identify the single store that has generated the highest total revenue.
Expected Output (Columns):
Output Column
StoreKey
Revenue
*/
SELECT TOP 1 S.[StoreKey],SUM(S.QUANTITY* TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')))) REVENUE FROM PRODUCTS P
INNER JOIN
SALES S
ON P.PRODUCTKEY=S.ProductKey
GROUP BY S.StoreKey
ORDER BY REVENUE DESC
----------------------------------------------------------------------------
/* Question 14
Interview Question: Write a query to calculate the total profit generated by each product category.
Expected Output (Columns):
Output Column
Category
Profit
*/
SELECT P.CATEGORY,SUM((S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) )) - (S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_COST_USD,'$','')) ))) PROFIT FROM PRODUCTS P
INNER JOIN
SALES S
ON P.ProductKey=S.ProductKey
GROUP BY P.Category
------------------------------------------------------------------------------------------
/* Question 15
Interview Question: Write a query to calculate the total profit generated by customers in each country.
Expected Output (Columns):
Output Column
Country
Profit
*/
SELECT C.COUNTRY,SUM((S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) )) - (S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_COST_USD,'$','')) ))) PROFIT FROM PRODUCTS P
INNER JOIN
SALES S
ON P.ProductKey=S.ProductKey
INNER JOIN
Customers C
ON C.CustomerKey=S.CustomerKey
GROUP BY C.Country
------------------------------------------------------------------------------------
/* Question 16
Interview Question: Write a query to identify the top 3 best-selling products (by revenue) within each product category, using a ranking window function such as ROW_NUMBER(), RANK(), or DENSE_RANK().
Expected Output (Columns):
Output Column
Category
Product Name
Revenue
Rank
*/

WITH CTE AS (
SELECT  P.[Category],P.[Product_Name],SUM(S.QUANTITY* TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) REVENUE,DENSE_RANK() OVER(PARTITION BY  P.[Category] ORDER BY SUM(S.QUANTITY* TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) DESC ) RANK
FROM Products P
INNER JOIN 
SALES S
ON P.ProductKey=S.ProductKey
GROUP BY P.[Category],P.[Product_Name]
) SELECT * FROM CTE 
WHERE RANK <=3
-------------------------------------------------------------------------------------------------------
/* Question 17
Interview Question: Write a query to calculate each customer's age at the time they placed each order.
Expected Output (Columns):
Output Column
Name
Age
*/
SELECT C.NAME,
CASE 
WHEN DATEADD(YEAR,DATEDIFF(YEAR, C.Birthday, S.Order_Date),C.Birthday) > S.Order_Date
THEN DATEDIFF(YEAR, C.Birthday, S.Order_Date) - 1
ELSE DATEDIFF(YEAR, C.Birthday, S.Order_Date)
END AS AGE
FROM Customers C
INNER JOIN
SALES S
ON C.CustomerKey=S.CustomerKey
WHERE S.[Order_Date]  IS NOT NULL
--------------------------------------------------------------------------------------------------------
/*Question 18
Interview Question: Write a query to identify customers who have made purchases from more than one store.
Expected Output (Columns):
Output Column
Name
StoresVisited
*/
SELECT C.NAME,COUNT(DISTINCT S.STOREKEY) STORESVISITED FROM [dbo].[Customers] C
INNER JOIN
SALES S
ON C.CustomerKey=S.CustomerKey
GROUP BY C.NAME
HAVING COUNT(DISTINCT S.STOREKEY) > 1
ORDER BY C.NAME 
-----------------------------------------------------------------------------------------------------
/*Question 19
Interview Question: Write a query to calculate total revenue generated by each store, grouped by store country and state.
Expected Output (Columns):
Output Column
Country
State
Revenue
*/
SELECT S.COUNTRY,S.STATE,SUM(SA.QUANTITY*TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) ))  REVENUE FROM
STORES S
INNER JOIN 
SALES SA 
ON SA.[StoreKey]=S.STOREKEY
INNER JOIN
PRODUCTS P
ON P.[ProductKey]=SA.ProductKey
GROUP BY  S.COUNTRY,S.STATE
-----------------------------------------------------------------------------------------------
/*Question 20
Interview Question: Write a query to calculate total revenue generated on each continent.
Expected Output (Columns):
Output Column
Continent
Revenue
*/
SELECT C.[Continent],SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) REVENUE FROM 
Customers C
INNER JOIN
SALES S
ON C.CustomerKey=S.CustomerKey
INNER JOIN
Products P
ON P.ProductKey=S.ProductKey
GROUP BY  C.[Continent]
--------------------------------------------------------------------------------
/*Question 21
Interview Question: Write a query to identify repeat customers, i.e., customers who have placed more than one order.
Expected Output (Columns):
Output Column
Name
TotalOrders
*/
SELECT C.NAME,COUNT(S.[Order_Number]) TOTALORDERS FROM
CUSTOMERS C
INNER JOIN
SALES S
ON C.CustomerKey=S.CustomerKey
GROUP BY C.NAME
HAVING COUNT(S.[Order_Number]) >1
-------------------------------------------------------------------------------------------
/*Question 22
Interview Question: Write a query to identify customers who have purchased products from more than one product category.
Expected Output (Columns):
Output Column
Name
CategoriesPurchased
*/
SELECT C.NAME,COUNT(DISTINCT P.Category) CategoriesPurchased FROM 
Customers C
INNER JOIN 
SALES S 
ON C.CustomerKey=S.CustomerKey
INNER JOIN
Products P
ON S.ProductKey=P.ProductKey
GROUP BY C.NAME
HAVING COUNT(DISTINCT P.Category) > 1
------------------------------------------------------------------------------------
/*Question 23
Interview Question: Write a query to calculate total monthly sales revenue for each country.
Expected Output (Columns):
Output Column
SalesYear
SalesMonth
Country
SalesUSD
*/
SELECT DATEPART(YEAR,S.[Order_Date]) SALESYEAR,DATEPART(MM,S.[Order_Date]) SALESMONTH,C.COUNTRY,SUM(S.QUANTITY*TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) ))
SALESUSD FROM Customers C
INNER JOIN
SALES S
ON C.CustomerKey=S.CustomerKey
INNER JOIN
Products P
ON P.ProductKey=S.ProductKey
GROUP BY DATEPART(YEAR,S.[Order_Date]) ,DATEPART(MM,S.[Order_Date]) ,C.COUNTRY
-----------------------------------------------------------------
/*Question 24
Interview Question: Write a query to identify the top-selling product (by quantity) in each country.
Expected Output (Columns):
Output Column
Country
Product Name
TotalQty
*/
SELECT * FROM (
SELECT  C.COUNTRY,P.[Product_Name],SUM(S.[Quantity]) TotalQty,DENSE_RANK() OVER(PARTITION BY C.COUNTRY ORDER BY SUM(S.[Quantity]) DESC) RNK
FROM Customers C
INNER JOIN
SALES S
ON C.CustomerKey=S.CustomerKey
INNER JOIN
Products P
ON P.ProductKey=S.ProductKey
GROUP BY C.COUNTRY,P.[Product_Name]
) A
WHERE RNK=1
-----------------------------------------------------------------------------------------
/*Question 25 
Interview Question: Write a query to calculate revenue, cost, profit, profit percentage, and revenue in local currency for each country.
Expected Output (Columns):
Output Column
Country
RevenueUSD
CostUSD
ProfitUSD
ProfitPercentage
RevenueLocalCurrency
*/
WITH EXCHANGE AS (
SELECT 
[Currency],[Date],AVG([Exchange]) E_AVG  FROM [dbo].[Exchange_Rates] 
GROUP BY [Currency],[Date]
)
SELECT C.COUNTRY, SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))) REVENUE,
SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Cost_USD],'$','')))) COST,
SUM((S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) )) - (S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_COST_USD,'$','')) ))) PROFIT,
(SUM((S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_Price_USD,'$','')) )) - (S.QUANTITY * TRY_CONVERT (DECIMAL(10,2),(REPLACE(P.Unit_COST_USD,'$','')) )))/
SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$','')))))*100 PROFIT_PER ,
SUM(S.[Quantity] * TRY_CONVERT(DECIMAL(10,2),(REPLACE(P.[Unit_Price_USD],'$',''))) *E_AVG) REVEN_LOCAL
FROM Customers C
INNER JOIN
SALES S
ON C.CustomerKey=S.CustomerKey
INNER JOIN
EXCHANGE E
ON E.Date=S.Order_Date AND  E.Currency=S.Currency_Code
INNER JOIN 
PRODUCTS P
ON P.ProductKey=S.ProductKey
GROUP BY C.Country
-----------------------------------------------------------------------------------------------------------------
