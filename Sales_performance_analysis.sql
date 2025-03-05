--Question 1: Calculate Quantity of items, Sales value & Order quantity by each Subcategory in L12M

WITH the_last_day AS (
    SELECT DATE(MAX(ModifiedDate))AS last_day	
      FROM `adventureworks2019.Sales.SalesOrderDetail`)

SELECT 
    DATE_TRUNC(DATE(a.ModifiedDate), MONTH) AS period -- Convert ModifiedDate to DATE
    ,c.name
    ,SUM(a.OrderQty) AS qt_item
    ,ROUND(SUM(a.LineTotal),2) AS total_sales
    ,COUNT(DISTINCT a.SalesOrderID) AS order_cnt
FROM `adventureworks2019.Sales.SalesOrderDetail` AS a
LEFT JOIN `adventureworks2019.Production.Product` AS b
    ON a.ProductID = b.ProductID
LEFT JOIN `adventureworks2019.Production.ProductSubcategory` AS c
    ON CAST(b.ProductSubcategoryID AS INT) = c.ProductSubcategoryID 
WHERE DATE(a.ModifiedDate) >= (SELECT last_day FROM the_last_day) - INTERVAL 12 MONTH									
GROUP BY 1, 2									
ORDER BY 1 DESC, 2 ASC;	


-- Question 2: Calculate % YoY growth rate by SubCategory & release top 3 cat with highest grow rate


WITH 
sale_info AS (
  SELECT 
      FORMAT_TIMESTAMP("%Y", a.ModifiedDate) AS year
      , c.Name
      , SUM(a.OrderQty) AS qty_item

  FROM `adventureworks2019.Sales.SalesOrderDetail` a 
  LEFT JOIN `adventureworks2019.Production.Product` b 
    ON a.ProductID = b.ProductID
  LEFT JOIN `adventureworks2019.Production.ProductSubcategory` c 
    ON CAST(b.ProductSubcategoryID AS INT) = c.ProductSubcategoryID
  GROUP BY 1,2
  ORDER BY 2 ASC , 1 DESC
),

get_growth_rate AS (
  SELECT *
  , LEAD (qty_item) OVER (PARTITION BY Name ORDER BY year DESC) AS prv_qty
  , ROUND(qty_item / (LEAD (qty_item) OVER (PARTITION BY Name ORDER BY year DESC)) -1,2) as growth_rate
  FROM sale_info
  ORDER BY 5 DESC
),

rank_growth_rate AS (
  SELECT *
      ,DENSE_RANK() OVER(ORDER BY growth_rate DESC) AS ranking
  FROM get_growth_rate 
)

SELECT DISTINCT Name
      , year
      , qty_item
      , prv_qty
      , growth_rate
      , ranking
FROM rank_growth_rate
WHERE ranking <=3
ORDER BY ranking;


-- Question 3: Ranking Top 3 TeritoryID with biggest Order quantity of every year. 

WITH count_order AS (
    SELECT 
        EXTRACT (YEAR FROM a.ModifiedDate) AS Year
        ,c.TerritoryID
        ,SUM(a.OrderQty) AS order_cnt
    FROM `adventureworks2019.Sales.SalesOrderDetail` AS a
    LEFT JOIN `adventureworks2019.Sales.SalesOrderHeader` AS b ON a.SalesOrderID  = b.SalesOrderID 
    LEFT JOIN `adventureworks2019.Sales.SalesTerritory` AS c ON b.TerritoryID = c.TerritoryID
    GROUP BY 1,2)

, get_ranking AS(
    SELECT 
        *
        ,DENSE_RANK() OVER(PARTITION BY Year ORDER BY order_cnt DESC) AS ranking
    FROM count_order
    ORDER BY 1 DESC)

SELECT *
FROM get_ranking
WHERE ranking <4;


-- Question 4: Calculate Total Discount Cost belongs to Seasonal Discount for each SubCategory 

SELECT 
    EXTRACT (YEAR FROM a.ModifiedDate) AS Year
    ,c.name AS Name
    ,SUM(a.OrderQty) AS total_quantity
    ,ROUND(SUM(a.OrderQty*a.UnitPrice),2) AS revenue
    ,ROUND(SUM(d.DiscountPct * a.OrderQty*a.UnitPrice),2) AS total_discount_cost
FROM `adventureworks2019.Sales.SalesOrderDetail` AS a
LEFT JOIN `adventureworks2019.Production.Product` AS b ON a.ProductID = b.ProductID
LEFT JOIN `adventureworks2019.Production.ProductSubcategory` AS c ON CAST(b.ProductSubcategoryID AS INT) = c.ProductSubcategoryID
LEFT JOIN `adventureworks2019.Sales.SpecialOffer` AS d ON a.SpecialOfferID = d.SpecialOfferID
WHERE lower(d.Type) LIKE '%seasonal discount%' 
GROUP BY 1,2;


-- Question 5: Retention rate of Customer in 2014 with status of Successfully Shipped (Cohort Analysis)

