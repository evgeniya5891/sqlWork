create table p4.author2(
	id serial primary key,
	full_name varchar(355) not null,
	nickname varchar(355),
	dr date not null)
	
	
	
insert into author2(full_name, dr)
values
('�������� ���� ���������', '1889.06.11'),
('���� ��������� �������������', '1880.11.16'),
('�������� ������ �����������', '1891.05.03')

---------------------------------------

create schema p4


create table p4.books(
	id serial primary key,
	book_name varchar(100) not null,
	book_years int2 check (book_years > 0 and book_years < 2100),
	author_id int
)


select * from books

insert into author2 (full_name , nickname ,dr )
values
	('���� �������� ����', null, '08.02.1828'),
	('������ ������� ���������', '��. ���������', '03.10.1814'),
	('������ ��������', null,'12.01.1949')
	
select * from author2 a 

insert into books (book_name, book_years, author_id)
values
	('�������� ����� ��� ��� �����', 1916, null),
	('��������',1916, null),
	('����� ������ �������',1840, null),
	('���������� ���',1980, null),
	('������� �������� �����',1994, null)
	
	select * from books b 

�� ���������


insert into books (book_name, book_years, author_id)
values
	('�������� ����� ��� ��� �����', 1916, null)
	
	
	
select * from author2 


 
		
insert into books (book_name, book_years)
select 
	unnest(array['�������� ����� ��� ��� �����', '��������', '����� ������ �������', '���������� ���', '������� �������� �����' ]),
	unnest(array[1916, 1837, 1840, 1980, 1994])
	
	---------------------------------
	
alter table author2 add column born_place varchar(50)

select * from books

alter table books add constraint book_author_fkey foreign key (author_id) references author2(id)


update author2 
set born_place = '���������� �������'
where id = 5

update author2 
set born_place = '������'
where id = 6

update author2 
set born_place = '�������'
where id = 4


update books 
set author_id = 7
where id = 14

update books 
set author_id = 9
where id = 17 or id = 18



update books 
set author_id = 8
where id = 15 or id = 16



select * from author2 


select * from books b2 


delete from books 
where id = 9


delete from author2 
where id = 4


truncate author2 cascade

drop table books


drop table author2

drop schema p4 cascade
