begin;

create temporary table data (
       province_state		text,
       country_region		text,
       confirmed		integer,
       recovered		integer,
       deaths			integer
);

insert into data
(province_state,country_region,confirmed,recovered,deaths)
(
select
province_state,
country_region,
max(confirmed) as confirmed,
max(recovered) as recovered,
max(deaths) as deaths
from csse.dailies
group by province_state,country_region
);

select
sum(confirmed) as confirmed,
sum(recovered) as recovered,
sum(deaths) as deaths,
(sum(deaths)::float/sum(confirmed)::float)::numeric(4,3) as lb,
(sum(deaths)::float/(sum(2*recovered)::float+sum(deaths)::float))::numeric(4,3) as mb,
(sum(deaths)::float/(sum(recovered)::float+sum(deaths)::float))::numeric(4,3) as ub
from data;

commit;

