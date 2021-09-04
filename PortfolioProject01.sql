--Select all from two tables that I imported to verify my data 
SELECT *
FROM PortfolioProject01..CovidCases

SELECT *
FROM PortfolioProject01..CovidVaccinations

--QUERRYING CASES TABLE FIRST 

--Select important data I am going to use 

--access necessary columns 

SELECT location, date, total_cases, new_cases, population 
FROM PortfolioProject01..CovidCases
ORDER BY 1, 2

--Look at Total cases vs Total Deaths

--Look at the percentages of deaths per total cases for each country every date

SELECT location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as PctDeathCases
FROM PortfolioProject01..CovidCases
ORDER BY 1, 2 

--showing likelihood of dying if contracted covid19 for the USA and Rwanda separately 

SELECT location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as PctDeathCases
FROM PortfolioProject01..CovidCases
WHERE location like '%states%'
ORDER BY 1, 2 

SELECT location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as PctDeathCases
FROM PortfolioProject01..CovidCases
WHERE location = 'Rwanda'
ORDER BY 1, 2 

--showing what percentage of population got covid in the USA and Rwanda separately 

SELECT location, date, total_cases, population, 
(total_cases/population)*100 as CasesPercentage
FROM PortfolioProject01..CovidCases
WHERE location like '%states%'
ORDER BY 1, 2

SELECT location, date, total_cases, population, 
(total_cases/population)*100 as CasesPercentage
FROM PortfolioProject01..CovidCases
WHERE location like '%rwanda%'
ORDER BY 1, 2 

--Looking at TOP 20 countries with the HIGHEST rate of infection based on the population

SELECT TOP 20 location, population, MAX(total_cases) as HighestCasesCount, 
MAX((total_cases/population))*100 as PercentagePopulationInfected
FROM PortfolioProject01..CovidCases
GROUP BY location, population
ORDER BY PercentagePopulationInfected DESC

--Looking at TOP 20 countries with the HIGHEST total number of infections
SELECT TOP 20 location, MAX(total_cases) as HighestCasesCount
FROM PortfolioProject01..CovidCases
WHERE continent is not null 
--Location contained continents in my dataset with null values in corresponding continent fields
GROUP BY location
ORDER BY HighestCasesCount DESC

--Looking at 10 countries with the LOWEST total number of infections
SELECT TOP 10 location, MAX(total_cases) as HighestCasesCount
FROM PortfolioProject01..CovidCases
WHERE continent is not null 
GROUP BY location
ORDER BY HighestCasesCount ASC

--Looking at countries without any single case
SELECT location, population, MAX(total_cases) as HighestCasesCount
FROM PortfolioProject01..CovidCases
WHERE MAX(total_cases) is null
GROUP BY location, population
ORDER BY 1, 2

--Looking at TOP 20 countries with the HIGHEST total number of Deaths compared to population
SELECT TOP 20 location, population, MAX(CONVERT(int,total_deaths)) as HighestDeathsCount, 
MAX((total_cases/population))*100 as PercentagePopulationDied
FROM PortfolioProject01..CovidCases
GROUP BY location, population
ORDER BY PercentagePopulationDied DESC

--Looking at TOP 20 countries with the HIGHEST total number of Deaths
SELECT TOP 20 location, MAX(Cast(total_deaths as int)) as HighestDeathsCount
FROM PortfolioProject01..CovidCases
WHERE continent is not null 
GROUP BY location
ORDER BY HighestDeathsCount DESC

--Looking at TOP 20 countries with the LOWEST total number of Deaths
SELECT TOP 20 location, MAX(Cast(total_deaths as int)) as HighestDeathsCount
FROM PortfolioProject01..CovidCases
WHERE continent is not null 
GROUP BY location
ORDER BY HighestDeathsCount ASC

--Looking at TOP 20 African countries with the Highest number of deaths
SELECT TOP 20 continent, location, MAX(Cast(total_deaths as int)) as HighestDeathsCount
FROM PortfolioProject01..CovidCases
WHERE continent like '%africa%'
GROUP BY continent,location
ORDER BY HighestDeathsCount DESC

--Looking at TOP 20 African countries with the HIGHEST total number of infections
SELECT TOP 20 continent, location, MAX(total_cases) as HighestCasesCount
FROM PortfolioProject01..CovidCases
WHERE continent = 'africa'
GROUP BY continent, location
ORDER BY HighestCasesCount DESC

--HOW ABOUT BREAKING DEATHS AND CASES BY CONTINENTS RESPECTIVELY? 

SELECT continent, MAX(Cast(total_deaths as int)) as HighestDeathsCount
FROM PortfolioProject01..CovidCases
WHERE continent is not null 
GROUP BY continent
ORDER BY HighestDeathsCount DESC

SELECT continent, MAX(total_cases) as HighestCasesCount
FROM PortfolioProject01..CovidCases
WHERE continent is not null 
GROUP BY continent
ORDER BY HighestCasesCount 


SELECT continent, SUM(new_cases) as total_cases
FROM PortfolioProject01..CovidCases
WHERE continent is not null 
GROUP BY continent
ORDER BY total_cases DESC


--logically that's how I would go for grouping by continents but an issue with dataset has been detected
--So the correct way to go with this querry is down below

SELECT location, MAX(Cast(total_deaths as int)) as HighestDeathsCount
FROM PortfolioProject01..CovidCases
WHERE continent is null 
GROUP BY location
ORDER BY HighestDeathsCount DESC

