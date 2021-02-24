create schema p4


create table p4.countries(
	countries_id serial primary key,
	countries varchar(100) not null,
	capital_city varchar(100),
	territory float(2) check (territory > 0) not null
)


create table p4.languages(
	languag_id serial primary key,
	languages_name varchar(100) not null,
	count_speakers int4
)

drop table language_nationality restrict



create table p4.nationality(
	nationality_id serial primary key,
	nationality_name varchar(100) not null,
	population int4 
)


create table p4.language_nationality(
	languag_id int2,
	nationality_id int2,
	primary key (languag_id, nationality_id)
)


alter table language_nationality add constraint language_fkey foreign key (languag_id) references languages(languag_id);
alter table language_nationality add constraint nationality_fkey foreign key (nationality_id) references nationality(nationality_id)


create table p4.countries_nationality(
	countries_id int2,
	nationality_id int2,
	primary key (countries_id, nationality_id)
)

alter table countries_nationality add constraint countries_fkey foreign key (countries_id) references countries(countries_id);
alter table countries_nationality add constraint nationality_fkey2 foreign key (nationality_id) references nationality(nationality_id)


insert into countries (countries, capital_city, territory )
values
	('���������', '���-������', '2724902'),
	('���', '���������', '9519431'),
	('������', '������', '17125191'),
	('������', '���������', '447435'),
	('���������', null, '41284')
	

insert into languages (languages_name, count_speakers)
values
	('�������', '260000000'),
	('����������', '753359540'),
	('���������', '13161980'),
	('��������', '10000000'),
	('��������', '150000000')
	

insert into nationality (nationality_name, population)
values
	('������', '14500000'),
	('����������', '328239523'),
	('�����', '10373225'),
	('�������', '135000000'),
	('���������', '5400000')
	
	
insert into countries_nationality (countries_id , nationality_id)
values
	(3, 1),
	(5, 5),
	(1, 4),
	(1, 1),
	(2, 4),
	(2, 2),
	(4, 3)
	
	
insert into language_nationality (languag_id , nationality_id)
values
	(1, 4),
	(1, 1),
	(2, 2),
	(2, 3),
	(3, 1),
	(5, 5),
	(4, 3)

	
insert into language_nationality (languag_id , nationality_id)
values
	(5, 5)

	
	
delete from language_nationality 
where languag_id = 5 and nationality_id = 1
	
	
	
select * from countries c; 
select * from languages l;
select * from nationality n;
select * from countries_nationality cn ;
select * from language_nationality ln2 ;




	

