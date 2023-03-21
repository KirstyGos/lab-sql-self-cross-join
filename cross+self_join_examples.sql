# For one staff member, find all other staff members which have the same manager (self-join)

SELECT A.staff_id, B.staff_id
FROM staff AS A
INNER JOIN staff AS B ON A.staff_id <> B.staff_id
INNER JOIN store AS SA ON A.store_id = SA.store_id
INNER JOIN store AS SB ON B.store_id = SB.store_id
WHERE SA.manager_staff_id = SB.manager_staff_id
GROUP BY A.staff_id, B.staff_id;


# Find all possible combinations of customers and films (cross-join)
SELECT 
	C.customer_id, C.first_name, C.last_name,
    F.film_id, F.title
FROM customer AS C, film as F;

# Find 2 customers who rented movies out of the same category

SELECT 
	A.customer_id, A.first_name, A.last_name, 
    B.customer_id, B.first_name, B.last_name
FROM customer AS A
INNER JOIN rental AS RA ON RA.customer_id = A.customer_id
INNER JOIN inventory AS IA ON IA.inventory_id = RA.inventory_id
INNER JOIN film AS FA ON FA.film_id = IA.film_id
INNER JOIN film_category AS FCA ON FCA.film_id = FA.film_id

INNER JOIN customer AS B ON B.customer_id <> A.customer_id
INNER JOIN rental AS RB ON RB.customer_id = B.customer_id
INNER JOIN inventory AS IB ON IB.inventory_id = RB.inventory_id
INNER JOIN film AS FB ON FB.film_id = IB.film_id
INNER JOIN film_category AS FCB ON FCB.film_id = FB.film_id

WHERE FCA.category_id = FCB.category_id
GROUP BY A.customer_id,B.customer_id;