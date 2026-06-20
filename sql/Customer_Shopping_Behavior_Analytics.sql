/*
Q1. What is the customer purchasing behavior, 
transaction volume, and total revenue contribution segmented by gender?
*/
SELECT 
	csb.gender,
	-- Total unique customers segmented by gender (represents current snapshot rows)
	COUNT(*) AS count_of_customers,
	-- Estimated total transactions (current + historical purchases)
	(COUNT(*) + SUM(csb.previous_purchases)) AS total_number_of_purchases,
	-- Average Order Value (AOV) for the latest purchasing
	ROUND(AVG(csb.purchase_amount_USD), 1) AS avg_order_value,
	-- Average number of previous purchases
	AVG(csb.previous_purchases) AS avg_previous_purchases,
	-- Total actual revenue generated from the latest transaction
	SUM(csb.purchase_amount_USD) AS total_last_purchase_revenue
FROM dbo.customer_shopping_behavior AS csb
GROUP BY csb.gender;


/*
Q2. How many customers used a discount but still spent more 
than the average purchase amount?
*/
DECLARE @AvgPurchase DECIMAL(10, 2);
SELECT @AvgPurchase = AVG(purchase_amount_USD) 
FROM dbo.customer_shopping_behavior;
SELECT 
	COUNT(*) AS count
FROM (
	SELECT
		customer_id,
		purchase_amount_USD
	FROM dbo.customer_shopping_behavior AS csb
	WHERE 
		purchase_amount_USD > @AvgPurchase
		AND discount_applied = 'Yes') t;

/*
Q3. Which are the top and bottom 5 products in terms of average review rating?
*/
SELECT TOP(5)
	csb.item_purchased,
	ROUND(AVG(csb.review_rating), 1) AS avg_review_rating
FROM dbo.customer_shopping_behavior AS csb
GROUP BY csb.item_purchased
ORDER BY AVG(csb.review_rating) DESC;
---------
SELECT TOP(5)
	csb.item_purchased,
	ROUND(AVG(csb.review_rating), 1) AS avg_review_rating
FROM dbo.customer_shopping_behavior AS csb
GROUP BY csb.item_purchased
ORDER BY AVG(csb.review_rating) ASC;


/*
Q4. Compare the impact of the two types of shipping: "standard" and "Express".
*/
SELECT 
	csb.shipping_type,
	COUNT(*) count_of_last_purchase,
	ROUND(AVG(csb.purchase_amount_USD),1) AS avg_last_purchase_revenue,
	SUM(csb.purchase_amount_USD) AS total_last_purchase_revenue
FROM dbo.customer_shopping_behavior AS csb
WHERE csb.shipping_type IN ('Standard', 'Express')
GROUP BY csb.shipping_type;


/*
Q5.	Compare between subscribed customers and non-subscribers.
*/
SELECT 
	subscription_status,
	COUNT(*) count,
	SUM(previous_purchases) total_previous_purchases,
	AVG(previous_purchases) avg_previous_purchases,
	ROUND(AVG(purchase_amount_USD),1) avg_last_purchase_amount,
	SUM(purchase_amount_USD) total_last_purchase_amount
FROM dbo.customer_shopping_behavior
GROUP BY subscription_status
ORDER BY COUNT(*) DESC;
/*
-- No, there is no statistically significant behavioral difference. 
	Non-subscribers average 25 prior purchases with a $59.9 AOV, 
	while subscribers average 26 prior purchases with a $59.5 AOV.
-- Critical Business Insight: The loyalty subscription program is currently underperforming 
	and fails to drive incremental transaction value or higher purchase frequency. 
	Management should revamp subscription perks to incentivize higher spending.
*/


/*
Q6. Which 5 products have the highest percentage of purchases with discounts applied?
*/
SELECT TOP 5
	item_purchased,
	COUNT(*) AS total_item_orders,
	SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) discounted_orders,
	ROUND(
        (SUM(CASE WHEN csb.discount_applied = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
        1
    ) AS discount_percentage
FROM dbo.customer_shopping_behavior AS csb
GROUP BY csb.item_purchased
ORDER BY discount_percentage DESC;


/*
Q7. Segment customers into New, Returning, and Loyal
based on their total number of previous purchases, 
and show the count of each segment.
*/
SELECT
	temp.customers_segment,
	COUNT(*) AS count
FROM (
	SELECT 
	(CASE  
		WHEN csb.previous_purchases <= 10 THEN 'New'
		WHEN csb.previous_purchases BETWEEN 11 AND 30 THEN 'Returning' 
		ELSE 'Loyal' END) AS customers_segment
	FROM dbo.customer_shopping_behavior AS csb) temp
GROUP BY temp.customers_segment
ORDER BY count DESC;


--Q8. What are the top 3 most purchased products within each category?
WITH RankedProducts AS(
SELECT 
	csb.category,
	csb.item_purchased,
	SUM(csb.purchase_amount_USD) purchase_amount,
	ROW_NUMBER() OVER
		(PARTITION BY csb.category 
		 ORDER BY SUM(csb.purchase_amount_USD) DESC
		) product_rank
FROM dbo.customer_shopping_behavior csb
GROUP BY csb.category, csb.item_purchased
)
SELECT 
	category,
	item_purchased,
	purchase_amount,
	product_rank
FROM RankedProducts
WHERE product_rank <= 3;


--Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
WITH RepeatBuyers AS (
SELECT 
	*
	FROM dbo.customer_shopping_behavior
	WHERE previous_purchases > 5
	)
SELECT
	ROUND(SUM(CASE WHEN subscription_status = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) 
	AS repeat_buyers_subscription,
	ROUND(SUM(CASE WHEN subscription_status = 'No' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) 
	AS repeat_buyers_non_subscription
FROM RepeatBuyers;


--Q10. What is the revenue contribution of each age group?
WITH AgeGroups AS(
SELECT 
	csb.age_group,
	CASE 
	WHEN csb.age_group = 'Young' THEN '18-30'
	WHEN csb.age_group = 'Adult' THEN '30-45' 
	WHEN csb.age_group = 'Middle-aged' THEN '45-60' 
	WHEN csb.age_group = 'Senior' THEN '>60' 
	END AS age_demographic,
	SUM(csb.purchase_amount_USD) last_purchase_revenue,
	ROUND(
        (SUM(csb.purchase_amount_USD) * 100.0) / SUM(SUM(csb.purchase_amount_USD)) OVER(),1
		) AS revenue_percentage
FROM dbo.customer_shopping_behavior csb
GROUP BY csb.age_group
)
SELECT 
	*
FROM AgeGroups
ORDER BY last_purchase_revenue DESC;



