select value
from generate_series(1,3) as t(value);

select 	value, 
	rank() over(order by value), 
	rank() over(order by value), 
	array_agg(value) over (),
	array_agg(value) over (order by value)
from generate_series(1,3) as t(value);

CREATE TABLE t
(
  id integer,
  value integer,
  name character varying
);

create table salary
(
	depname character varying,
	name character varying,
	salary integer
);

insert into salary values ('engineering', 'adam', 1000);
insert into salary values ('engineering', 'ola', 1100);
insert into salary values ('engineering', 'tomek', 900);
insert into salary values ('it', 'kuba', 1200);
insert into salary values ('it', 'krzysiek', 800);
insert into salary values ('hr', 'dagmara', 1300);
insert into salary values ('hr', 'kasia', 700);

insert into t values(1,1,'a');
insert into t values(2,1,'b');
insert into t values(3,2,'c');
insert into t values(4,2,'d');
insert into t values(5,3,'d');
insert into t values(6,4,'e');
insert into t values(7,4,'e');
insert into t values(8,4,'e');
insert into t values(9,4,'f');
insert into t values(9,5,'e');

select	id, value, name,
	rank() over(order by value) rank_value,
	rank() over(order by name) rank_name,
	array_agg(name) over (order by name)
from t;

select	id, value, name,
	array_agg(value) over (partition by value),
	array_agg(name) over (partition by name)
from t;

select 	id, value, name,
	array_agg(value) over (partition by value)
from t;
--------------
select *
from salary;

select depname, s
from
(
select depname, sum(salary) as s
from salary
group by depname
) as ss where s > 2500;

select 	depname,
	sum(salary) over (partition by depname) as depsalary
from salary;

select 	depname, name, salary,
	rank() over (order by salary desc) as priority
from salary;

select depname, name, salary, priority
from 	(
	select 	depname, name, salary,
		rank() over (order by salary desc) as priority
	from salary
	) as s
where priority = 1;


select depname, depsalary 
from
(
	select 	depname,
	sum(salary) over (partition by depname) as depsalary
	from salary
) as ds
where depsalary > 2500;

--check if all values are the same
select id from
(
	select distinct id, every(value = 1) over(partition by id)
	from v
	where id = 1
) t where t.every is true;