USE mavenmovies;

/*
1.extracting the managers’ names at each store,
with the full address of each property 
(street address, district, city, and country).
*/

SELECT 
    staff.first_name AS manager_first_name,
    staff.last_name AS manager_last_name,
    address.address,
    address.district,
    city.city,
    country.country
FROM
    store
        LEFT JOIN
    staff ON store.store_id = staff.staff_id
        LEFT JOIN
    address ON store.address_id = address.address_id
        LEFT JOIN
    city ON address.city_id = city.city_id
        LEFT JOIN
    country ON city.country_id = country.country_id;


/*
2.pulling together a list of each inventory item we have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/

SELECT 
    inventory.store_id,
    inventory.inventory_id,
    film.title,
    film.rating,
    film.rental_rate,
    film.replacement_cost
FROM
    inventory
        LEFT JOIN
    film ON inventory.film_id = film.film_id;

/* 
3.rolling the data up and providing a summary level overview of my inventory. 
Listing how many inventory items we have with each rating at each store. 
*/

SELECT 
    store.store_id,
    COUNT(inventory.inventory_id) AS total_inventory,
    film.rating
FROM
    inventory
        LEFT JOIN
    store ON inventory.store_id = store.store_id
        LEFT JOIN
    film ON inventory.film_id = film.film_id
GROUP BY inventory.store_id, film.rating;

/* 
4.understanding how diversified the inventory is in terms of replacement cost;
thus, extracting the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 

SELECT 
    store.store_id,
    category.name AS category,
    COUNT(inventory.film_id) AS number_of_films,
    AVG(film.replacement_cost) AS average_replacement_cost,
    SUM(replacement_cost) AS total_replacement_cost
FROM
    inventory
        LEFT JOIN
    store ON inventory.store_id = store.store_id
        LEFT JOIN
    film ON inventory.film_id = film.film_id
        LEFT JOIN
    film_category ON film.film_id = film_category.film_id
        LEFT JOIN
    category ON film_category.category_id = category.category_id
GROUP BY store.store_id, category.name;

/*
5.providing a list of all customer names,
which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/

SELECT 
    customer.first_name AS first_name,
    customer.last_name AS last_name,
    customer.store_id AS store,
    customer.active AS currently_active_or_Not,
    address.address,
    city.city,
    country.country
    FROM customer LEFT JOIN store ON customer.store_id = store.store_id
    LEFT JOIN address ON customer.address_id = address.address_id
    LEFT JOIN city ON address.city_id = city.city_id
    LEFT JOIN country ON city.country_id = country.country_id;

/*
6.pulling together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them.
ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/
SELECT 
    customer.first_name,
    customer.last_name,
    COUNT(rental.rental_id) AS total_lifetime_rentals,
    SUM(payment.amount) AS total_payments
FROM
    customer
        LEFT JOIN
    rental ON customer.customer_id = rental.customer_id
        LEFT JOIN
    payment ON rental.rental_id = payment.rental_id
    GROUP BY customer.customer_id
    ORDER BY total_payments DESC;
    
/*
7.providing a list of advisor and investor names in one table
Noting whether they are an investor or an advisor, and for the investors,
including which company they work with. 
*/

 SELECT 
    'investor' AS investor_or_advisor, first_name, last_name, company_name
FROM
    investor
    UNION SELECT 
    'advisor' AS investor_or_advisor , first_name, last_name, NULL
FROM
    advisor;

/*
8.of all the actors with three types of awards, for what % of most-awarded actor do we carry a film?
and about for actors with two types of awards? for what % of most-awarded actor do we carry a film? 
finally, how about actors with just one award? for what % of most-awarded actor do we carry a film? 
*/

SELECT 
    CASE
        WHEN actor_award.awards = 'Emmy, Oscar,Tony' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy,Oscar' , 'Emmy, Tony', 'Oscar,Tony') THEN '2 awards'
        ELSE '1 award'
    END AS number_awards,
    AVG(CASE
        WHEN actor_award.actor_id IS NULL THEN 0
        ELSE 1
    END) AS percentage
FROM
    actor_award
GROUP BY CASE
    WHEN actor_award.awards = 'Emmy, Oscar,Tony' THEN '3 awards'
    WHEN actor_award.awards IN ('Emmy,Oscar' , 'Emmy, Tony', 'Oscar,Tony') THEN '2 awards'
    ELSE '1 award'
END;