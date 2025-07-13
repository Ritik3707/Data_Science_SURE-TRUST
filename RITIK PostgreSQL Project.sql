-- 1. List the first name and last name of all customers

SELECT first_name, last_name FROM customer;

-- 2. Find all the movies that are currently rented out.

SELECT film.title
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE rental.return_date IS NULL;

--3. Show the titles of all movies in the 'Action' category.

SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';

-- 4. Count the number of films in each category.

SELECT c.name AS category, COUNT(*) AS film_count
FROM film_category fc
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

-- 5. What is the total amount spent by each customer

SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id;

-- 6. Find the top 5 customers who spent the most.

SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

 --7. Display the rental date and return date for each rental.
 
SELECT rental_date, return_date FROM rental;

-- 8. List the names of staff members and the stores they manage.

SELECT s.first_name, s.last_name, s.store_id
FROM staff s;

-- 9. Find all customers living in 'California'.

SELECT c.first_name, c.last_name
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE a.district = 'California';

-- 10. Count how many customers are from each city.

SELECT ci.city, COUNT(*) AS customer_count
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
GROUP BY ci.city;

-- 11. Find the film(s) with the longest duration.

SELECT title, length
FROM film
WHERE length = (SELECT MAX(length) FROM film);

-- 12. Which actors appear in the film titled 'Alien Center'?

SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Alien Center';

-- 13. Find the number of rentals made each month.

SELECT DATE_TRUNC('month', rental_date) AS month, COUNT(*) AS rental_count
FROM rental
GROUP BY month
ORDER BY month;

-- 14. Show all payments made by customer 'Mary Smith'.

SELECT p.*
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
WHERE c.first_name = 'Mary' AND c.last_name = 'Smith';

-- 15. List all films that have never been rented.

SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

-- 16. What is the average rental duration per category?

SELECT c.name, AVG(f.rental_duration) AS avg_duration
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

--17. Which films were rented more than 50 times?

SELECT f.title, COUNT(*) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
HAVING COUNT(*) > 50;

--18. List all employees hired after the year 2005.

SELECT * FROM staff;
SELECT *
FROM staff
WHERE last_update> '2005-12-31';

-- 19. Show the number of rentals processed by each staff member.

SELECT staff_id, COUNT(*) AS rentals_processed
FROM rental
GROUP BY staff_id;

-- 20. Display all customers who have not made any payments.

SELECT c.first_name, c.last_name
FROM customer c
LEFT JOIN payment p ON c.customer_id = p.customer_id
WHERE p.payment_id IS NULL;

-- 21. What is the most popular film (rented the most)

SELECT f.title, COUNT(*) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 1;

--22. Show all films longer than 2 hours.(120 Min)

SELECT title, length
FROM film
WHERE length > 120;

-- 23. Find all rentals that were returned late.

SELECT *
FROM rental
WHERE return_date > rental_date + INTERVAL '3 days';

-- 24. List customers and the number of films they rented.

SELECT c.first_name, c.last_name, COUNT(r.rental_id) AS total_rentals
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

-- 25. Write a query to show top 3 rented film categories.

SELECT c.name AS category, COUNT(*) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY rental_count DESC
LIMIT 3;

--26. Create a view that shows all customer names and their payment totals.

CREATE VIEW customer_payments AS
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_payment
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name;

-- 27. Update a customer's email address given their ID.

UPDATE customer
SET email = 'new_email@example.com'
WHERE customer_id = 1; -- change to actual ID

--28. Insert a new actor into the actor table.

INSERT INTO actor (first_name, last_name, last_update)
VALUES ('John', 'Doe', CURRENT_TIMESTAMP);

-- 29. Delete all records from the rentals table where return_date is NULL.

BEGIN;

DELETE FROM rental
WHERE return_date IS NULL;

-- 30. Add a new column 'age' to the customer table.

ALTER TABLE customer
ADD COLUMN age INTEGER;

-- 31. Create an index on the 'title' column of the film table.
CREATE INDEX idx_film_title ON film(title);

-- 32. Find the total revenue generated by each store.

SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

-- 33. What is the city with the highest number of rentals?

SELECT ci.city, COUNT(*) AS rental_count
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
GROUP BY ci.city
ORDER BY rental_count DESC
LIMIT 1;

-- 34. How many films belong to more than one category?

SELECT COUNT(*) AS multi_category_films
FROM (
    SELECT film_id
    FROM film_category
    GROUP BY film_id
    HAVING COUNT(*) > 1
) AS sub;

-- 35. List the top 10 actors by number of films they appeared in.

SELECT a.first_name, a.last_name, COUNT(*) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY film_count DESC
LIMIT 10;

-- 36. Retrieve the email addresses of customers who rented 'Matrix Revolutions'.

SELECT DISTINCT c.email
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'Matrix Revolutions';

--  37. Create a stored function to return customer payment total given their ID.

CREATE OR REPLACE FUNCTION get_customer_total_payment(cid INT)
RETURNS NUMERIC AS $$
DECLARE
    total NUMERIC;
BEGIN
    SELECT SUM(amount) INTO total
    FROM payment
    WHERE customer_id = cid;
    RETURN total;
END;
$$ LANGUAGE plpgsql;

BEGIN;

UPDATE inventory
SET last_update = CURRENT_TIMESTAMP
WHERE inventory_id = 1; -- example

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
VALUES (CURRENT_TIMESTAMP, 1, 1, NULL, 1, CURRENT_TIMESTAMP);

COMMIT;

-- 38. Begin a transaction that updates stock and inserts a rental record
BEGIN;

UPDATE inventory
SET last_update = CURRENT_TIMESTAMP
WHERE inventory_id = 1;

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
VALUES (CURRENT_TIMESTAMP, 1, 1, NULL, 1, CURRENT_TIMESTAMP);

COMMIT;

-- 39. Show the customers who rented films in both 'Action' and 'Comedy' categories.

SELECT DISTINCT c.first_name, c.last_name
FROM customer c
WHERE c.customer_id IN (
    SELECT customer_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    WHERE fc.category_id = (SELECT category_id FROM category WHERE name = 'Action')
)
AND c.customer_id IN (
    SELECT customer_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    WHERE fc.category_id = (SELECT category_id FROM category WHERE name = 'Comedy')
);

--40. Find actors who have never acted in a film.

SELECT a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

  




