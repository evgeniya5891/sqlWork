select * from customer where activebool = false 

select title, release_year from film where release_year = 2006

select rental_id, amount, payment_date 
from payment 
where amount != 0
order by payment_date desc 
limit 10

