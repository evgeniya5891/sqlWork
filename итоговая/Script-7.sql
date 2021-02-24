
1. В каких городах больше одного аэропорта?


select  city, count(a.airport_code)  
from airports a
group by a.city 
having count(a.airport_code) > 1

Пояснение.
Работа в таблице 'airports'(там имеется все необходимая информация), выводим город и количесво аэропортов в нем.
Фильтруем информацию по колличесву аэропортов так что бы в городе было больше одного аэропорта


2. В каких аэропортах есть рейсы, выполняемые самолетом с максимальной дальностью перелета?

select distinct f.departure_airport 
from flights f 
where f.aircraft_code = (select aircraft_code from aircrafts where "range" = (select max("range") from aircrafts))


Пояснение.
Создаем подзапрос в котором с помощью другого подзапроса находим самолет с максимальной дальностью полета
Далее в таблице 'flights' находим рейсы с этим самолетом и выводим название аэропортов из которых этот самолет вылетал(Убирая все повторы).


3. Вывести 10 рейсов с максимальным временем задержки вылета( В решении обязательно должно быть использован Оператор limit )

select f.flight_id , f.flight_no , f.actual_departure - f.scheduled_departure as delay_time
from flights f 
where f.actual_departure - f.scheduled_departure is not null
order by delay_time desc 
limit 10

Пояснение.
Работаем в таблице 'flights'. минусуем время вылета из запланированного время вылета(получаем время задержки).
делаем проверку так что бы время задержки не должна быть равна нулю.
Сортируем по убыванию
Выводим первые 10 записей


4. Были ли брони, по которым не были получены посадочные талоны?(В решении обязательно должно быть использован Верный тип JOIN )


select count(distinct b.book_ref)
from bookings b
left join tickets t on b.book_ref = t.book_ref 
left join boarding_passes bp on t.ticket_no = bp.ticket_no 
where bp.ticket_no is null and bp.flight_id is null

- таких бронирований 91 388

Пояснение.
Нам нужны 3 таблицы tickets, boarding_passes и bookings.
В bookings находится информация по бронированиям где ключ book_ref(номер бронирования),  соедением ее с таблицей tickets, так что бы не потерять номера бронирования 
Далее получившуюся таблицу соединяем с boarding_passes по номерам билетов (ticket_no), так что бы видеть пересечение таблицы bookings и boarding_passes, где есть весь список броней и все возможные талоны по ним 
делаем проверку по ключам из таблицы boarding_passes, что бы увидеть брони в который нет посадочных талонов
считаем столько их

5.Найдите свободные места для каждого рейса, их % отношение к общему количеству мест в самолете.
Добавьте столбец с накопительным итогом - суммарное накопление количества вывезенных пассажиров из каждого аэропорта на каждый день. Т.е. в этом столбце должна отражаться накопительная сумма - сколько человек уже вылетело из данного аэропорта на этом или более ранних рейсах за день
(В решении обязательно должно быть использована Оконная функция и Подзапросы)


select f.flight_id, f.actual_arrival, f.departure_airport ,all_seat-busy_seat as available_seats,
case when (busy_seat::real/all_seat::real)*100= 0 then 100 else 100 - (busy_seat::real/all_seat::real)*100 end,
sum(busy_seat) over (partition by f.departure_airport, date(f.actual_arrival) order by f.actual_arrival)
from flights f 
left join (select f.flight_id, count(bp.seat_no) as busy_seat
	from flights as f
	left join boarding_passes bp on bp.flight_id = f.flight_id 
	group by f.flight_id 
	order by f.flight_id ) as f_busy on f.flight_id = f_busy.flight_id
left join (select f.flight_id , count(s.seat_no) as all_seat
	from flights f
	right join seats s on s.aircraft_code = f.aircraft_code
	where f.flight_id is not null
	group by f.flight_id 
	order by f.flight_id) as f_all on f.flight_id = f_all.flight_id
where f.actual_arrival is not null


Пояснение.
Чтобы найти свободные места для каждого рейса, их % отношение к общему количеству мест в самолете делаем плдзапросы и соединяем их с таблицей flights
первый подзапрос показывает количество занятых мест в каждом рейсе 
второй подзапрос показывает сколько всего мест в каждом рейсе
в selectе делим получившиеся ответы и получаем процент свободных мест, а минусуя их получаем колличество свободных мест.
Добавляем столбец с накопительным итогом по дате использую оконную функцию sum(busy_seat) over (partition by f.departure_airport, date(f.actual_arrival) order by f.actual_arrival) делаю накопительный суммарный итог по каждому аэропорту на каждый день.
для наглядности выводим  f.flight_id, f.actual_arrival, f.departure_airport 


6.Найдите процентное соотношение перелетов по типам самолетов от общего количества(В решении обязательно должно быть использована Подзапрос и Оператор ROUND)

select  f.aircraft_code, round((count(f.aircraft_code)::numeric / (select count(f.flight_id) from flights f)::numeric)*100, 2) 
from flights f
group by f.aircraft_code 


Пояснение.
Работаем в таблице flights т.к. там указаны все возможные перелеты 
С помощью подзапроса (select count(f.flight_id) from flights f) находим общее количесво перелетов
с помощью group by f.aircraft_code и count(f.aircraft_code) находим колличество вылетов для каждого самолета и делим ее на общее колличество 
выводим код самолета и процентное соотношение перелетов по типам самолетов от общего количества рейсов


7.Были ли города, в которые можно  добраться бизнес - классом дешевле, чем эконом-классом в рамках перелета?



	

with air_Business as (
	select  a.city,  tf.fare_conditions , min(amount) as min_
	from ticket_flights tf 
	left join flights f on f.flight_id = tf.flight_id 
	left join airports a on a.airport_code = f.arrival_airport
	group by   tf.fare_conditions,a.city
	having fare_conditions = 'Business'),
air_all as (
	select  a.city, tf.amount, tf.fare_conditions 
	from ticket_flights tf 
	left join flights f on f.flight_id = tf.flight_id 
	left join airports a on a.airport_code = f.arrival_airport
	order by a.city )
select distinct aa.city
from air_all as aa
inner join air_Business as ab on ab.city = aa.city 
group by aa.city, ab.min_ ,  aa.amount, aa.fare_conditions
having ab.min_ < aa.amount and aa.fare_conditions = 'Economy'



-23 города



Пояснение.
Создаем CTE в котором находим минимальную стоимость билета для каждого аэропорта прибытия с помощью min(amount)  as min_ для бизнес класса, паралельно соединяя все необходимые таблицы
Создаем второе CTE в котором имеются все цеены на баилеты
далее соединяем эти запросы с помошью left join
сортируем по условия так что бы минимальная стоимость билета в бизнес класе была меньше любого эконома
получаем города, в которые можно  добраться бизнес - классом дешевле, чем эконом-классом

