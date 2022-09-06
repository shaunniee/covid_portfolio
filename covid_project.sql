use covid_portfolio_project;
select * from covid_portfolio_project..CovidDeaths;



-- TOTAL CASES VS TOTAL DEATHS
create view cases_vs_deaths as 
Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathPercentage 
from covid_portfolio_project..CovidDeaths
--order by 1,2;


-- TOTAL CASES VS POPULATION
create view cases_vs_population as
Select location,date,total_cases,population,(total_cases/population)*100 as casePercentage 
from covid_portfolio_project..CovidDeaths
where continent is not null
--order by 1,2;

-- countries with highest infection rate 

create view highest_infection_rate as
Select location,Population,max(total_cases) as HighestInfectionCount,max(total_cases/population)*100 as infectionRate
from covid_portfolio_project..CovidDeaths
where continent is not null
group by location,population
--order by infectionRate desc;

-- Highest death count per population
create view death_per_population as
Select location,max(cast(total_deaths as int)) as HighestDeathCount
from covid_portfolio_project..CovidDeaths
where continent is not null
group by location
--order by 2 desc;


--  by continent
-- continents with highest death count
create view continent_highest_death as
Select continent,max(cast(total_deaths as int)) as HighestDeathCount
from covid_portfolio_project..CovidDeaths
where continent is not null
group by continent
--order by 2 desc;

-- global numbers

create view global as
Select sum(new_cases) as total_cases,sum(cast(new_deaths as int))  as total_deaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 as deathPercentage
from covid_portfolio_project..CovidDeaths
where continent is not null
--group by date
--order by 1,2;


-- total population vs vaccinations

create view pop_vs_vac as
SELECT cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,sum(cast(cv.new_vaccinations as int)) 
over(partition by cd.location order by cd.location,cd.date) as rollingTotalVaccinations FROM
covid_portfolio_project..covidDeaths as cd
join covid_portfolio_project..CovidVaccinations as cv
on cv.location=cd.location and cv.date=cd.date
where cd.continent is not null
--order by 2,3;

with popvsvac(continent,location,date,popultion,new_vaccinations,rollingtotal) 
as(SELECT cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,sum(cast(cv.new_vaccinations as int)) 
over(partition by cd.location order by cd.location,cd.date) as rollingTotalVaccinations FROM
covid_portfolio_project..covidDeaths as cd
join covid_portfolio_project..CovidVaccinations as cv
on cv.location=cd.location and cv.date=cd.date
where cd.continent is not null
--order by 2,3
)
select *,(rollingtotal/popultion)*100 from popvsvac;



