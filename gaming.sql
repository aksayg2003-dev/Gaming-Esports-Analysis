create database if not exists gaming;
use gaming;

show tables;

select * from `global_gaming_esports_2010_2025`;

-- creating 2 tables to perform joins --
create table region_info(
region_name varchar(100) primary key,
continent varchar(150)
);

insert into region_info values
('North America', 'America'),
('Europe', 'Europe'),
('Asia', 'Asia'),
('Latin America', 'America'),
('Middle East', 'Asia'),
('Africa', 'Africa');

create table platform_type(
platform varchar(100) primary key,
category varchar(150)
);

insert into platform_type values
('Mobile', 'Portable'),
('PC', 'Desktop'),
('Console', 'Home Gaming');

-- inner join --
select
g.region,
g.year,
g.Gaming_Revenue_BillionUSD,
r.continent
from `global_gaming_esports_2010_2025`g
inner join region_info r
on g.region = r.region_name;

-- left join --
select
g.region,
g.year,
g.Esports_Revenue_MillionUSD,
r.continent
from `global_gaming_esports_2010_2025`g
left join region_info r
on g.region = r.region_name;

-- right join -- 
select
g.region,
g.Top_Platform,
r.continent
from `global_gaming_esports_2010_2025`g
right join region_info r
on g.region = r.region_name;

-- full join --
select
g.region,
g.year,
g.Esports_Revenue_MillionUSD,
r.continent
from `global_gaming_esports_2010_2025`g
left join region_info r
on g.region = r.region_name

union

select
g.region,
g.year,
g.Top_Platform,
r.continent
from `global_gaming_esports_2010_2025`g
right join region_info r
on g.region = r.region_name;
--
select * from `global_gaming_esports_2010_2025`;

-- advanced data analysis --  
-- count active players in 2025 --
select Active_Players_Million,count(*) as count
from `global_gaming_esports_2010_2025`
group by Active_Players_Million;

-- total price pool --
select year,sum(Esports_PrizePool_MillionUSD) as total_price
from `global_gaming_esports_2010_2025`
group by Esports_PrizePool_MillionUSD;

-- select specific columns -- 
select year,Active_Players_Million,Esports_PrizePool_MillionUSD from `global_gaming_esports_2010_2025`;

-- finding average --
select year,avg(Avg_Spending_USD) as avg_USD
from `global_gaming_esports_2010_2025`
group by year
order by avg_USD desc;

-- -- Window Functions -- 
select * from(
select
Year,
Region,
Esports_Viewers_Million,
Top_Genre,
Pro_Players_Count,
row_number() over (partition by Region order by Year) as rn
from `global_gaming_esports_2010_2025`
)t
where rn = 1;

select * from `global_gaming_esports_2010_2025`;

-- implementing 3NF -- 
-- creating table for year --
create table year_info(
year_id int primary key auto_increment,
year_value int unique,
decade varchar(100)
);

-- creating table for region --
create table region(
region_id int primary key auto_increment,
region_name varchar(100) unique,
continent varchar(100)
);

-- creating table platform --
create table platform(
platform_id int primary key auto_increment,
platform_name varchar(100) unique,
platform_type varchar(100) 
);
create table gaming_facts (
fact_id int primary key auto_increment,
year_id int,
region_id int,
platform_id int,
gaming_revenue_billionusd decimal(10,2),
esports_revenue_millionusd decimal(10,2),
active_players_million decimal(10,2),
esports_prizepool_millionusd decimal(10,2),
esports_viewers_million decimal(10,2),
pro_players_count int,
avg_spending_usd decimal(10,2),
top_genre varchar(200),
foreign key (year_id) references year_info(year_id),
foreign key (region_id) references region(region_id),
foreign key (platform_id) references platform(platform_id)
);

insert into gaming_facts (
year_id,
region_id,
platform_id,
gaming_revenue_billionusd,
esports_revenue_millionusd,
active_players_million,
esports_prizepool_millionusd,
esports_viewers_million,
pro_players_count,
avg_spending_usd,
top_genre
)
select
(select year_id from year_info where year_value = g.year),
(select region_id from region where region_name = g.region),
(select platform_id from platform where platform_name = g.top_platform),
g.gaming_revenue_billionusd,
g.esports_revenue_millionusd,
g.active_players_million,
g.esports_prizepool_millionusd,
g.esports_viewers_million,
g.pro_players_count,
g.avg_spending_usd,
g.top_genre
from `global_gaming_esports_2010_2025` g;