WITH
info AS (
  SELECT   
      EXTRACT(MONTH FROM ModifiedDate) AS month_no
      , CustomerID
      , count(DISTINCT SalesOrderID) AS order_cnt
  FROM `adventureworks2019.Sales.SalesOrderHeader`
  WHERE FORMAT_TIMESTAMP("%Y", ModifiedDate) = '2014'
  AND Status = 5
  GROUP BY 1,2
  ORDER BY 3,1)

, row_num AS (
  SELECT  *
      , ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY month_no) AS row_numb
  FROM info )

, first_order AS (
  SELECT  *
  FROM row_num
  WHERE row_numb = 1) 

, month_gap AS (
  SELECT  
      a.CustomerID
      , b.month_no AS month_join
      , a.month_no AS month_order
      , a.order_cnt
      , concat('M - ',a.month_no - b.month_no) AS month_diff
  FROM info a 
  LEFT JOIN first_order b 
  ON a.CustomerID = b.CustomerID
  ORDER BY 1,3)

, cohort_data AS(
  SELECT  month_join
      , month_diff 
      , count(DISTINCT CustomerID) AS customer_cnt
      , FIRST_VALUE(count(DISTINCT CustomerID)) OVER (PARTITION BY month_join ORDER BY month_join) AS initial_customer_cnt
  FROM month_gap
  GROUP BY 1,2
  ORDER BY 1,2)

SELECT
    month_join
    , month_diff 
    , customer_cnt
    -- Calculate the retention rate as (customer_cnt / initial_customer_cnt) * 100
    ,ROUND((customer_cnt * 100.0) / initial_customer_cnt, 2) AS retention_rate_percentage
FROM
    cohort_data
ORDER BY
     1,2;


-- Question 6: Trend of Stock level & MoM diff % by all product in 2011. If %gr rate is null then 0.

WITH get_stock_qty AS (
    SELECT
        b.Name
        ,EXTRACT (MONTH FROM a.ModifiedDate) AS Month
        ,EXTRACT (YEAR FROM a.ModifiedDate) AS Year
        ,SUM(a.StockedQty) AS Stock_qty
    FROM `adventureworks2019.Production.WorkOrder`  AS a
    LEFT JOIN `adventureworks2019.Production.Product`AS b
        ON a.ProductID = b.ProductID
    WHERE EXTRACT (YEAR FROM a.ModifiedDate) = 2011
    GROUP BY 1,2,3
    ORDER BY 1 ASC, 2 DESC)

,get_stock_previous AS (
    SELECT *
        ,LEAD(Stock_qty) OVER (PARTITION BY Name ORDER BY Month DESC) AS Stock_pre
    FROM get_stock_qty 
    ORDER BY Name, Month DESC)

SELECT *
    ,ROUND(COALESCE((Stock_qty/Stock_pre -1)*100,0),1) AS diff 
FROM get_stock_previous
WHERE Stock_pre >0;


-- Question 7: Calculate Ratio of Stock / Sales in 2011 by product name, by month

WITH sales_info AS (
    SELECT 
        EXTRACT(MONTH FROM a.ModifiedDate) AS Month
        ,EXTRACT(YEAR FROM a.ModifiedDate) AS Year
        ,a.ProductID
        ,b.Name
        ,SUM(a.OrderQty) AS Sales
    FROM `adventureworks2019.Sales.SalesOrderDetail` AS a
    LEFT JOIN `adventureworks2019.Production.Product` AS b
        ON a.ProductID = b.ProductID
    WHERE EXTRACT(YEAR FROM a.ModifiedDate)= 2011
    GROUP BY 1,2,3,4
    ORDER BY 1 DESC)

, stocks_info AS (
    SELECT 
        EXTRACT(MONTH FROM ModifiedDate) AS Month
        ,EXTRACT(YEAR FROM ModifiedDate) AS Year
        ,ProductID
        ,SUM(StockedQty) AS Stock_quantity
    FROM `adventureworks2019.Production.WorkOrder` 
    WHERE EXTRACT(YEAR FROM ModifiedDate)= 2011
    GROUP BY 1,2,3
    ORDER BY 1 DESC)

  SELECT 
      a.*
      ,b.Stock_quantity AS Stock
      ,ROUND(COALESCE(b.Stock_quantity,0)/a.Sales,1) AS Ratio
  FROM sales_info AS a
  LEFT JOIN stocks_info AS b
      ON a.ProductID = b.ProductID
  AND a.Month = b.Month
  AND a.Year = b.Year
  ORDER BY 1 DESC, 7 DESC;


-- Question 8: Number of order and value at Pending status in 2014

SELECT 
        EXTRACT (YEAR FROM OrderDate) AS Year
        ,Status
        ,COUNT(DISTINCT PurchaseOrderID)AS order_count
        ,ROUND(SUM(TotalDue),2) AS value
 FROM `adventureworks2019.Purchasing.PurchaseOrderHeader` 
 WHERE EXTRACT (YEAR FROM OrderDate) = 2014
      AND Status = 1
GROUP BY 1,2;