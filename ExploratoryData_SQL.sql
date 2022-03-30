--Queries used for the Tableau Project: Covid-19 Dashboard

--1: Show the total number of new cases, deaths and the death percentage

Select SUM(new_cases) as [Total Cases], SUM(cast(new_deaths as int)) as [Total Deaths], SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as [Death Percentage]
From PortfolioProject..['owid-covid-data$']
Where continent is not null
Order by 1, 2

--2: Shows the total count of deaths by continent

Select continent, SUM(cast(new_deaths as int)) as [Total Deaths]
From PortfolioProject..['owid-covid-data$']
Where continent is not null AND location not in ('World','European Union', 'International')
Group by continent
Order by [Total Deaths] desc

--3: What country has the highest infection rate?

Select location, population, MAX(total_cases) as [Number Infected], MAX((total_cases/population))*100 as [Percentage of Pop. Infected]
From PortfolioProject..['owid-covid-data$']
Group by location, population
Order by [Percentage of Pop. Infected] desc

--4

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..['owid-covid-data$']
Group by Location, Population, date
order by PercentPopulationInfected desc




--Creating a view for to store countries with the highest death count

create view HighestDeathcount as
Select continent, MAX(cast(total_deaths as int)) as [Most Deaths]
from PortfolioProject..['owid-covid-data$']
Where continent is not null
group by continent
