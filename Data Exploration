SELECT * 
FROM PortfolioProject..CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT * 
--FROM PortfolioProject..CovidVaccinations$
--ORDER BY 3,4

-- Select Data that we are going to be using

SELECT location,date,total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths$ 
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths
-- Shows chance of death if an individual contracted COVID-19 in your country

SELECT location,date,total_cases, total_deaths,(Total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$ 
WHERE location like  '%states%'
ORDER BY 1,2


-- Looking @ Total Cases vs population
-- Displays the percentage of population with COVID-19

SELECT location,date,total_cases, population,(total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths$ 
WHERE location like '%states%'
ORDER BY 1,2

-- Looking at Countries w/ Highest Infection Rate compared to Population
SELECT location,population,MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths$ 
--WHERE location like '%states%'
GROUP BY location,population
ORDER BY PercentPopulationInfected DESC




-- BREAKING THINGS DOWN BY CONTINENT

-- Showing continents with the highest death count per population

SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
--WHERE location like '%states%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- Global Numbers

 SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(New_deaths as int))/SUM(New_Cases)*100 AS DeathPercentage--, total_deaths,(Total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$ 
WHERE location like  '%states%'
--GROUP BY date
ORDER BY 1,2

--Looking at total population vs vacccinations

SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER(Partition by dea.location ORDER BY dea.location, dea.date) 
AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3
	

-- USING A CTE

WITH PopvsVac (Continent, Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER(Partition by dea.location ORDER BY dea.location, dea.date) 
AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)

SELECT * , (RollingPeopleVaccinated/population)*100
FROM PopvsVac


--TEMP TABLE

CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric,
)


INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER(Partition by dea.location ORDER BY dea.location, dea.date) 
AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT * , (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated

-- Creating Views to store for later visualizations

Create View PercentagePopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER(Partition by dea.location ORDER BY dea.location, dea.date) 
AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT * FROM
PercentagePopulationVaccinated

CREATE VIEW HighestContinentDeathCounts AS 
SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
--WHERE location like '%states%'
WHERE continent IS NOT NULL
GROUP BY continent

SELECT * FROM HighestContinentDeathCounts

CREATE VIEW CountryInfectionRatevsPop AS
SELECT location,population,MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths$ 
--WHERE location like '%states%'
GROUP BY location,population

SELECT * FROM CountryInfectionRatevsPop

