USE sakila;
-- 1a --
SELECT first_name AS "First Name", last_name AS "Last Name"
FROM actor;
-- 1b --
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS "Actor Name"
FROM actor;

-- 2a --
SELECT actor_id AS "ID Number", first_name AS "First Name", last_name AS "Last Name"
FROM actor
WHERE first_name = "JOE";
-- 2b --
SELECT first_name AS "First Name", last_name AS "Last Name"
FROM actor
WHERE last_name LIKE '%GEN%';
-- 2c --
SELECT last_name AS "Last Name", first_name AS "First Name"
FROM actor
WHERE last_name LIKE '%LI%';
-- 2d --
SELECT country_id AS "Country ID", country AS "Country"
FROM country
WHERE country IN ("AFGHANISTAN", "BANGLADESH", "CHINA");

-- 3a --
ALTER TABLE actor
ADD COLUMN description BLOB;
-- 3b --
ALTER TABLE actor
DROP description;

-- 4a --
SELECT last_name AS "Last Name", 
COUNT(last_name) AS "Number of People with the Last Name"
FROM actor
GROUP BY last_name;
-- 4b --
SELECT last_name AS "Last Name", 
COUNT(last_name) AS "Number of People with the Last Name" 
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;
-- 4c --
SET SQL_SAFE_UPDATES = 0;
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";
-- 4d --
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";

SET SQL_SAFE_UPDATES = 1;

-- 5a --
SHOW CREATE TABLE address;

-- 6a --
SELECT s.first_name AS "First Name", s.last_name AS "Last Name", 
a.address AS "Address"
FROM staff s   
JOIN address a 
USING (address_id);
-- 6b --
SELECT s.first_name AS "First Name", s.last_name AS "Last Name", 
SUM(p.amount) AS "Total Amount"
FROM staff s   
JOIN payment p
USING (staff_id)
GROUP BY s.first_name, s.last_name;
-- 6c --
SELECT film.title AS "Film Title", 
COUNT(film_actor.actor_id) AS "Number of Actors"
FROM film_actor
INNER JOIN film ON
film.film_id=film_actor.film_id
GROUP BY film.title; 
-- 6d --
SELECT COUNT(*) AS "Number of Copies in Inventory"
    FROM inventory
    WHERE film_id IN
    (
     SELECT film_id
     FROM film
     WHERE title = 'Hunchback Impossible'
 );
-- 6e --
SELECT c.first_name AS "First Name", c.last_name AS "Last Name",  
SUM(p.amount) AS "Total Amount Paid"
FROM customer c   
JOIN payment p
USING (customer_id)
GROUP BY c.first_name, c.last_name
ORDER BY c.last_name ASC;

-- 7a --
SELECT title AS "English Movie Titles"
	FROM film
    WHERE language_id
    IN (
      SELECT language_id
        FROM language
        WHERE name = "English"
)
            AND title LIKE 'K%' OR title LIKE 'Q%';
-- 7b --
SELECT first_name AS "First Name", last_name AS "Last Name"
FROM actor
WHERE actor_id IN
(
  SELECT actor_id
  FROM film_actor
  WHERE film_id IN
  (
   SELECT film_id
   FROM film
   WHERE title = 'Alone Trip'
  )
);
-- 7c --
SELECT cu.first_name AS "First Name", 
cu.last_name AS "Last Name", cu.email AS "Email Address"
FROM customer cu
JOIN address a
USING (address_id)
JOIN city c
USING (city_id)
JOIN country co 
USING (country_id)
WHERE country = "Canada";     
-- 7d --
SELECT title AS "Family Films"
	FROM film
    WHERE film_id
    IN (
      SELECT film_id
        FROM film_category
        WHERE category_id
        IN(
        SELECT category_id
        FROM category
        WHERE name = "Family"
        )
);
-- 7e --
SELECT f.title AS "Movie Title", COUNT(rental_id) AS "Number of Times Rented"
FROM film f  
JOIN inventory i
USING (film_id)
JOIN rental r
USING (inventory_id)
GROUP BY f.title
ORDER BY COUNT(rental_id) DESC;
-- 7f --
SELECT s.store_id AS "Store ID", SUM(p.amount) AS "Total in Dollars" 
FROM store s  
JOIN customer c
USING (store_id)
JOIN payment p
USING (customer_id)
GROUP BY s.store_id;
-- 7g --
SELECT s.store_id AS "Store ID", c.city AS "City", 
co.country AS "Country" 
FROM store s  
JOIN address a
USING (address_id)
JOIN city c
USING (city_id)
JOIN country co
USING (country_id)
GROUP BY s.store_id;
-- 7h --
SELECT c.name AS "Genre", SUM(amount) AS "Gross Revenue"
FROM payment p
JOIN rental r
USING (rental_id)
JOIN inventory i
USING (inventory_id)
JOIN film_category f
USING (film_id)
JOIN category c
USING (category_id)
GROUP BY c.name
ORDER BY SUM(amount) DESC
LIMIT 5;

-- 8a --
CREATE VIEW top_five_genres AS
SELECT c.name AS "Genre", SUM(amount) AS "Gross Revenue"
FROM payment p
JOIN rental r
USING (rental_id)
JOIN inventory i
USING (inventory_id)
JOIN film_category f
USING (film_id)
JOIN category c
USING (category_id)
GROUP BY c.name
ORDER BY SUM(amount) DESC
LIMIT 5;
-- 8b --
SELECT * FROM top_five_genres;
-- 8c --
DROP VIEW IF EXISTS top_five_genres;