SELECT location, MAX(total_cases) as HighestCasesCount
FROM PortfolioProject01..CovidCases
WHERE continent is null 
GROUP BY location
ORDER BY HighestCasesCount DESC


SELECT location, SUM(new_cases) as total_cases, SUM(Cast(new_deaths as int)) as total_deaths
FROM PortfolioProject01..CovidCases
WHERE continent is null 
GROUP BY location
ORDER BY total_cases DESC


--Studying the most daily new cases and new deaths per each country 

SELECT location, MAX(new_cases) as HighestDayCases
FROM PortfolioProject01..CovidCases
WHERE continent is not null 
GROUP BY location
ORDER BY HighestDayCases DESC

SELECT location, MAX(CONVERT(int, new_deaths)) as HighestDayDeaths
FROM PortfolioProject01..CovidCases
WHERE continent is not null 
GROUP BY location
ORDER BY 2 DESC

--TAKING A LOOK AT GLOBAL NUMBERS 

-- Global Daily Cases and Deaths
SELECT date, SUM(new_cases) as TotalCases,
SUM(Cast(new_deaths as int)) as TotalDeaths, SUM(Cast(new_deaths as int))/SUM(new_cases)*100 as DeathPct
FROM PortfolioProject01..CovidCases
WHERE continent is not null 
GROUP BY date
ORDER BY 1 

--Overall Global total cases and deaths
SELECT SUM(new_cases) as TotalCases,
SUM(Cast(new_deaths as int)) as TotalDeaths, SUM(Cast(new_deaths as int))/SUM(new_cases)*100 as DeathPct
FROM PortfolioProject01..CovidCases
WHERE continent is not null 
--GROUP BY date
ORDER BY 1 


--BRINGING VACCINATIONS TABLE INTO ACTIONS TOO

--Joining the two tables on date and location
--and look at total population vs vaccinations

SELECT cas.continent, cas.location, cas.date, vac.new_vaccinations
FROM PortfolioProject01..CovidCases cas
JOIN PortfolioProject01..CovidVaccinations vac
	ON cas.date = vac.date 
	and cas.location = vac.location
WHERE vac.new_vaccinations is not null
and cas.continent is not null
ORDER BY 1,2,3

--Looking at total vaccinations each day for every country
SELECT location, date, total_vaccinations
FROM PortfolioProject01..CovidVaccinations
WHERE total_vaccinations is not null 
and continent is not null
ORDER BY 1,2

--Getting the rolling count of new vaccinations by countries (kind of accumulations by vaccinations, right?)

SELECT cas.continent, cas.location, cas.date, cas.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by cas.location ORDER BY cas.location, cas.date)
as rolling_vaccinations_count
FROM PortfolioProject01..CovidCases cas
JOIN PortfolioProject01..CovidVaccinations vac
	ON cas.date = vac.date 
	and cas.location = vac.location
WHERE vac.new_vaccinations is not null
and cas.continent is not null
ORDER BY 1

--Getting the percentage of Rolling vaccinated people over total population of each country
--looks like a CTE is needed here 

with populationVsVactions(continent, location, date, population, new_vaccinations, rolling_vaccinations_count)
as
(
SELECT cas.continent, cas.location, cas.date, cas.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) 
OVER (Partition by cas.location ORDER BY cas.location, cas.date)
as rolling_vaccinations_count
FROM PortfolioProject01..CovidCases cas
JOIN PortfolioProject01..CovidVaccinations vac
	ON cas.date = vac.date 
	and cas.location = vac.location
WHERE vac.new_vaccinations is not null
and cas.continent is not null
)
SELECT *, (rolling_vaccinations_count/population)*100
as PctVaccinatedPeople
FROM populationVsVactions

--Trying to get quiet the same result by using a TEMP TABLE
DROP TABLE IF exists #PercentVaccinatedPeople
CREATE TABLE #PercentVaccinatedPeople
(continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 rolling_vaccinations_count numeric
)

INSERT INTO #PercentVaccinatedPeople
SELECT cas.continent, cas.location, cas.date, cas.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) 
OVER (Partition by cas.location ORDER BY cas.location, cas.date)
as rolling_vaccinations_count
FROM PortfolioProject01..CovidCases cas
JOIN PortfolioProject01..CovidVaccinations vac
	ON cas.date = vac.date 
	and cas.location = vac.location
WHERE vac.new_vaccinations is not null
and cas.continent is not null

SELECT *, (rolling_vaccinations_count/population)*100
as PercentVaccinatedPeople
FROM #PercentVaccinatedPeople

--Thinking of creating a view to store data for later vizualization?? Let's do it!!! 

CREATE VIEW PercentVaccinatedPeople as
SELECT cas.continent, cas.location, cas.date, cas.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by cas.location ORDER BY cas.location, cas.date)
as rolling_vaccinations_count
FROM PortfolioProject01..CovidCases cas
JOIN PortfolioProject01..CovidVaccinations vac
	ON cas.date = vac.date 
	and cas.location = vac.location
WHERE vac.new_vaccinations is not null
and cas.continent is not null

SELECT *, (rolling_vaccinations_count/population)*100
as PercentVaccinatedPeople
FROM PercentVaccinatedPeople
--The view can be deleted (cleared) since it's stored permanently... it's not like a TEMP table 
--But for the sake of this portfolio, I will leave it here 