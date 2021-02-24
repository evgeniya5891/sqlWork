select  s.store_id, count(c.customer_id)
from store s 
left join customer c on s.store_id = c.store_id 
group by s.store_id 
having count(c.customer_id) > 300


select c.customer_id, concat(c.last_name, ' ', c.first_name) , c2.city 
from customer c 
left join address a on c.address_id = a.address_id
left join city c2 on a.city_id = c2.city_id 
---------------------------------------------------

select   s2.store_id, concat(s.first_name, ' ', s.last_name), c.city
from staff s
left join store s2 on s2.manager_staff_id = s.staff_id 
left join customer c2 on c2.store_id = s2.store_id 
left join address a on s2.address_id = a.address_id 
left join city c on a.city_id = c.city_id 
group by s2.store_id, s.staff_id, c.city_id 
having count(c2.customer_id) > 300


select count(distinct (concat(a.first_name, ' ', a.last_name)))
from actor a 
join film_actor fa on fa.actor_id = a.actor_id 
join film f on fa.film_id = f.film_id 
where f.rental_rate = 2.99






	
	
	












