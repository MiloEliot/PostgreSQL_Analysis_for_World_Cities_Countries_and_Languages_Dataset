-- check the capital and official language of a given country
drop function if exists check_capital_language(text);

create or replace function check_capital_language(country text)
returns table (
	country_name text,
	capital text,
	"language" text
)
language plpgsql
as $$
begin
	return query
	
	select a.name as country_name, b.name as capital, c.language 
	from countries a
	join cities b on a.capital=b.id
	join country_languages c on a.code=c.country_code
	where a.name=country and c.is_official=true;
end;
$$

select * from check_capital_language('France');


-- check the name and population of cities belonging to a given country
drop function if exists check_cities(text);

create or replace function check_cities(country text)
returns table ( 
	city text,
	population bigint,
	"rank" bigint
)
language plpgsql
as $$ 
declare
	c_code varchar(8);
begin
	select code into c_code from countries where "name"=country;
	
	return query
	select c.name as city, c.population, rank() over(partition by c.country_code order by c.population desc) as "rank"
	from cities c
	where c.country_code=c_code;
	
end
$$

select * from check_cities('France');