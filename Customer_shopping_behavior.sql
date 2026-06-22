use Customer_Shopping_Behavior_Database

--View top 20 rows of the table
select top 20 * from Customer;


--Q1. Total revenue generated bu male vs. female customers
select gender, sum(purchase_amount) as Revenue
from Customer
group by gender;

--Q2. Which customers used a discount but still spent more than the average purchase amount?
select customer_id, purchase_amount 
from Customer
where discount_applied = 'Yes' and purchase_amount >= (select avg(purchase_amount) from Customer);


-- Q3. Which are the top 5 products with the highest average review rating?
select top 5 item_purchased, ROUND(AVG(CAST(review_rating AS NUMERIC(10,2))), 2) as "Average Product Rating"
from customer
group by item_purchased
order by avg(review_rating) desc


--Q4. Compare the average Purchase Amounts between Standard and Express Shipping. 
select shipping_type, ROUND(AVG(CAST(purchase_amount AS NUMERIC(10,2))), 2) as "Average Purchase Amount"
from Customer
where shipping_type = 'Standard' or shipping_type = 'Express'
group by shipping_type


--Q5. Do subscribed customers spend more? Compare average spend and total revenue between subscribers and non-subscribers.

Select subscription_status, 
count(customer_id) as 'total Customer',
avg(purchase_amount) as 'Average Spend', 
sum(purchase_amount) as 'Total Revenue'
from Customer
group by subscription_status;



--Q6. Which 5 products have the highest percentage of purchases with discounts applied?
select top 5 item_purchased,
Round(100 * sum(case when discount_applied = 'Yes' then 1 else 0 end) / count(*),2) as percentage_of_purchase
from Customer
group by item_purchased
order by percentage_of_purchase desc


--Q7. Segment customers into New, Returning, and Loyal based on their total number of previous purchases, and show the count of each segment.
with customer_type as (
select customer_id, previous_purchases,
case 
when previous_purchases = 1 then 'new'
when previous_purchases between 2 and 10 then 'returning'
else 'loyal'
end as customer_segment
from Customer
)
Select customer_segment, count(*) as numnber_of_customer
from customer_type
group by customer_segment;

--Q8. What are the top 3 most purchased products within each category? 
WITH item_counts AS (
SELECT category, item_purchased, COUNT(customer_id) AS total_orders,
ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
FROM customer
GROUP BY category, item_purchased
)

SELECT item_rank,category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <=3;
 
--Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
SELECT subscription_status, COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;

--Q10. What is the revenue contribution of each age group? 
SELECT age_group, SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue desc;


