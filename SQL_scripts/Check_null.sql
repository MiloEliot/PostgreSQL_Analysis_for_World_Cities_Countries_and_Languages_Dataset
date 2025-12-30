drop function if exists check_null(text);

create or replace function check_null(t_name text)
returns table(col_name text, count_null bigint)
language plpgsql
as $$
declare
	col text;
	num_null bigint;
begin
	for col in 
		select column_name
		from information_schema.columns 
		where table_name=t_name
		order by ordinal_position
	loop 
		execute format(
			'SELECT count(*) FROM %I WHERE %I IS NULL',
            t_name,
            col
		) into num_null;
		col_name := col;
		count_null := num_null;
		return next;
	end loop;
end;
$$