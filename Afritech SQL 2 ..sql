
SELECT * 
FROM transactiondata

--Data Cleaning 
-- Replace the year column
UPDATE transactiondata
SET transactionyear = EXTRACT(YEAR FROM transactiondate)
WHERE transactionyear <> EXTRACT(YEAR FROM transactiondate)


SELECT * 
FROM socialmedia

--Replace the post that did not mention competitors
UPDATE socialmedia
SET competitor_x = 'None'
WHERE competitor_x is NULL OR competitor_x = ''

SELECT *
FROM socialmedia
WHERE competitor_x = 'None'

--Exploratory Data Analysis

-- CustomerData
--How many customers are in each region?
SELECT region, COUNT(*)AS Regioncount
FROM Customerdata
GROUP BY region
ORDER BY Regioncount DESC

--How many unique customers do we have?
SELECT COUNT(DISTINCT Customerid) AS Uniquecustomers
FROM customerdata

-- What is the highest, lowest and average age of the customers?
SELECT MAX(Age)AS Highest_age,
Min(age)AS Lowest_age,
ROUND(Avg(age),0)AS Average_age
FROM customerdata

--What is the customer distribution like?
SELECT customertype, COUNT(*)AS type_count
FROM customerdata
GROUP BY customertype
ORDER BY type_count DESC

--What is the income distribution of customers?
SELECT ROUND(MAX(Income),2)AS Highest_income,
ROUND(MIN(INCOME),2)AS Lowest_income,
ROUND(AVG(INCOME),2)AS Average_income 
FROM customerdata


--TransactionData
--What is the product price distribution Like?
SELECT ROUND(MAX(PurchaseAmount),2)AS Highest_Price,
ROUND(MIN(PurchaseAmount),2)AS Lowest_Price,
ROUND(AVG(PurchaseAmount),2)AS Average_Price
FROM transactiondata

--What is the product purchase distribution and purchase amount?
SELECT productPurchased, COUNT(*)AS purchase_Quantity, SUM(PurchaseAmount) AS Total_Sales
From transactiondata
GROUP BY productPurchased
ORDER BY Total_Sales DESC

--What are the product recalled behviour?
SELECT productrecalled, COUNT(*) AS purchaseQuality, SUM(PurchaseAmount) AS Total_sales
FROM transactiondata
GROUP BY productrecalled
ORDER BY Total_Sales DESC

-- SocialMedia
--What are the likes behaviour per platform?
SELECT Platform, SUM(Engagementlikes) AS Total_likes, ROUND(AVG(Engagementlikes),2) AS Average_likes
FROM Socialmedia
Group BY Platform
Order BY Total_likes DESC


--Group Work
--CustomerData
--What are the TOP 5 regions with the highest average income
SELECT Region,
 CONCAT('$', ROUND(AVG(Income), 2)) AS AverageIncome
FROM Customerdata
GROUP BY Region
ORDER BY AVG(Income) DESC
LIMIT 5

--Who are the top spending customers? 
SELECT cd.Customername, SUM(PurchaseAmount) AS TotalSpend, COUNT(*) AS NumTransactions
FROM customerdata as cd 
left join transactiondata as dt
on cd.customerid = dt.customerid
GROUP BY cd.CustomerID
ORDER BY TotalSpend DESC;


--TransactionData
--products with the highest number of recall

select count(productpurchased) as "Number of items", productpurchased
from TransactionData
group by 2,productrecalled
having productrecalled ='true'
order by 1 desc

-- Product Recall by Sentiment
SELECT  platform,
 COUNT(*) FILTER (WHERE sm.Sentiment = 'Negative') AS negative_mentions,
 COUNT(*) FILTER (WHERE sm.Sentiment = 'Positive') AS Positive_mentions,
 COUNT(*) FILTER (WHERE sm.Sentiment = 'Neutral') AS Neutral_mentions,
COUNT(*) FILTER (WHERE t.ProductRecalled = TRUE) AS recalls
FROM  Socialmedia AS sm
JOIN     TransactionData T 
ON SM.Customerid = T.Customerid
GROUP BY  platform
ORDER BY recalls DESC

