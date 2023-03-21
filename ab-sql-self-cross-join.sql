USE sakila;

# 1. Get all pairs of actors that worked together. self join

# Option 1
SELECT
-- show the actor id, first and last names
	A.actor_id, A.first_name, A.last_name,
    B.actor_id, B.first_name, B.last_name
-- join the tables actor and film actor and create pathway for A
FROM actor A
INNER JOIN film_actor FA ON FA.actor_id = A.actor_id
-- self join and create pathway for B
INNER JOIN film_actor FB ON FA.film_id = FB.film_id AND FB.actor_id <> FA.actor_id
INNER JOIN actor B ON FB.actor_id = B.actor_id
-- group by actor id so we don't get duplicates
GROUP BY A.actor_id, B.actor_id;

# Option 2
SELECT 
-- show distinct actor id for A and B
	DISTINCT(A.actor_id),
    B.actor_id
FROM film_actor AS A, film_actor AS B
-- actor id for A should not be the same as actor id for B, but film id should be the same 
WHERE A.actor_id != B.actor_id 
	AND A.film_id = B.film_id
ORDER BY A.actor_id, B.actor_id;


# 2. Get all pairs of **customers** that have rented the same **film** more than 3 times. self join with count

SELECT
	A.customer_id, A.first_name, A.last_name, COUNT(DISTINCT RA.rental_id) AS no_rentals_A,
    B.customer_id, B.first_name, B.last_name, COUNT(DISTINCT RB.rental_id) AS no_rentals_B
-- Make our way from the customer to the available films. We are creating a pathway for A
FROM customer A
INNER JOIN rental RA ON A.customer_id = RA.customer_id
INNER JOIN inventory IA ON IA.inventory_id = RA.inventory_id
-- Make our way back by self-joining the inventory for the same film. Now we are creating a pathway for B
INNER JOIN inventory IB ON IA.film_id = IB.film_id
INNER JOIN rental RB ON IB.inventory_id = RB.inventory_id
INNER JOIN customer B ON B.customer_id = RB.customer_id
-- Make sure that we have to individual customers, the result
-- could otherwise include two inventory entries from different
-- stores but of the same customer and film.
WHERE A.customer_id <> B.customer_id
-- Make sure that we have each customer only once
GROUP BY A.customer_id, B.customer_id
-- Make sure that there are more than 3 rentals by customer A
HAVING COUNT(DISTINCT RA.rental_id) > 3
-- Make sure that there are more than 3 rentals by customer B
	AND COUNT(DISTINCT RB.rental_id) > 3;


# 3. Get all possible pairs of actors and films. cross join
SELECT 
-- we want to see the actor id, first name, last name, film id and title
	A.actor_id, A.first_name, A.last_name, 
	F.film_id, F.title
-- cross join table actor and film
FROM actor A, film F;
