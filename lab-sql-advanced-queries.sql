use sakila;

-- List each pair of actors that have worked together.
select a1.film_id, a1.actor_id, a2.actor_id from film_actor a1
join film_actor a2
on a1.film_id = a2.film_id
and a1.actor_id > a2.actor_id;


-- For each film, list actor that has acted in more films.

with cte as (
	select actor_id, count(film_id) as total_movies
	from film_actor
    group by actor_id
    order by actor_id
),
cte2 as (
	select film_id, actor_id, total_movies,
	row_number() over (partition by film_id order by total_movies desc) as flag 
	from cte
	join film_actor using(actor_id)
	order by film_id asc, total_movies desc
    )
select film_id, actor_id, total_movies from cte2
where flag = 1;

-- 

with cte as (
	select *,
	row_number() over (partition by film_id order by total_films desc) AS flag
	from (
		select film_id, actor_id, total_films
		from (
			select actor_id, count(film_id) as total_films 
			from sakila.film_actor
			group by actor_id
		) sub1
		join film_actor using(actor_id)
	) sub2 
)
select film_id, actor_id, total_films from cte
where flag = 1;
