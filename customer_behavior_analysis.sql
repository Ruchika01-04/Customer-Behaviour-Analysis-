SELECT * FROM customer

SELECT gender, 
SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY gender

SELECT customer_id, purchase_amount
FROM customer
WHERE discount_applied = 'Yes' and purchase_amount>=(SELECT AVG(purchase_amount) from customer)

SELECT item_purchased, round(AVG(review_rating::numeric),2) AS "Average product Rating"
FROM customer
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5

SELECT shipping_type,
ROUND(AVG(purchase_amount),2)
FROM customer
WHERE shipping_type in ('Express','Standard')
GROUP BY shipping_type


SELECT subscription_status,
COUNT(customer_id) AS total_customers,
ROUND(SUM(purchase_amount),2) as total_revenue,
ROUND(AVG(purchase_amount),2) AS avg_spend
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue, avg_spend DESC

SELECT item_purchased,
ROUND(100* SUM(CASE WHEN discount_applied='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
limit 5

with customer_type as(
SELECT customer_id, previous_purchases,
CASE
	WHEN previous_purchases = 1 THEN 'new'
	WHEN previous_purchases BETWEEN 2 AND 10 THEN 'returning'
	ELSE 'loyal'
	END AS customer_segment
FROM customer)

SELECT customer_segment, count(*) as "number_of_customer"
from customer_type
GROUP BY customer_segment


WITH item_count AS 
(
SELECT category,
	item_purchased,
	COUNT (customer_id) AS total_orders,
	ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT (customer_id ) DESC) as item_rank
FROM customer
GROUP BY category, item_purchased
)
 SELECT item_rank,category, item_purchased ,total_orders
 FROM item_count
 WHERE item_rank <=3

SELECT subscription_status,
	COUNT (customer_id)AS repeat_buyers
FROM customer
WHERE previous_purchases>5
GROUP BY subscription_status


SELECT 
	age_group,
	SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC



