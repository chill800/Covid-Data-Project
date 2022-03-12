--Select the data we will be using

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..['owid-covid-data$']
order by 1, 2

--Looking at total cases vs totat deaths in United States
--Shows the likihood of death if contracting Covid in the United States

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as [Rate of Deaths]
from PortfolioProject..['owid-covid-data$']
where location like '%states%'
order by 1, 2

--Looking at total cases vs population
--Shows the percentage of population contracting covid

Select location, date, total_cases, population, (total_cases/population)*100 as [Rate of Infection]
from PortfolioProject..['owid-covid-data$']
where location like '%states%'
order by 1, 2

--Which country had the highest infection rate?

Select location, population, MAX(total_cases) as [Highest Infection], MAX((total_cases/population))*100 as [Infection Rate]
from PortfolioProject..['owid-covid-data$']
where continent is not null
group by location, population
order by 1 desc

--Showing continent with the highest death count per population

Select continent, MAX(cast(total_deaths as int)) as [Most Deaths]
from PortfolioProject..['owid-covid-data$']
Where continent is not null
group by continent
order by 2 desc

--Showing the countries with the highest death count
Select location, MAX(cast(total_deaths as int)) as [Most Deaths]
from PortfolioProject..['owid-covid-data$']
Where continent is not null
group by location
order by 2 desc


--Creating a view for to store countries with the highest death count

create view HighestDeathcount as
Select continent, MAX(cast(total_deaths as int)) as [Most Deaths]
from PortfolioProject..['owid-covid-data$']
Where continent is not null
group by continent
