use covidprojrect;

-- Trying to update the date column from mm/dd/yy to mm/dd/yyyy (for coviddeaths and covidvaccinations) --

-- Using Replace function to change the date column but this change is temporary
select date, replace(date,'20','2020') as date_fixed 
from coviddeaths 
where date like '%20' 
; 
select * from coviddeaths;

-- Update the date column using update function (testing just in case I update the column wrongly)
-- Update 2/24/20 to 2/24/2020
set sql_safe_updates=0;
update coviddeaths
	set date ='2/24/2020'
    where date = '2/24/20';

--  Update rows in Feb-2020 (testing just in case I update the column wrongly)
update coviddeaths
	set date= replace(date,'20','2020')
    where date like '2/___20' ;
    
-- Update all rows in 2020 (2021)
update coviddeaths
	set date= replace(date,'21','2021')
    where date like '%21' ;

-- rows with 20th(21st) were updated as mm/2020/2020 (mm/2021/2021)
select * from coviddeaths
	where date like ('%/2020/2020');

update coviddeaths
	set date ='3/21/2021'
    where date = '3/2021/2021';

update coviddeaths
	set date ='4/21/2021'
    where date = '4/2021/2021';

update coviddeaths
	set date ='5/21/2021'
    where date = '5/2021/2021';

update coviddeaths
	set date ='6/21/2021'
    where date = '6/2021/2021';
    
update coviddeaths
	set date ='7/21/2021'
    where date = '7/2021/2021';
    
update coviddeaths
	set date ='8/21/2021'
    where date = '8/2021/2021';
    
update coviddeaths
	set date ='9/21/2021'
    where date = '9/2021/2021';
    
update coviddeaths
	set date ='10/21/2021'
    where date = '10/2021/2021';
 
update coviddeaths
	set date ='11/21/2021'
    where date = '11/2021/2021';
    
update coviddeaths
	set date ='12/21/2021'
    where date = '12/2021/2021';
    
update coviddeaths
	set date ='1/21/2021'
    where date = '1/2021/2021';
    
update coviddeaths
	set date ='2/21/2021'
    where date = '2/2021/2021';

-- (coviddeaths only) rows with Feb-2020 were updated to 2/dd/20202020 or 2/20202020/20202020 
-- because I tried to update Feb-2020 data for testing before I update all rows in 2020
select * from coviddeaths
	-- where date like '%20202020'
    ;
update coviddeaths
	set date= replace(date,'20202020','2020')
    where date like '%/20202020' ;
    
update coviddeaths
	set date ='2/20/2020'
    where date = '2/2020/2020';
 
 set sql_safe_updates=1;
--                    Trying to update the date column from mm/dd/yy to mm/dd/yyyy (end)              --


-- update the date column using str_to_date() -> data type will not change to date but data will return as
-- date under str_to_date()

update coviddeaths
	set date = str_to_date(date,'%c/%e/%Y');
update covidvaccinations
	set date=  str_to_date(date,'%c/%e/%Y');
    
-- str_to_date can be used to select statement as below:
-- select str_to_date(date,'%c/%e/%Y') from coviddeaths;