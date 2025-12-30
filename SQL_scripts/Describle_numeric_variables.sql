--drop function if exists describe_numeric_variables(text);

create or replace function describe_numeric_variables(t_name text)
returns table( 
	col_name text,
	min_val numeric,
	max_val numeric,
	mean_val numeric,
	median_val numeric,
	lower_quantile numeric,
	upper_quantile numeric
)
language plpgsql
as $$
declare 
	col text;
	min_temp numeric;
	max_temp numeric;
	mean_temp numeric;
	median_temp numeric;
	lower_temp numeric;
	upper_temp numeric;
begin
	for col in 
		select column_name
		from information_schema.columns 
		where table_name=t_name and (data_type='bigint' or data_type='int' or data_type='numeric')
		order by ordinal_position
	loop
		execute format('select min(%I) from %I', col, t_name) into min_temp;
		execute format('select max(%I) from %I', col, t_name) into max_temp;
		execute format('select avg(%I) from %I', col, t_name) into mean_temp;
		execute format('select percentile_cont(0.5) within group(order by %I) from %I', col, t_name) into median_temp;
		execute format('select percentile_cont(0.25) within group(order by %I) from %I', col, t_name) into lower_temp;
		execute format('select percentile_cont(0.75) within group(order by %I) from %I', col, t_name) into upper_temp;
		
		col_name := col;
		min_val := min_temp;
		max_val := max_temp;
		mean_val := mean_temp;
		median_val := median_temp;
		lower_quantile := lower_temp;
		upper_quantile := upper_temp;
		return next;
	end loop;
	
end;
$$