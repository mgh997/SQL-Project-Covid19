
SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent <> ' '
ORDER BY 3, 4

SELECT *
FROM PortfolioProject..CovidVaccinations
ORDER BY 3, 4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent <> ' '
ORDER BY 1, 2


-- Looking at Tota Cases vc Total Deaths
-- Shows liklihood of dying if someone contracts covid in their country (eg: USA)

SELECT Location, date, total_cases, total_deaths, (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT))*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%states%'
and continent <> ' '
ORDER BY 1, 2


-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

SELECT Location, date, population, total_cases, (CAST(total_cases AS FLOAT) / NULLIF(CAST(population AS FLOAT), 0))*100 as PopulationInfectedPercentage
FROM PortfolioProject..CovidDeaths
-- Where location like '%states%'
ORDER BY 1, 2


	
-- Looking at Countries with highest Infection Rate compared to their Population

SELECT Location, population, MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount,
    MAX(CAST(total_cases AS FLOAT) / NULLIF(CAST(population AS FLOAT), 0) * 100) AS PopulationInfectedPercentage
FROM PortfolioProject..CovidDeaths
-- Where location like '%states%'
GROUP BY location, population
ORDER BY PopulationInfectedPercentage DESC



-- Showing Countries with Highest Death Count per Population

SELECT Location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent <> ' '
GROUP BY location
ORDER BY TotalDeathCount DESC



-- LET'S BREAK THINGS DOWN BY CONTINENT

-- Showing the Continents with the highest Death count per Population
SELECT continent, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent <> ' '
GROUP BY continent
ORDER BY TotalDeathCount DESC

SELECT location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent = ' ' OR continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC





-- GLOBAL NUMBERS PER DATE
	
SELECT date, SUM(CAST(new_cases AS FLOAT)) AS total_cases, SUM(CAST(new_deaths AS FLOAT)) AS total_deaths, (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent <> ' '
GROUP BY date
ORDER BY date;



SELECT SUM(CAST(new_cases AS INT)) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent <> ' ';



-- Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS int)) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent <> ' '
ORDER BY 2, 3


-- Use CTE
	
WITH PopVsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS int)) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent <> ' '
--order by 2, 3
)
SELECT * 
FROM PopVsVac



-- Create View to store Data for later Visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS int)) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent <> ' '
--order by 2, 3

	
SELECT *
FROM PercentPopulationVaccinated
