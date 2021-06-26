
-- Create the tables for the S&P 500 database.
-- They contain information about the companies 
-- in the S&P 500 stock market index
-- during some interval of time in 2014-2015.
-- https://en.wikipedia.org/wiki/S%26P_500 

create table history
(
	symbol text,
	day date,
	open numeric,
	high numeric,
	low numeric,
	close numeric,
	volume integer,
	adjclose numeric
);

create table sp500
(
	symbol text,
	security text,
	sector text,
	subindustry text,
	address text,
	state text
);

-- Populate the tables
insert into history select * from bob.history;
insert into sp500 select * from bob.sp500;

-- Familiarize yourself with the tables.
select * from history;
select * from sp500;


-- Exercise 1 (3 pts)

-- 1. (1 pts) Find the number of companies for each state, sort descending by the number.

select state, count(*)
from sp500
group by state
order by count(*) desc;



-- 2. (1 pts) Find the number of companies for each sector, sort descending by the number.

select sector, count(*)
from sp500
group by sector
order by count(*) desc;


-- 3. (1 pts) Order the days of the week by their average volatility.
-- Sort descending by the average volatility. 
-- Use 100*abs(high-low)/low to measure daily volatility.
create view dayweek as
SELECT EXTRACT(dow from day) AS dayofweek, 100*abs(high-low)/low  AS volatility
FROM history;

select dayofweek, sum(volatility)/count(dayofweek) as ave
from dayweek
group by dayofweek
order by ave desc;

drop view dayweek;
-- Exercise 2 (4 pts)

-- 1. (2 pts) Find for each symbol and day the pct change from the previous business day.
-- Order descending by pct change. Use adjclose.

select symbol, day, 100*(adjclose-prev)/prev as pct
from ( select symbol,day, adjclose,lag (adjclose, 1) over (partition by symbol order by day asc) as prev from history)x
order by 100*(adjclose-prev)/prev DESC NULLS LAST;


-- 2. (2 pts)
-- Many traders believe in buying stocks in uptrend
-- in order to maximize their chance of profit. 
-- Let us check this strategy.
-- Find for each symbol on Oct 1, 2015 
-- the pct change 20 trading days earlier and 20 trading days later.
-- Order descending by pct change with respect to 20 trading days earlier.
-- Use adjclose.

-- Expected result
--TE,26.0661102331371252,3.0406725557250169
--TAP,24.6107784431137725,5.1057184046131667
--CVC,24.4688922610015175,-0.67052727826882048156
-- ...
select symbol, 100*(adjclose-prev)/prev as prechange, 100*(later-adjclose)/adjclose as laterchange
from (
    select symbol,day, adjclose,
           lag (adjclose, 20) over (partition by symbol order by day asc) as prev,
           lead (adjclose, 20) over (partition by symbol order by day asc) as later
    from history
) price
where day = date '2015-10-01'
order by  100*(adjclose-prev)/prev desc;


-- Exercise 3 (3 pts)
-- Find the top 10 symbols with respect to their average money volume AVG(volume*adjclose).
-- Use round(..., -8) on the average money volume.
-- Give three versions of your query, using ROW_NUMBER(), RANK(), and DENSE_RANK().

SELECT symbol,ave
FROM (
    SELECT symbol, ave,ROW_NUMBER() OVER (ORDER BY ave DESC) AS rank
    FROM ( SELECT symbol,round(Avg(volume*adjclose)::BIGINT,-8) as ave
           FROM history
           group by symbol)x)y
where rank <=10;

select symbol,ave from(
select symbol,ave,RANK() OVER ( order by ave DESC) AS rank
from(
SELECT symbol,round(Avg(volume*adjclose)::BIGINT,-8) as ave
FROM history
group by symbol) x)y
where rank<=10;


SELECT symbol,ave
FROM (
SELECT symbol, ave,DENSE_RANK() OVER ( ORDER BY ave DESC)AS rank
FROM (SELECT symbol,round(Avg(volume*adjclose)::BIGINT,-8) as ave
FROM history
group by symbol) x)y
where rank<=10;
