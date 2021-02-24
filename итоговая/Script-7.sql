
1. � ����� ������� ������ ������ ���������?


select  city, count(a.airport_code)  
from airports a
group by a.city 
having count(a.airport_code) > 1

���������.
������ � ������� 'airports'(��� ������� ��� ����������� ����������), ������� ����� � ��������� ���������� � ���.
��������� ���������� �� ���������� ���������� ��� ��� �� � ������ ���� ������ ������ ���������


2. � ����� ���������� ���� �����, ����������� ��������� � ������������ ���������� ��������?

select distinct f.departure_airport 
from flights f 
where f.aircraft_code = (select aircraft_code from aircrafts where "range" = (select max("range") from aircrafts))


���������.
������� ��������� � ������� � ������� ������� ���������� ������� ������� � ������������ ���������� ������
����� � ������� 'flights' ������� ����� � ���� ��������� � ������� �������� ���������� �� ������� ���� ������� �������(������ ��� �������).


3. ������� 10 ������ � ������������ �������� �������� ������( � ������� ����������� ������ ���� ����������� �������� limit )

select f.flight_id , f.flight_no , f.actual_departure - f.scheduled_departure as delay_time
from flights f 
where f.actual_departure - f.scheduled_departure is not null
order by delay_time desc 
limit 10

���������.
�������� � ������� 'flights'. �������� ����� ������ �� ���������������� ����� ������(�������� ����� ��������).
������ �������� ��� ��� �� ����� �������� �� ������ ���� ����� ����.
��������� �� ��������
������� ������ 10 �������


4. ���� �� �����, �� ������� �� ���� �������� ���������� ������?(� ������� ����������� ������ ���� ����������� ������ ��� JOIN )


select count(distinct b.book_ref)
from bookings b
left join tickets t on b.book_ref = t.book_ref 
left join boarding_passes bp on t.ticket_no = bp.ticket_no 
where bp.ticket_no is null and bp.flight_id is null

- ����� ������������ 91�388

���������.
��� ����� 3 ������� tickets, boarding_passes � bookings.
� bookings ��������� ���������� �� ������������� ��� ���� book_ref(����� ������������),  ��������� �� � �������� tickets, ��� ��� �� �� �������� ������ ������������ 
����� ������������ ������� ��������� � boarding_passes �� ������� ������� (ticket_no), ��� ��� �� ������ ����������� ������� bookings � boarding_passes, ��� ���� ���� ������ ������ � ��� ��������� ������ �� ��� 
������ �������� �� ������ �� ������� boarding_passes, ��� �� ������� ����� � ������� ��� ���������� �������
������� ������� ��

5.������� ��������� ����� ��� ������� �����, �� % ��������� � ������ ���������� ���� � ��������.
�������� ������� � ������������� ������ - ��������� ���������� ���������� ���������� ���������� �� ������� ��������� �� ������ ����. �.�. � ���� ������� ������ ���������� ������������� ����� - ������� ������� ��� �������� �� ������� ��������� �� ���� ��� ����� ������ ������ �� ����
(� ������� ����������� ������ ���� ������������ ������� ������� � ����������)


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


���������.
����� ����� ��������� ����� ��� ������� �����, �� % ��������� � ������ ���������� ���� � �������� ������ ���������� � ��������� �� � �������� flights
������ ��������� ���������� ���������� ������� ���� � ������ ����� 
������ ��������� ���������� ������� ����� ���� � ������ �����
� select� ����� ������������ ������ � �������� ������� ��������� ����, � ������� �� �������� ����������� ��������� ����.
��������� ������� � ������������� ������ �� ���� ��������� ������� ������� sum(busy_seat) over (partition by f.departure_airport, date(f.actual_arrival) order by f.actual_arrival) ����� ������������� ��������� ���� �� ������� ��������� �� ������ ����.
��� ����������� �������  f.flight_id, f.actual_arrival, f.departure_airport 


6.������� ���������� ����������� ��������� �� ����� ��������� �� ������ ����������(� ������� ����������� ������ ���� ������������ ��������� � �������� ROUND)

select  f.aircraft_code, round((count(f.aircraft_code)::numeric / (select count(f.flight_id) from flights f)::numeric)*100, 2) 
from flights f
group by f.aircraft_code 


���������.
�������� � ������� flights �.�. ��� ������� ��� ��������� �������� 
� ������� ���������� (select count(f.flight_id) from flights f) ������� ����� ��������� ���������
� ������� group by f.aircraft_code � count(f.aircraft_code) ������� ����������� ������� ��� ������� �������� � ����� �� �� ����� ����������� 
������� ��� �������� � ���������� ����������� ��������� �� ����� ��������� �� ������ ���������� ������


7.���� �� ������, � ������� �����  ��������� ������ - ������� �������, ��� ������-������� � ������ ��������?



	

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



-23 ������



���������.
������� CTE � ������� ������� ����������� ��������� ������ ��� ������� ��������� �������� � ������� min(amount)  as min_ ��� ������ ������, ���������� �������� ��� ����������� �������
������� ������ CTE � ������� ������� ��� ����� �� �������
����� ��������� ��� ������� � ������� left join
��������� �� ������� ��� ��� �� ����������� ��������� ������ � ������ ����� ���� ������ ������ �������
�������� ������, � ������� �����  ��������� ������ - ������� �������, ��� ������-�������

