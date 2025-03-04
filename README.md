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

From 2011 to 2014, the accessories category saw the highest year-over-year volume growth, led by Mountain Frames (2012), Socks (2013), and Road Frames (2012), which surged by 521%, 421%, and 389%, respectively. This significant growth can probably stem from expansion into new markets, product improvements, or a shift in consumer preferences. Understanding the key factors behind this trend is essential for sustaining growth and replicating success across other product lines.


### Query 03: Ranking Top 3 TeritoryID with biggest Order quantity of every year. 

<img width="935" alt="Screen Shot 2025-03-04 at 10 04 42 AM" src="https://github.com/user-attachments/assets/1b44a1fe-6f08-4cc0-9931-dfc8777c99a0" />

<img width="543" alt="Screen Shot 2025-03-04 at 10 05 01 AM" src="https://github.com/user-attachments/assets/c837acc9-2a9d-409b-9a73-1ed0bd231ce9" />

Regarding geographic performance, the top three territories with the highest sales orders from 2011 to 2014 were TerritoryIDs 4, 6, and 1, maintaining their leading positions throughout the period. While overall order volume experienced significant growth, 2014 saw a sharp decrease. 
It is essential to examine the causes of this downturn and implement appropriate solutions. Additionally, the company should consider replicating the successful strategies of these territories in other regions.


### Query 04: Calculate Total Discount Cost belongs to Seasonal Discount for each SubCategory

<img width="846" alt="Screen Shot 2025-03-04 at 1 29 31 PM" src="https://github.com/user-attachments/assets/ddefab41-302c-4add-ab28-f610caaa815c" />

<img width="692" alt="Screen Shot 2025-03-04 at 1 30 27 PM" src="https://github.com/user-attachments/assets/1c7a64ad-c0ae-4ac7-9186-e213ead3e0c0" />

The company ran the Seasonal Discounts campaign exclusively for the Helmets subcategory in 2012 and 2013. In 2013, this promotion resulted in a 29% increase in helmet sales compared to 2012. However, the total discount nearly doubled, increasing from $827.65 in 2012 to $1,606.04 in 2013.


### Query 05: Retention rate of Customer in 2014 with status of Successfully Shipped (Cohort Analysis) 

<img width="816" alt="Screen Shot 2025-03-04 at 2 09 46 PM" src="https://github.com/user-attachments/assets/eaaa41cf-abd9-4561-8b09-a2b1e907f976" />

<img width="931" alt="Screen Shot 2025-03-04 at 2 10 27 PM" src="https://github.com/user-attachments/assets/1322bf5f-244f-4085-a7ec-9a57d2b2066d" />

<img width="886" alt="Screen Shot 2025-03-04 at 2 10 46 PM" src="https://github.com/user-attachments/assets/43c2107b-cd7a-4e64-9277-a8c90c3d6a28" />

<img width="467" alt="Screen Shot 2025-03-04 at 2 13 51 PM" src="https://github.com/user-attachments/assets/02e83b93-2d15-4edd-8b74-efc01a3536f1" />

- The number of new customers fluctuated slightly in the first 5 months, then significantly declined in the following two months. 
- Retention rates drop quickly across all cohorts, with only 2.83% of February's customers remaining after 1 month, and just 0.44% by month 5. This suggests most users don't find long-term value or engagement with the service.


### Query 06: Trend of Stock level & MoM diff % by all product in 2011. If % growth rate is null then 0.

<img width="826" alt="Screen Shot 2025-03-04 at 10 13 28 AM" src="https://github.com/user-attachments/assets/236d29c3-8ee3-4a05-a905-d590aa604300" />

<img width="668" alt="Screen Shot 2025-03-04 at 10 13 58 AM" src="https://github.com/user-attachments/assets/a311ebd1-2d6f-4122-8c8b-40fb73a51a91" />

In the last six months of 2011, product stock levels experienced frequent and significant fluctuations. Notably, inventory surged in October and July before sharply declining in the following months, indicating potential challenges in supply chain and inventory management efficiency. December stock declines across all products may be linked to year-end sales or reduced restocking due to seasonal trends.


### Query 07: Calculate Ratio of Stock / Sales in 2011 by product name, by month

<img width="684" alt="Screen Shot 2025-03-04 at 10 17 05 AM" src="https://github.com/user-attachments/assets/359fed65-4428-4076-b2e6-e3da872beee7" />

<img width="681" alt="Screen Shot 2025-03-04 at 10 17 32 AM" src="https://github.com/user-attachments/assets/8b58ca06-9f26-4a07-9e3c-0264c8710791" />

<img width="825" alt="Screen Shot 2025-03-04 at 10 15 41 AM" src="https://github.com/user-attachments/assets/3cef9e2e-6833-4f9a-84af-8ce39c288b18" />

The stock-to-sales ratio highlights inefficiencies in the company's inventory management. Low-selling products have excessively high ratios, driving up inventory costs, while high-selling products have low or zero ratios, increasing the risk of stockouts and lost sales. To enhance capital efficiency, the company should refine its inventory strategy, focusing on balancing stock levels.


### Query 08: Number of order and value at Pending status in 2014

<img width="548" alt="Screen Shot 2025-03-04 at 10 18 05 AM" src="https://github.com/user-attachments/assets/4d9d0239-2042-43e5-a039-cb0d474991ac" />


<img width="545" alt="Screen Shot 2025-03-04 at 10 16 13 AM" src="https://github.com/user-attachments/assets/ece49e92-bda6-41f2-80bc-6bc1f46aca62" />

In 2014, there were 224 pending orders totaling $3,873,579, with an average order value of $17,292.76. This  indicates that pending orders may involve bulk purchases or high-value transactions. Given the significant impact on revenue and customer satisfaction, it is essential to further investigate the factors causing delays.


## IV. Final Conclusion & Recommendations 

This analysis provides valuable insights into sales performance across products and regions, inventory management, and customer retention. It enables the bicycle manufacturer to identify strengths and weaknesses, allowing them to leverage their strengths and minimize weaknesses to enhance overall business performance.

**Recommendations:**

- Analyze the strategies that led to success in Territories 4, 6, and 1, and replicate them in underperforming regions to boost overall sales.
- Reevaluate the effectiveness of promotional campaigns, such as the Seasonal Discounts for Helmets, to ensure they drive sales without causing a disproportionate increase in discount costs.
- Prioritize customer retention by enhancing the customer experience and providing additional value after the initial purchase to reduce churn.
- Focus on improving demand forecasting and optimizing just-in-time inventory cycles to reduce stock imbalances, lower holding costs, and avoid stockouts of high-demand items.
- Conduct a thorough analysis to identify the causes of the sharp sales decline in Q2 2014 and address pending orders to implement prompt and effective solutions.