SELECT * 
FROM TransactionData


--SocialMedia
--Which platform has the highest percentage of negative sentiment posts?
SELECT Platform, ROUND((COUNT(CASE WHEN Sentiment='Negative' THEN 1 END)*100.0/COUNT(*)),2) AS NegSentimentRate
FROM SocialMedia 
GROUP BY Platform 
ORDER BY NegSentimentRate DESC


--Which competitor’s presence most affects purchase behavior?
SELECT Competitor_x, COUNT(*) AS mentions 
FROM SocialMedia 
WHERE Competitor_x IS NOT NULL
GROUP BY Competitor_x 
ORDER BY mentions DESC

--Negative trend over time 
SELECT
  date_trunc('month', interactiondate)::date AS month,
  COUNT(*) FILTER (WHERE LOWER(sentiment) = 'negative') AS negative_posts
FROM socialmedia
GROUP BY month
ORDER BY month;


--Group Work(Second meeting)

-- Answering Business Challenge 1 and 2 (Both Transaction and social media)
SELECT  
  platform, 

  -- Total posts by sentiment
  COUNT(*) FILTER (WHERE sm.Sentiment = 'Negative') AS negative_mentions,
  COUNT(*) FILTER (WHERE t.ProductRecalled = TRUE AND sm.Sentiment = 'Negative') AS recalls_negative,

  COUNT(*) FILTER (WHERE sm.Sentiment = 'Positive') AS positive_mentions,
  COUNT(*) FILTER (WHERE t.ProductRecalled = TRUE AND sm.Sentiment = 'Positive') AS recalls_positive,

  COUNT(*) FILTER (WHERE sm.Sentiment = 'Neutral') AS neutral_mentions,
  COUNT(*) FILTER (WHERE t.ProductRecalled = TRUE AND sm.Sentiment = 'Neutral') AS recalls_neutral,

   -- Total recalls (across all sentiments)
  COUNT(*) FILTER (WHERE t.ProductRecalled = TRUE) AS total_recalls

FROM Socialmedia AS sm
JOIN TransactionData AS t ON sm.Customerid = t.Customerid

GROUP BY platform
ORDER BY total_recalls DESC

--Customerdata

--Number of complaints by cusutomertype
select customertype, count(crisiseventtime) as "Number of complaints"
from socialmedia
left join customerdata
using (customerid)
group by 1
order by 2 desc; 

--TransactionData
--Top revenue generating products?  
SELECT productpurchased, SUM(purchaseamount) AS total_revenue
FROM transactiondata
GROUP BY productpurchased
ORDER BY total_revenue DESC


--What is the spending behaviour & number of complaints per customertype


SELECT customertype, 
 	sum(purchaseamount) as "Total spendings", count(crisiseventtime) as "Number of complaints"
from transactiondata  
left join customerdata  
using(customerid)
left join socialmedia
using(customerid)
group by 1
order by 2 desc;



--Socialmedia

--Which platforms have the highest concentration of negative posts 
SELECT Platform, COUNT(*) AS negative_posts_Cnt
FROM Socialmedia
WHERE Sentiment = 'Negative'
GROUP BY Platform
ORDER BY negative_posts_Cnt DESC

----How many unresolved crises remain per platform?
SELECT Platform, COUNT(*) AS UnresolvedCount 
FROM SocialMedia 
WHERE ResolutionStatus='False' 
GROUP BY Platform 
ORDER BY UnresolvedCount DESC


--Slow first response times
--Comment on the first AVG to see only days.
SELECT 
	platform,
	AVG(firstresponsetime::timestamp - interactiondate::timestamp) AS average_response_time,
	ROUND(AVG(EXTRACT(DAY FROM(firstresponsetime::timestamp - interactiondate::timestamp))),0) || 'Days' AS average_response_time_days
FROM
	socialmedia
WHERE
	firstresponsetime IS NOT NULL
GROUP BY 
	platform
ORDER BY
	average_response_time_days DESC;

	





























