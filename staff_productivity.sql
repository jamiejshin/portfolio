-- This query joins two tables: payment and staff. I got this sample from a dvdrentals test database online. 
-- I wanted to showcase how I would use JOINS and aggregate functions to identify the first and last names of all staff
-- and count the total number of customer payments, as well as the total amount of customer payments processed by each staff.
-- In a hypothetical scenario, I would run this query to identify the most productive staff member in terms of customer payment totals (column 'payment_totals')
-- though depending on the business problem, 'payment_counts' could also be insightful.
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
