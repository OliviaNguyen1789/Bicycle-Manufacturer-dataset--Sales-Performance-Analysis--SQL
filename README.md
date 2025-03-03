# -SQL-Sales-Performance-Analysis

Author: [Uyen Nguyen]  
Date: September 2024  
Tools Used: SQL 

---

## 📑 Table of Contents  
I. [Introduction](#i-introduction)  
II. [Dataset Description](#ii-dataset-description)  
III. [Exploring the Dataset](#iii-exploring-the-dataset)  
IV. [Final Conclusion & Recommendations](#iv-final-conclusion--recommendations)

---

## I. Introduction

This project explores a Bicycle Manufacturer dataset using advanced SQL techniques in Google BigQuery, including sliding windows, common table expressions (CTEs), and date-time manipulation. 

The analysis focuses on sales performance across subcategories and territories, inventory management, and customer retention. The insights gained will empower stakeholders to make informed strategic decisions and enhance overall business operations.

## II. Dataset Description

- Source: The Bicycle Manufacturer dataset is stored in a public Google BigQuery dataset named "adventureworks2019"
- Data Structure: (bổ sung schema trong power BI)





## III. Exploring the Dataset

### Query 01: Calculate Quantity of items, Sales value and Order quantity by each Subcategory in  last 12 months
<img width="812" alt="Screen Shot 2025-03-04 at 9 58 05 AM" src="https://github.com/user-attachments/assets/20837cb0-1a83-4f81-ac84-f8d6a0e80a81" />

<img width="615" alt="Screen Shot 2025-03-04 at 9 58 27 AM" src="https://github.com/user-attachments/assets/9c3100ca-cd45-450b-97fb-68a0e5b9659d" />

### Query 02: Calculate % YoY growth rate by SubCategory and release top 3 catergories with highest grow rate


### Query 03: Ranking Top 3 TeritoryID with biggest Order quantity of every year. 


### Query 04: Calculate Total Discount Cost belongs to Seasonal Discount for each SubCategory


### Query 05: Retention rate of Customer in 2014 with status of Successfully Shipped (Cohort Analysis) 


### Query 06: Trend of Stock level & MoM diff % by all product in 2011. If % growth rate is null then 0.



### Query 07: Calculate Ratio of Stock / Sales in 2011 by product name, by month

### Query 08: Number of order and value at Pending status in 2014





## IV. Final Conclusion & Recommendations 

