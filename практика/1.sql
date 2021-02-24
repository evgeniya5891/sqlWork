select title, first_name||', '||last_name as FIO_actor, count(actor_id) over (partition by film_id)
from 



select title, first_name||' '||last_name as FIO_actor, count(fa.film_id) over (partition by fa.actor_id)
from film f 
left join film_actor fa on f.film_id = fa.film_id 
left join actor a on a.actor_id = fa.actor_id 
order by fa.actor_id 

--------------------------------------------------------

select c.last_name , f.title , p.payment_date, avg(p.amount) over (partition by c.customer_id)
from customer c 
left join payment p on p.customer_id = c.customer_id 
left join rental r on r.customer_id = c.customer_id 
left join inventory i on r.inventory_id = i.inventory_id 
left join film f on f.film_id = i.film_id 
order by c.last_name 



select c.last_name , f.title , p.payment_date, 
	avg(p.amount) over (partition by c.customer_id),
	sum(p.amount) over (partition by c.customer_id),
	min(p.amount) over (partition by c.customer_id),
	max(p.amount) over (partition by c.customer_id),
	sum(p.amount) over (partition by c.customer_id order by p.payment_date, r.rental_id )
from customer c 
left join payment p on p.customer_id = c.customer_id 
left join rental r on r.customer_id = c.customer_id 
left join inventory i on r.inventory_id = i.inventory_id 
left join film f on f.film_id = i.film_id 
order by c.last_name, p.payment_date, r.rental_id



select c.last_name , f.title , p.payment_date, p.amount , 
	sum(p.amount) over (partition by c.customer_id, date(p.payment_date) order by r.rental_id ),
	 r.rental_id
from customer c 
left join payment p on p.customer_id = c.customer_id 
left join rental r on r.customer_id = c.customer_id 
left join inventory i on r.inventory_id = i.inventory_id 
left join film f on f.film_id = i.film_id 
order by c.customer_id , p.payment_date, r.rental_id

--------------------------------

with st_r as (
	select s2.last_name||' '||s2.first_name as foi, r2.rental_id, s2.staff_id 
	from staff s2 
	left join rental r2 on r2.staff_id = s2.staff_id )
select foi, count(rental_id)
from st_r
group by staff_id, foi




with name_c as (
	select "name", category_id
	from category 
	where "name" like 'C%')
select "name" , f.title
from name_c
left join film_category fc on fc.category_id = name_c.category_id
left join film f on f.film_id = fc.film_id 


---------------------------------------
with recursive r as(
	select 
		1 as i,
		1 as factorial
	union 
	select
		i + 1 as i,
		factorial * (i + 1) as factorial 
	from r
	where i < 10
)
select *
from r

create table geo(
	id int primary key,
	parent_id int references geo(id),
	name varchar(1000));

insert into geo (id, parent_id, name)
values
	(1, null, 'Планета Земля'),
	(2, 1 , 'Континент Евразия'),
	(3, 1, 'Континент Северная Америка'),
	(4, 2, 'Европа'),
	(5, 4, 'Россия'),
	(6, 4, 'Германия'),
	(7, 5, 'Москва'),
	(8, 5, 'Санкт-Петербург'),
	(9, 6, 'Берлин');
	

select *from geo

------------------------
create view p5_23 as
	with cte_1 as (
		select *, row_number() over (partition by r.customer_id order by r.rental_date desc) as lr
		from rental r)
	select c.last_name , c.email , f.title 
	from cte_1
	left join customer c on c.customer_id = cte_1.customer_id 
	left join inventory i on i.inventory_id = cte_1.inventory_id
	left join film f  on f.film_id = i.film_id 
	where cte_1.lr = 1
	
select * from p5_23


create view p5_23_2 as 
	select  title, first_name||' '||last_name as FIO_actor, count(fa.film_id) over (partition by fa.actor_id)
	from film f
	left join film_actor fa on f.film_id = fa.film_id 
	left join actor a on fa.actor_id = a.actor_id 
	
	
select * from p5_23_2


create materialized view m_v2 as
	with cte_1 as (
		select *, row_number() over (partition by r.customer_id order by r.rental_date desc) as lr
		from rental r)
	select c.last_name , c.email , f.title 
	from cte_1
	left join customer c on c.customer_id = cte_1.customer_id 
	left join inventory i on i.inventory_id = cte_1.inventory_id
	left join film f  on f.film_id = i.film_id 
	where cte_1.lr = 1
with no data


select * from m_v2


