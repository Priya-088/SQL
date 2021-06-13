--Using the CovidDeath table
SELECT * 
FROM CovidAnalysis..CovidDeaths$;

SELECT * 
FROM CovidAnalysis..CovidDeaths$ --Ordering by location and date
ORDER BY 3,4;  --Here some of the locations are continent names like 'world','Asia',South  America' ect
--and where the location is 'world','Asia',South  America', the Continent column is Null so filter where the continent is
--not null to get location as only countries

SELECT * 
FROM CovidAnalysis..CovidDeaths$ --Ordering by location and date
WHERE continent is not null
ORDER BY 3,4;

SELECT * 
FROM CovidAnalysis..CovidVaccinations$ --Ordering by location and date
ORDER BY 3,4;

--Selecting the data which we are using
SELECT location,date,total_cases,new_cases,total_deaths,population
FROM CovidAnalysis..CovidDeaths$
ORDER BY 1,2;  --Ordering by location and date

--Looking at Total cases vs Total Deaths (Deaths to cases ratio)
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
FROM CovidAnalysis..CovidDeaths$
ORDER BY 1,2;
--Looking for location= United States
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
FROM CovidAnalysis..CovidDeaths$
WHERE location like '%states'
ORDER BY 1,2;
--DeathPercentage for India
--Showing the likelihood of dying if you contract covid in India
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
FROM CovidAnalysis..CovidDeaths$
WHERE location='India'
ORDER BY 1,2;  --Has DeathPercentage=1.25 by June 11th 2021

--Looking for Total cases vs Population
--Shows what % of population has been effected by covid
SELECT location,date,population,total_cases,(total_cases/population)*100 as total_case_Percentage
FROM CovidAnalysis..CovidDeaths$
WHERE location like '%states'
ORDER BY 1,2;
--Shows what % of population has been effected by covid in India
SELECT location,date,population,total_cases,(total_cases/population)*100 as total_case_Percentage
FROM CovidAnalysis..CovidDeaths$
WHERE location='India'
ORDER BY 1,2;
--Has it is known that India has a very peak infection in the year 2021 than 2020 with total_cases_percentage 
--being 2.12 by June 11th 2021


--Looking for the countries with highest Infection rate compared to population
SELECT location,population,MAX(total_cases) AS HighestInfectionCount,MAX((total_cases/population))*100 as total_case_Percentage
FROM CovidAnalysis..CovidDeaths$
GROUP BY location,population
ORDER BY total_case_Percentage DESC;

--Showing the highest Death Count per population by Continent
SELECT continent,MAX(CAST(total_deaths AS int)) as TotalDeathCount
FROM CovidAnalysis..CovidDeaths$
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount Desc  --These are not the accurate as we compare to values from internet and missing some continents

--So checking the above query where continent is null and grouping by location
SELECT location,MAX(CAST(total_deaths AS int)) as TotalDeathCount
FROM CovidAnalysis..CovidDeaths$
WHERE continent is null  --Actually where continent is null location column has continent names
GROUP BY location
ORDER BY TotalDeathCount Desc

--Showing the highest Death Count per population by location
SELECT location,MAX(CAST(total_deaths AS int)) as TotalDeathCount
FROM CovidAnalysis..CovidDeaths$
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount Desc  --Here we are grouping by location but some of the records has location as 'world','Asia','South America
--so filtering the data where continent is not null


--Global numbers(means not grouping by location or continent
SELECT date,SUM(new_cases)as Total_cases, SUM(CAST(new_deaths as int)) as Total_deaths ,
SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM CovidAnalysis..CovidDeaths$
WHERE continent is not null
GROUP BY date 
ORDER BY 1,2;

--Looking for the entire world
SELECT SUM(new_cases)as Total_cases, SUM(CAST(new_deaths as int)) as Total_deaths ,
SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM CovidAnalysis..CovidDeaths$
WHERE continent is not null

--Using the Vaccination table
SELECT * FROM CovidAnalysis..CovidVaccinations$
--Combining the CovidDeaths and vaccination table
SELECT * 
FROM CovidAnalysis..CovidDeaths$ dea
join CovidAnalysis..CovidVaccinations$ vac
on dea.location=vac.location and
dea.date=vac.date

--Looking at total population vs vaccination
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations 
FROM CovidAnalysis..CovidDeaths$ dea
join CovidAnalysis..CovidVaccinations$ vac
on dea.location=vac.location and
dea.date=vac.date
WHERE dea.continent is not null
ORDER BY 2,3;

--To know the total new vaccinations for each location and number of people got vaccinated in each country(location)
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
SUM(CONVERT(INT,vac.new_vaccinations)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccination,
FROM CovidAnalysis..CovidDeaths$ dea
join CovidAnalysis..CovidVaccinations$ vac
on dea.location=vac.location and
dea.date=vac.date
WHERE dea.continent is not null
ORDER BY 2,3;

----To know the total new vaccinations for each location and number of people got vaccinated in each country(location) using CTE
WITH PopVac (Continent,Location,Date,Population,New_Vacinations,RollingPeopleVaccination)
AS
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
SUM(CONVERT(INT,vac.new_vaccinations)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccination
FROM CovidAnalysis..CovidDeaths$ dea
join CovidAnalysis..CovidVaccinations$ vac
on dea.location=vac.location and
dea.date=vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT *,(RollingPeopleVaccination/Population)*100
FROM PopVac
--SELECT * FROM PopVac

--The above process can be done using a TEMP TABLE(new table)
--Creating a table

DROP TABLE IF EXISTS PercentPopulationVaccinated
CREATE TABLE PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(225),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccination numeric
)
--Inserting data into the above table
INSERT INTO PercentPopulationVaccinated
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
SUM(CONVERT(numeric,vac.new_vaccinations)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccination
FROM CovidAnalysis..CovidDeaths$ dea
join CovidAnalysis..CovidVaccinations$ vac
on dea.location=vac.location and
dea.date=vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3

SELECT * FROM PercentPopulationVaccinated

SELECT *,(RollingPeopleVaccination/Population)*100
FROM PercentPopulationVaccinated

--Creating a view for later visualisation
CREATE VIEW PopulationVaccinated
as
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
SUM(CONVERT(numeric,vac.new_vaccinations)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccination
FROM CovidAnalysis..CovidDeaths$ dea
join CovidAnalysis..CovidVaccinations$ vac
on dea.location=vac.location and
dea.date=vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT * FROM PopulationVaccinated;
