select title, first_name||', '||last_name as FIO_actor, count(actor_id) over (partition by film_id)
from 



select title, first_name||' '||last_name as FIO_actor, count(fa.film_id) over (partition by fa.actor_id)
from film f 
left join film_actor fa on f.film_id = fa.film_id 
left join actor a on a.actor_id = fa.actor_id 
order by fa.actor_id 