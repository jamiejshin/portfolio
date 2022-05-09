-- The examples below were created using pgAdmin and a sample dvdrentals database that was retrieved online.

-- The below query joins two tables: payment and staff.
-- I wanted to showcase how I would use JOINS and aggregate functions to identify the first and last names of all staff
-- and count the total number of customer payments, as well as the total amount of customer payments processed by each staff.
-- In a hypothetical scenario, I would run this query to identify the most productive staff member in terms of customer payment totals (column payment_totals)
-- though depending on the business problem, payment_counts could also be insightful.
-- If there were more than two staff, I could also add 'LIMIT 3;' to the end of the code to identify the top three most productive employees.

SELECT 
	first_name, 
	last_name, 
	p.staff_id, 
	COUNT(payment_id) as payment_counts,
	SUM(amount) as payment_totals
FROM payment p
LEFT OUTER JOIN staff s
	ON p.staff_id = s.staff_id
GROUP BY p.staff_id, first_name, last_name
ORDER BY payment_totals desc;

-- The below is an example of what I might use to respond to a business problem, like: "In which U.S. cities should we direct our marketing efforts?"
-- One way to answer this problem may be to look at the geographic locations of customers where the total payment sum (or sum of sales) per U.S. city is > $100
-- Note: 'city' corresponds to the geographic locations of customers, presumably by billing address, and not store location. The dataset showed that there were only
-- two unique store IDs, and based on the spread of cities across the US and the world, one could assume that the two dvd rental stores likely operate online, 
-- which is why in this marketing efforts example, we are looking at customers' city address information and not store location.
-- In terms of the code, I used a common table expression (CTE) because I wanted to query a complex table using at least four JOINS. CTEs make it possible 
-- to more simply execute complex code. 
-- In order to show which customers' cities had the highest number of sales transactions (payment_count), I grouped the data set by city_id,
-- filtered the cities that had a payment_sum amount > $100, and ordered by payment_count (unique sales transactions) in descending order.

WITH city_payments_cte AS (
	SELECT 
		a.city_id, 
		SUM(amount) as payment_sum,
		COUNT(p.payment_id) as payment_count
	FROM payment p
	JOIN customer c
		ON p.customer_id = c.customer_id
	JOIN address a
		ON c.address_id = a.address_id
	GROUP BY a.city_id
	HAVING SUM(amount) > 100
	ORDER BY payment_count desc)
SELECT 
	cte.*, 
	c.city, 
	co.country
FROM city_payments_cte cte
JOIN city c
	ON cte.city_id = c.city_id
JOIN country co
	ON c.country_id = co.country_id
WHERE co.country = 'United States'
;
