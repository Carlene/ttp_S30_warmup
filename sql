-- You're wandering through the wilderness of someone else's code, and you stumble across
-- the following queries that use subqueries. You think they'd be better as CTE's
-- Go ahead and re-write the queries to use CTE's

-- -- EXAMPLE CTE:
--Returns the customer ID’s of ALL customers who have spent more money than $100 in their life.

WITH customer_totals AS (
  SELECT customer_id, 
         SUM(amount) as total
  FROM payment
  GROUP BY customer_id
)

SELECT customer_id, total 
FROM customer_totals 
WHERE total > 100;


--YOUR TURN:
-- Returns the average of the amount of stock each store has in their inventory. 
SELECT AVG(stock)
FROM (SELECT COUNT(inventory_id) as stock
      FROM inventory
      GROUP BY store_id) as store_stock;
      
-- CTE

WITH avg_stock AS (
    SELECT 
        COUNT(inventory_id) as stock
    FROM 
        inventory
    GROUP BY 
        store_id  )

SELECT 
    AVG(stock)

FROM
    avg_stock;


-- Returns the average customer lifetime spending, for each staff member.
-- HINT: you can work off the example
SELECT staff_id, AVG(total)
FROM (SELECT staff_id, SUM(amount) as total
      FROM payment 
      GROUP BY customer_id, staff_id) as customer_totals
GROUP BY staff_id;


-- CTE
WITH customer_totals AS(
    SELECT 
        staff_id
        ,SUM(amount) as total

    FROM 
        payment 

    GROUP BY 
        customer_id
        ,staff_id       )

SELECT
    staff_id
    ,AVG(total)

FROM
    customer_totals

GROUP BY
    staff_id;


-- Returns the average rental rate for each genre of film.
SELECT 
    AVG(rental_rate), 
    category_id
FROM 
    film 
JOIN 
    film_category 

ON film.film_id=film_category.film_id
GROUP BY 
    category_id;



-- CTE
WITH rate_per_category AS (
SELECT
    *

FROM
    film
JOIN
    film_category as film_cat
ON
    film.film_id = film_cat.film_id)


SELECT 
    category_id
    ,AVG(rental_rate)

FROM
    rate_per_category

GROUP BY
    category_id



-- Return all films that have the rating that is biggest category 
-- (ie. rating with the highest count of films)
SELECT title, rating
FROM film
WHERE rating = (SELECT rating 
                FROM film
               GROUP BY rating
               ORDER BY COUNT(*)
               LIMIT 1);

-- CTE

WITH pg13_amount AS (
        SELECT
            rating

        FROM
            film

        GROUP BY
            rating

        ORDER BY
            COUNT(rating) DESC

        LIMIT 1      )

SELECT
    title
    ,rating

FROM 
    film

WHERE
    rating = (SELECT * FROM pg13_amount)


-- Return all purchases from the longest standing customer
-- (ie customer who has the earliest payment_date)
SELECT * 
FROM payment
WHERE customer_id = (SELECT customer_id
                      FROM payment
                      ORDER BY payment_date
                     LIMIT 1);

-- CTE

WITH earliest_date AS  (
            SELECT
                payment_date
                ,customer_id
                ,payment_id

            FROM
                payment

            GROUP BY
                payment_date
                ,customer_id
                ,payment_id

            ORDER BY
                MIN(payment_date)

            LIMIT 1)

SELECT
    customer_id
    ,payment_id

FROM
    earliest_date