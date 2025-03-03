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

<img width="740" alt="Screen Shot 2025-03-04 at 10 00 37 AM" src="https://github.com/user-attachments/assets/fd855975-bf37-45dc-8a03-36a95b601fba" />

The data shows that Road, Mountain, and Touring Bikes generate the highest revenue and sales volume. Among accessories, Helmets, Jerseys, and Tires have the highest unit sales. While overall sales have remained relatively stable across the quarters, there was a sharp decline in Q2 2014, primarily driven by a significant drop in June 2014.

### Query 02: Calculate % YoY growth rate by SubCategory and release top 3 catergories with highest grow rate

<img width="1003" alt="Screen Shot 2025-03-04 at 11 29 43 AM" src="https://github.com/user-attachments/assets/8bdc9a98-79f9-4235-8a45-587892614418" />

<img width="1003" alt="Screen Shot 2025-03-04 at 11 30 21 AM" src="https://github.com/user-attachments/assets/96bacfc0-505a-4049-abcc-a571621e2c6a" />

<img width="835" alt="Screen Shot 2025-03-04 at 11 31 33 AM" src="https://github.com/user-attachments/assets/654a822d-9d8e-4b26-b550-ef9ddf6ddb54" />


### Query 03: Ranking Top 3 TeritoryID with biggest Order quantity of every year. 

<img width="935" alt="Screen Shot 2025-03-04 at 10 04 42 AM" src="https://github.com/user-attachments/assets/1b44a1fe-6f08-4cc0-9931-dfc8777c99a0" />

<img width="543" alt="Screen Shot 2025-03-04 at 10 05 01 AM" src="https://github.com/user-attachments/assets/c837acc9-2a9d-409b-9a73-1ed0bd231ce9" />


### Query 04: Calculate Total Discount Cost belongs to Seasonal Discount for each SubCategory

<img width="801" alt="Screen Shot 2025-03-04 at 10 06 27 AM" src="https://github.com/user-attachments/assets/61189edb-c386-4f92-87bf-d6412fb99f56" />

<img width="465" alt="Screen Shot 2025-03-04 at 10 06 48 AM" src="https://github.com/user-attachments/assets/50e4bf01-19ee-4239-8621-e789db6f7eae" />


### Query 05: Retention rate of Customer in 2014 with status of Successfully Shipped (Cohort Analysis) 

<img width="843" alt="Screen Shot 2025-03-04 at 10 09 01 AM" src="https://github.com/user-attachments/assets/8e17e921-d497-4b96-9713-b7648763cf80" />

<img width="835" alt="Screen Shot 2025-03-04 at 10 09 44 AM" src="https://github.com/user-attachments/assets/4e62165a-94bf-4a98-b6eb-0ca0e36e133e" />

<img width="278" alt="Screen Shot 2025-03-04 at 10 10 58 AM" src="https://github.com/user-attachments/assets/6b54e00d-91db-4d2e-bd4c-e496e5439de3" />


### Query 06: Trend of Stock level & MoM diff % by all product in 2011. If % growth rate is null then 0.

<img width="826" alt="Screen Shot 2025-03-04 at 10 13 28 AM" src="https://github.com/user-attachments/assets/236d29c3-8ee3-4a05-a905-d590aa604300" />

<img width="668" alt="Screen Shot 2025-03-04 at 10 13 58 AM" src="https://github.com/user-attachments/assets/a311ebd1-2d6f-4122-8c8b-40fb73a51a91" />



### Query 07: Calculate Ratio of Stock / Sales in 2011 by product name, by month

<img width="684" alt="Screen Shot 2025-03-04 at 10 17 05 AM" src="https://github.com/user-attachments/assets/359fed65-4428-4076-b2e6-e3da872beee7" />

<img width="681" alt="Screen Shot 2025-03-04 at 10 17 32 AM" src="https://github.com/user-attachments/assets/8b58ca06-9f26-4a07-9e3c-0264c8710791" />

<img width="825" alt="Screen Shot 2025-03-04 at 10 15 41 AM" src="https://github.com/user-attachments/assets/3cef9e2e-6833-4f9a-84af-8ce39c288b18" />


### Query 08: Number of order and value at Pending status in 2014

<img width="548" alt="Screen Shot 2025-03-04 at 10 18 05 AM" src="https://github.com/user-attachments/assets/4d9d0239-2042-43e5-a039-cb0d474991ac" />


<img width="545" alt="Screen Shot 2025-03-04 at 10 16 13 AM" src="https://github.com/user-attachments/assets/ece49e92-bda6-41f2-80bc-6bc1f46aca62" />




## IV. Final Conclusion & Recommendations 

