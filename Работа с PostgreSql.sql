1

select *, row_number () over (partition by r.customer_id order by r.rental_date) as num 
from rental r

2.1

with c_r as(
	select c.customer_id , c.first_name||' '||c.last_name as FIO, f.title, f.special_features 
	from customer c
	left join rental r on c.customer_id = r.customer_id 
	left join inventory i on i.inventory_id = r.inventory_id 
	left join film f on f.film_id = i.film_id )
select customer_id, count(special_features) 
from c_r
where array_position(special_features, 'Behind the Scenes' ) is not null
group by customer_id
order by customer_id


2.3
with c_r as(
	select c.customer_id , c.first_name||' '||c.last_name as FIO, f.title, f.special_features 
	from customer c
	left join rental r on c.customer_id = r.customer_id 
	left join inventory i on i.inventory_id = r.inventory_id 
	left join film f on f.film_id = i.film_id )
select customer_id, count(special_features) 
from c_r
where special_features && array['Behind the Scenes'] 
group by customer_id
order by customer_id



with c_r as(
	select c.customer_id , c.first_name||' '||c.last_name as FIO, f.title, f.special_features 
	from customer c
	left join rental r on c.customer_id = r.customer_id 
	left join inventory i on i.inventory_id = r.inventory_id 
	left join film f on f.film_id = i.film_id )
select customer_id, count(special_features) 
from c_r
where 'Behind the Scenes' = any(special_features)
group by customer_id
order by customer_id






2.2
create materialized view dz5_2 as(
	with c_r as(
		select c.customer_id , c.first_name||' '||c.last_name as FIO, f.title, f.special_features 
		from customer c
		left join rental r on c.customer_id = r.customer_id 
		left join inventory i on i.inventory_id = r.inventory_id 
		left join film f on f.film_id = i.film_id )
	select customer_id, count(special_features) 
	from c_r
	where array_position(special_features, 'Behind the Scenes' ) is not null
	group by customer_id
	order by customer_id)


	
select * from dz5_2