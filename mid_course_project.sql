USE mavenmovies;

/*Generating a list of all staff members, including their first and last names,
email addresses, and the store identification number where they work*/

SELECT 
    first_name, last_name, email AS email_address, store_id
FROM
    staff;

# Generating separate counts of inventory items held at each of your two stores

SELECT DISTINCT
    store_id AS Stores, COUNT(DISTINCT inventory_id) AS Inventory_counts
FROM
    inventory
GROUP BY store_id;

#count of active customers for each of your stores, separately.

SELECT 
    store_id, COUNT(DISTINCT customer_id) AS total_active_customers
FROM
    customer
WHERE
    active = 1
GROUP BY store_id;

/*providing a count of all customer email addresses stored in the database,
in order to assess the liability of a data breach.*/

SELECT
    COUNT(DISTINCT email) AS TOTAL_EMAIL_ADDRESSES
FROM
    customer;
    
/* providing a count of unique film titles we have in inventory at each store
and then providing a count of the unique categories of films we provide. */

#count of unique film titles

SELECT DISTINCT store_id, COUNT(DISTINCT f.title) AS total_unique_titles
FROM
    film f
        INNER JOIN
    inventory i ON f.film_id = i.film_id
GROUP BY i.store_id;

#providing a count of the unique categories of films we provide
SELECT 
    COUNT(DISTINCT category_id) AS total_unique_film_categories
FROM
    film_category;
    
/*providing the replacement cost for the film that is least expensive to replace,
the most expensive to replace, and the average of all films we carry.*/
SELECT 
    MIN(replacement_cost) AS least_expensive,
    MAX(replacement_cost) AS most_expensive,
    AVG(replacement_cost) AS average_cost
FROM
    film;
    
#providing the average payment we process, as well as the maximum payment we have processed.
SELECT 
    AVG(amount) AS average_payment,
    MAX(amount) AS maximum_payment
FROM
    payment;
    
/* providing a list of all customer identification values,
with a count of rentals they have made all-time, 
with your highest volume customers at the top of the list. */

SELECT 
    c.customer_id, COUNT(r.rental_id) AS total_rental_count
FROM
    customer c
        INNER JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY customer_id
ORDER BY total_rental_count DESC;