use CovidProject;
select * from coviddeaths;
select * from covidvaccinations;
select location, date,total_cases,new_cases,total_deaths,population,(total_deaths/population)*100 as death_rate
	from coviddeaths
    where location in ('China');

select location, date,total_cases,new_cases,total_deaths,population,(total_deaths/total_cases)*100 as death_rate
	from coviddeaths
    where location in ('China');
    

 -- select top 10 locations with highest death rate
select location,max(total_cases),max(total_deaths),(max(total_deaths)/max(total_cases))*100 as death_rate
    from coviddeaths
    where continent <> ''
    group by location
    order by 4 desc
    limit 10
   ;

-- select top 10 locations with highest infection rate
select location,population,max(total_cases),(max(total_cases)/population)*100 as infection_rate
    from coviddeaths
    where continent <> ''
    group by location,population
    order by 4 desc
    limit 10
   ;

-- select top 10 locations with the most confirmed cases
select location, max(total_cases)
	from coviddeaths
    where continent <> ''
    group by location
    order by 2 desc
    limit 10
    ;

-- select top 10 locations with the most death cases
-- data total_deaths is TEXT but I was not able to use case(total_deaths as int) for below, 
-- so I use total_deaths*1 instead
select location,max(total_deaths*1) as death_count
	from coviddeaths
    where continent <> ''
    group by location
    order by 2 desc
    limit 10
    ;
    
-- total confirmed cases in continent level
select continent,max(total_cases) as confirmed_case
	from coviddeaths
    where continent <> ''
    group by continent
    order by 2 desc
    ;
    
-- arrange continents death case by descending order
select continent,max(total_deaths*1) as death_case
	from coviddeaths
    where continent <> ''
    group by continent
    order by 2 desc
    ;
    
-- select top dates with the most new cases around the world
select date, sum(new_cases) as confirmed_case
	from coviddeaths
    where continent <> ''
    group by date 
    order by 2 desc
    ;
    
-- select top dates with the most death cases around the world
select date, sum(new_deaths*1) as new_death_case
	from coviddeaths
    where continent <> ''
    group by date 
    order by 2 desc
    ;
    
 -- Join coviddeaths and covidvaccinations together
 select * 
	from coviddeaths d
    join covidvaccinations v 
    on d.location=v.location 
    and d.date=v.date
    where d.continent <> ''   
    ;
    
 -- Total population vs New vaccinations
select d.continent,d.location,d.date,d.population,v.new_vaccinations
	from coviddeaths d
    join covidvaccinations v 
    on d.location=v.location 
    and d.date=v.date
    where d.continent <> '' -- and d.location in ('Canada')
    order by 2,3
    ;

-- Show the rolling total vaccination as of date    
select d.continent,d.location,d.date,d.population,v.new_vaccinations
	, sum(v.new_vaccinations) over (partition by d.location order by d.date) as total_vacc_as_of_date
    -- if we just use partition by d.location, cannot show the rolling total vaccination but only the total vaccination
	from coviddeaths d
    join covidvaccinations v 
    on d.location=v.location 
    and d.date=v.date
    where d.continent <> '' -- and d.location in ('Canada')
    order by 2,3
    ;

-- Create CTE/ Temporary table 
-- Context: we create a new column- total_vacc_as_of_date in the query and
-- would like to calculate the vaccination rate (total_vacc_as_of_date/d.population)
-- but we cannot use a newly created column in the same query. We need to use CTE/ Temp table

-- CTE
with CTE_TotalVacc as (
select d.continent,d.location,d.date,d.population,v.new_vaccinations
	, sum(v.new_vaccinations) over (partition by d.location order by d.date) as total_vacc_as_of_date
	from coviddeaths d
    join covidvaccinations v 
    on d.location=v.location 
    and d.date=v.date
    where d.continent <> '' -- and d.location in ('Canada')
    order by 2,3
    )
Select continent,location,date,population,new_vaccinations,
	total_vacc_as_of_date,(total_vacc_as_of_date/population)*100 as vacc_rate
from CTE_TotalVacc
;

-- Temp Table
create temporary table Temp_TotalVacc 
select d.continent,d.location,d.date,d.population,v.new_vaccinations
	, sum(v.new_vaccinations) over (partition by d.location order by d.date) as total_vacc_as_of_date
	from coviddeaths d
    join covidvaccinations v 
    on d.location=v.location 
    and d.date=v.date
    where d.continent <> '' -- and d.location in ('Canada')
    order by 2,3;

Select -- continent,location,date,population,new_vaccinations,total_vacc_as_of_date
	* ,(total_vacc_as_of_date/population)*100 as vacc_rate
	from Temp_TotalVacc
    -- where location in ('Canada')
    ;

Drop table if exists Temp_TotalVacc;
describe Temp_TotalVacc;


-- Creating view to store data for later visualization
create view rolling_totalvacc as
select d.continent,d.location,d.date,d.population,v.new_vaccinations
	, sum(v.new_vaccinations) over (partition by d.location order by d.date) as total_vacc_as_of_date
    -- if we just use partition by d.location, cannot show the rolling total vaccination but only the total vaccination
	from coviddeaths d
    join covidvaccinations v 
    on d.location=v.location 
    and d.date=v.date
    where d.continent <> '' -- and d.location in ('Canada')
    order by 2,3
    ;
    
select * from rolling_totalvacc;