
<img width="1000" alt="Screen Shot 2025-03-15 at 10 42 16 PM" src="https://github.com/user-attachments/assets/955a7e19-c7a4-4074-bb8a-3a6feb51d1b1" />

# Project Title: Bicycle Manufacturer dataset - Sales Performance Analysis | SQL

Author: [Olivia Nguyen]  
Date: September 2024  
Tools Used: SQL 

---

## 📑 Table of Contents  
I. [📌 Background & Overview](#-background--overview)  
II. [📂 Dataset Description](#-dataset-description)  
III. [📊 Exploring the Dataset](#-exploring-the-dataset)  
IV. [🔎 Final Conclusion & Recommendations](#-final-conclusion--recommendations)

---

## 📌 Background & Overview

### 📖 What is this project about?

The objective of this project is to explore a Bicycle Manufacturer dataset to analyze sales performance across subcategories and territories, inventory management, and customer retention. This involves using advanced SQL techniques in Google BigQuery, including sliding windows, common table expressions (CTEs), and date-time manipulation to extract actionable insights. The findings will empower stakeholders to make informed strategic decisions and enhance overall business operations.

### 👤 Who is this project for?  
Marketing and Sales teams


## 📂 Dataset Description

### 🌐 Data Source  
- The Bicycle Manufacturer dataset is stored in a public Google BigQuery dataset named "adventureworks2019"
- To access the dataset, we log in to your Google Cloud Platform, navigate to the BigQuery console and search the project "adventureworks2019".

### 🔀  Data Modelling:

There are six tables used in this project to support the analysis and generate insights.

<details>
<summary>Table 1: Sales.SalesOrderHeader</summary>  

| Name                   | Data type       | Description / Attributes                                                                          |
|------------------------|-----------------|---------------------------------------------------------------------------------------------------|
| SalesOrderID           | int             | Primary key. Identity / Auto increment column                                            |
| RevisionNumber         | tinyint         | Incremental number to track changes to the sales order over time. Default: 0                      |
| OrderDate              | datetime        | Dates the sales order was created. Default: getdate()                                             |
| DueDate                | datetime        | Date the order is due to the customer.                                                            |
| ShipDate               | datetime        | Date the order was shipped to the customer.                                                       |
| Status                 | tinyint         | Order current status. 1 = In process; 2 = Approved; 3 = Backordered; 4 = Rejected; 5 = Shipped; 6 = Cancelled Default: 1 |
| OnlineOrderFlag        | bit             | 0 = Order placed by sales person. 1 = Order placed online by customer. Default: 1                 |
| SalesOrderNumber       | nvarchar(25)    | Unique sales order identification number. Computed: isnul(N'SO'+CONVERT(nvarchar(23),[SalesOrderID]),N'*** ERROR ***') |
| PurchaseOrderNumber    | nvarchar(25)    | Customer purchase order number reference.                                                         |
| AccountNumber          | nvarchar(15)    | Financial accounting number reference.                                                            |
| CustomerID             | int             | Customer identification number. Foreign key to Customer.BusinessEntityID.                         |
| SalesPersonID          | int             | Sales person who created the sales order. Foreign key to SalesPerson.BusinessEntityID.            |
| TerritoryID            | int             | Territory in which the sale was made. Foreign key to SalesTerritory.SalesTerritoryID.             |
| BillToAddressID        | int             | Customer billing address. Foreign key to Address.AddressID.                                       |
| ShipToAddressID        | int             | Customer shipping address. Foreign key to Address.AddressID.                                      |
| ShipMethodID           | int             | Shipping method. Foreign key to ShipMethod.ShipMethodID.                                          |
| CreditCardID           | int             | Credit card identification number. Foreign key to CreditCard.CreditCardID.                        |
| CreditCardApprovalCode | varchar(15)     | Approval code provided by the credit card company.                                                |
| CurrencyRateID         | int             | Currency exchange rate used. Foreign key to CurrencyRate.CurrencyRateID.                          |
| SubTotal               | money           | Sales subtotal. Computed as SUM(SalesOrderDetail.LineTotal) for the appropriate SalesOrderID. Default: 0.00 |
| TaxAmt                 | money           | Tax amount. Default: 0.00                                                                         |
| Freight                | money           | Shipping cost. Default: 0.00                                                                      |
| TotalDue               | money           | Total due from customer. Computed as Subtotal + TaxAmt + Freight. Computed: isnul(((SubTotal)+(TaxAmt))+(Freight),(0)) |
| Comment                | nvarchar(128)   | Sales representative comments.                                                                    |
| rowguid                | uniqueidentifier| ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample. Default: newid() |
| ModifiedDate           | datetime       | Date and time the record was last updated. Default: getdate()                                     |

</details>

<details>
<summary>Table 2: Sales.SalesOrderDetail</summary>

| Column Name            | Data Type       | Description/Attributes                                                                   |
|------------------------|-----------------|------------------------------------------------------------------------------------------|
| SalesOrderID           | int             | Primary key. Foreign key to SalesOrderHeader.SalesOrderID.                                |
| SalesOrderDetailID     | int             | Primary key. One incremental unique number per product sold. Identity / Auto increment.   |
| CarrierTrackingNumber  | nvarchar(25)    | Shipment tracking number supplied by the shipper.                                         |
| OrderQty               | smallint        | Quantity ordered per product.                                                            |
| ProductID              | int             | Product sold to customer. Foreign key to Product.ProductID.                               |
| SpecialOfferID         | int             | Promotional code. Foreign key to SpecialOffer.SpecialOfferID.                             |
| UnitPrice              | money           | Selling price of a single product.                                                       |
| UnitPriceDiscount      | money           | Discount amount. Default: 0.0.                                                           |
| LineTotal              | numeric(38, 6)   | Per product subtotal. Computed as UnitPrice * (1 - UnitPriceDiscount) * OrderQty. Computed: isnull((([UnitPrice]*((1.0-[UnitPriceDiscount])*[OrderQty]),(0.0)) |
| rowguid                | uniqueidentifier | ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample. Default: newid() |
| ModifiedDate           | datetime         | Date and time the record was last updated. Default: getdate()                                                 |

</details>

<details>
<summary>Table 3: Production.Product</summary>

| Name                     | Data type        | Description / Attributes                                                                                      |
|--------------------------|------------------|---------------------------------------------------------------------------------------------------------------|
| ProductID                | int              | Primary key for Product records. Identity / Auto increment column                                             |
| Name                     | nvarchar(50)     | Name of the product.                                                                                          |
| ProductNumber            | nvarchar(25)     | Unique product identification number.                                                                         |
| MakeFlag                 | bit              | 0 = Product is purchased, 1 = Product is manufactured in-house. Default: 1                                    |
| FinishedGoodsFlag        | bit              | 0 = Product is not a salable item. 1 = Product is salable. Default: 1                                         |
| Color                    | nvarchar(15)     | Product color.                                                                                                |
| SafetyStockLevel         | smallint         | Minimum inventory quantity.                                                                                   |
| ReorderPoint             | smallint         | Inventory level that triggers a purchase order or work order.                                                 |
| StandardCost             | money            | Standard cost of the product.                                                                                 |
| ListPrice                | money            | Selling price.                                                                                                |
| Size                     | nvarchar(5)      | Product size.                                                                                                 |
| SizeUnitMeasureCode      | nchar(3)         | Unit of measure for Size column.                                                                              |
| WeightUnitMeasureCode    | nchar(3)         | Unit of measure for Weight column.                                                                            |
| Weight                   | decimal(8, 2)    | Product weight.                                                                                               |
| DaysToManufacture        | int              | Number of days required to manufacture the product.                                                           |
| ProductLine              | nchar(2)         | R = Road, M = Mountain, T = Touring, S = Standard                                                             |
| Class                    | nchar(2)         | H = High, M = Medium, L = Low                                                                                 |
| Style                    | nchar(2)         | W = Womens, M = Mens, U = Universal                                                                           |
| ProductSubcategoryID     | int              | Product is a member of this product subcategory. Foreign key to ProductSubCategory.ProductSubCategoryID.       |
| ProductModelID           | int              | Product is a member of this product model. Foreign key to ProductModel.ProductModelID.                         |
| SellStartDate            | datetime         | Date the product was available for sale.                                                                      |
| SellEndDate              | datetime         | Date the product was no longer available for sale.                                                            |
| DiscontinuedDate         | datetime         | Date the product was discontinued.                                                                            |
| rowguid                  | uniqueidentifier | ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample. Default: newid()|
| ModifiedDate             | datetime         | Date and time the record was last updated. Default: getdate()                                                 |

</details>

<details>
<summary>Table 4: Production.ProductSubcategory </summary> 

| Name                  | Data type        | Description / Attributes                                                                                      |
|-----------------------|------------------|---------------------------------------------------------------------------------------------------------------|
| ProductSubcategoryID  | int              | Primary key for ProductSubcategory records. Identity / Auto increment column.                                  |
| ProductCategoryID     | int              | Product category identification number. Foreign key to ProductCategory.ProductCategoryID.                      |
| Name                  | nvarchar(50)     | Subcategory description.                                                                                       |
| rowguid               | uniqueidentifier | ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample. Default: newid()|
| ModifiedDate          | datetime         | Date and time the record was last updated. Default: getdate()                                                 |

</details>

<details>
<summary>Table 5: Production.WorkOrder</summary>

| Name                  | Data type        | Description / Attributes                                                                                      |
|-----------------------|------------------|---------------------------------------------------------------------------------------------------------------|
| WorkOrderID           | int              | Primary key for WorkOrder records. Identity / Auto increment column                                           |
| ProductID             | int              | Product identification number. Foreign key to Product.ProductID                                               |
| OrderQty              | int              | Product quantity to build                                                                                     |
| StockedQty            | int              | Quantity built and put in inventory. Computed: isnull([OrderQty] - [ScrappedQty], 0)                           |
| ScrappedQty           | smallint         | Quantity that failed inspection                                                                               |
| StartDate             | datetime         | Work order start date                                                                                         |
| EndDate               | datetime         | Work order end date                                                                                           |
| DueDate               | datetime         | Work order due date                                                                                           |
| ScrapReasonID         | smallint         | Reason for inspection failure                                                                                 |
| ModifiedDate          | datetime         | Date and time the record was last updated. Default: getdate()                                                 |

</details>

<details>
<summary>Table 6: Purchasing.PurchaseOrderHeader</summary>

| Name                | Data type  | Description / Attributes                                                                                              |
|---------------------|------------|-----------------------------------------------------------------------------------------------------------------------|
| PurchaseOrderID     | int        | Primary key. Identity / Auto increment column.                                                                         |
| RevisionNumber      | tinyint    | Incremental number to track changes to the purchase order over time. Default: 0                                        |
| Status              | tinyint    | Order current status. 1 = Pending; 2 = Approved; 3 = Rejected; 4 = Complete. Default: 1                               |
| EmployeeID          | int        | Employee who created the purchase order. Foreign key to Employee.BusinessEntityID.                             |
| VendorID            | int        | Vendor with whom the purchase order is placed. Foreign key to Vendor.BusinessEntityID.                        |
| ShipMethodID        | int        | Shipping method. Foreign key to ShipMethod.ShipMethodID.                                                      |
| OrderDate           | datetime   | Purchase order creation date. Default: getdate()                                                              |
| ShipDate            | datetime   | Estimated shipment date from the vendor.                                                                      |
| SubTotal            | money      | Purchase order subtotal. Computed as SUM(PurchaseOrderDetail.LineTotal) for the appropriate PurchaseOrderID. Default: 0.00 |
| TaxAmt              | money      | Tax amount. Default: 0.00                                                                                      |
| Freight             | money      | Shipping cost. Default: 0.00                                                                                   |
| TotalDue            | money      | Total due to vendor. Computed as Subtotal + TaxAmt + Freight. Computed: isnull((([SubTotal] + [TaxAmt]) + [Freight]), (0)) |
| ModifiedDate        | datetime   | Date and time the record was last updated. Default: getdate()                                                  |

</details>

![image](https://github.com/user-attachments/assets/9ddad757-f722-4866-8cfe-d3921379c990)



## [📊 Exploring the Dataset

### Query 01: Calculate Quantity of items, Sales value and Order quantity by each Subcategory in  last 12 months
> Assess the performance of different product categories over time, identify trends, and evaluate which subcategories are driving revenue

```sql
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
```

<img width="740" alt="Screen Shot 2025-03-04 at 10 00 37 AM" src="https://github.com/user-attachments/assets/fd855975-bf37-45dc-8a03-36a95b601fba" />

🚀 The data shows that Road, Mountain, and Touring Bikes generate the highest revenue and sales volume. Among accessories, Helmets, Jerseys, and Tires have the highest unit sales. While overall sales have remained relatively stable across the quarters, there was a sharp decline in Q2 2014, primarily driven by a significant drop in June 2014.


### Query 02: Calculate % YoY growth rate by SubCategory and release top 3 catergories with highest grow rate
> Identify the top 3 categories with the highest growth rate helps assess long-term performance trends, highlight successful product categories, and provide insights into areas of sustained growth.

```sql
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
```

<img width="835" alt="Screen Shot 2025-03-04 at 11 31 33 AM" src="https://github.com/user-attachments/assets/654a822d-9d8e-4b26-b550-ef9ddf6ddb54" />

🚀 From 2011 to 2014, the accessories category saw the highest year-over-year volume growth, led by Mountain Frames (2012), Socks (2013), and Road Frames (2012), which surged by 521%, 421%, and 389%, respectively. This significant growth can probably stem from expansion into new markets, product improvements, or a shift in consumer preferences. Understanding the key factors behind this trend is essential for sustaining growth and replicating success across other product lines.


### Query 03: Ranking Top 3 TeritoryID with biggest Order quantity of every year. 
>  Identify the most profitable and active regions, thereby allowing businesses to focus on high-performing territories, allocate resources effectively, and tailor marketing and sales strategies to optimize performance in those regions.

```sql
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
```

<img width="543" alt="Screen Shot 2025-03-04 at 10 05 01 AM" src="https://github.com/user-attachments/assets/c837acc9-2a9d-409b-9a73-1ed0bd231ce9" />

🚀 Regarding geographic performance, the top three territories with the highest sales orders from 2011 to 2014 were TerritoryIDs 4, 6, and 1, maintaining their leading positions throughout the period. While overall order volume experienced significant growth, 2014 saw a sharp decrease. 
It is essential to examine the causes of this downturn and implement appropriate solutions. Additionally, the company should consider replicating the successful strategies of these territories in other regions.


### Query 04: Calculate Total Discount Cost belongs to Seasonal Discount for each SubCategory
> Evaluate the financial impact of seasonal promotions on different product categories.

```sql
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
```

<img width="692" alt="Screen Shot 2025-03-04 at 1 30 27 PM" src="https://github.com/user-attachments/assets/1c7a64ad-c0ae-4ac7-9186-e213ead3e0c0" />

🚀 The company ran the Seasonal Discounts campaign exclusively for the Helmets subcategory in 2012 and 2013. In 2013, this promotion resulted in a 29% increase in helmet sales compared to 2012. However, the total discount nearly doubled, increasing from $827.65 in 2012 to $1,606.04 in 2013.


### Query 05: Retention rate of Customer in 2014 with status of Successfully Shipped (Cohort Analysis) 
> Measure customer loyalty and the effectiveness of order fulfillment

```sql
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
```

<img width="467" alt="Screen Shot 2025-03-04 at 2 13 51 PM" src="https://github.com/user-attachments/assets/02e83b93-2d15-4edd-8b74-efc01a3536f1" />

- 🚀 The number of new customers fluctuated slightly in the first 5 months, then significantly declined in the following two months. 
- 🚀 Retention rates drop quickly across all cohorts, with only 2.83% of February's customers remaining after 1 month, and just 0.44% by month 5. This suggests most users don't find long-term value or engagement with the service.


### Query 06: Trend of Stock level & MoM diff % by all product in 2011. If % growth rate is null then 0.
> Identify inventory fluctuations.

```sql
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
```
<img width="668" alt="Screen Shot 2025-03-04 at 10 13 58 AM" src="https://github.com/user-attachments/assets/a311ebd1-2d6f-4122-8c8b-40fb73a51a91" />

🚀 In the last six months of 2011, product stock levels experienced frequent and significant fluctuations. Notably, inventory surged in October and July before sharply declining in the following months, indicating potential challenges in supply chain and inventory management efficiency. December stock declines across all products may be linked to year-end sales or reduced restocking due to seasonal trends.


### Query 07: Calculate Ratio of Stock / Sales in 2011 by product name, by month
> The stock-to-sales ratio highlights inefficiencies in the company's inventory management. Low-selling products have excessively high ratios, driving up inventory costs, while high-selling products have low or zero ratios, increasing the risk of stockouts and lost sales.

```sql
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
```

<img width="825" alt="Screen Shot 2025-03-04 at 10 15 41 AM" src="https://github.com/user-attachments/assets/3cef9e2e-6833-4f9a-84af-8ce39c288b18" />

🚀 The stock-to-sales ratios reveal significant inventory imbalances across products. High-end mountain frames show excessive stock levels (ratios 10-27) compared to sales, while popular road bikes maintain healthier ratios (1.1-1.5). This suggests potential overproduction or slow turnover for certain mountain frames. The company should reassess its inventory management strategy, particularly for high-ratio items, to optimize stock levels and improve capital efficiency.

### Query 08: Number of order and value at Pending status in 2014
> Pending orders can reflect the efficiency and performance of our vendors.

```sql
SELECT 
        EXTRACT (YEAR FROM OrderDate) AS Year
        ,Status
        ,COUNT(DISTINCT PurchaseOrderID)AS order_count
        ,ROUND(SUM(TotalDue),2) AS value
 FROM `adventureworks2019.Purchasing.PurchaseOrderHeader` 
 WHERE EXTRACT (YEAR FROM OrderDate) = 2014
      AND Status = 1
GROUP BY 1,2;
```

<img width="545" alt="Screen Shot 2025-03-04 at 10 16 13 AM" src="https://github.com/user-attachments/assets/ece49e92-bda6-41f2-80bc-6bc1f46aca62" />

🚀 In 2014, there were 224 pending orders totaling $3,873,579, with an average order value of $17,292.76. This  indicates that pending orders may involve bulk purchases or high-value transactions. Given the significant impact on revenue and customer satisfaction, it is essential to further investigate the factors causing delays.


## 🔎 Final Conclusion & Recommendations

This analysis provides valuable insights into sales performance across products and regions, inventory management, and customer retention. It enables the bicycle manufacturer to identify strengths and weaknesses, allowing them to leverage their strengths and minimize weaknesses to enhance overall business performance.

**Recommendations:**

- Analyze the strategies that led to success in Territories 4, 6, and 1, and **replicate them in underperforming regions** to boost overall sales.
- **Reevaluate the effectiveness of promotional campaigns**, such as the Seasonal Discounts for Helmets, to ensure they drive sales without causing a disproportionate increase in discount costs.
- **Prioritize customer retention** by enhancing the customer experience and providing additional value after the initial purchase to reduce churn.
- Focus on improving demand **forecasting and optimizing just-in-time inventory cycles** to reduce stock imbalances, lower holding costs, and avoid stockouts of high-demand items.
- Conduct a thorough analysis to identify the causes of the sharp sales decline in Q2 2014 and address pending orders to implement prompt and effective solutions.





