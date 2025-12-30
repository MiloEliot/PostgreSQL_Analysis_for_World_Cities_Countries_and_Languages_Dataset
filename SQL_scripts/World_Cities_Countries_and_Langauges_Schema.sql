--drop table if exists cities cascade;
create table if not exists cities (
	id bigint generated always as identity primary key,
	"name" text,
	country_code varchar(8),
	district text,
	population bigint
);

copy cities(id, "name", country_code, district, population)
from '/Users/yingliu/Documents/GitHub/World_Cities_Countries_and_Languages/data/city.csv'
delimiter ','
csv header;

--drop table countries cascade;
create table if not exists countries (
	code varchar(8) primary key,
	"name" text,
	continent text,
	region text, 
	surface_area numeric,
	indepyear numeric, 
	population bigint,
	life_expectancy numeric,
	gnp numeric,
	gnp_old numeric,
	local_name text,
	government_form text,
	head_of_state text,
	capital_temp numeric,
	code2 varchar(8)
);

copy countries(code, "name", continent, region, surface_area, indepyear, population, life_expectancy, gnp, gnp_old, local_name, government_form, head_of_state, capital_temp, code2)
from '/Users/yingliu/Documents/GitHub/World_Cities_Countries_and_Languages/data/country.csv'
delimiter ','
csv header;

alter table countries
add column capital bigint;

update countries 
set capital=capital_temp::bigint;

alter table countries
drop column capital_temp;

--drop table if exists country_languages cascade;
create table if not exists country_languages (
	id bigint generated always as identity primary key,
	country_code varchar(8),
	"language" text, 
	is_official boolean, 
	percentage numeric
);

copy country_languages(country_code, "language", is_official, percentage)
from '/Users/yingliu/Documents/GitHub/World_Cities_Countries_and_Languages/data/countrylanguage.csv'
delimiter ','
csv header;


-- Add foreign keys
alter table cities 
add constraint fk_cities_country_code
foreign key (country_code)
references countries(code)
on update cascade
on delete no action;


alter table countries
add constraint fk_countries_capital
foreign key (capital)
references cities(id)
on update cascade 
on delete no action;

alter table country_languages
add constraint fk_languages_country_code
foreign key (country_code)
references countries(code)
on update cascade 
on delete no action;




