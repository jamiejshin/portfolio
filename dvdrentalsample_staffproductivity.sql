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
