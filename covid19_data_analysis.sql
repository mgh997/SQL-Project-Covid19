*.sql linguist-language=SQL
*.sql linguist-detectable=true
*.csv linguist-detectable=false

Select *
From PortfolioProject..CovidDeaths
WHERE continent <> ' '
order by 3, 4

--Select *
--From PortfolioProject..CovidVaccinations
--order by 3, 4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
WHERE continent <> ' '
order by 1, 2


-- Looking at Tota Cases vc Total Deaths
-- Shows liklihood of dying if someone contracts covid in their country (eg: USA)

Select Location, date, total_cases, total_deaths, (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent <> ' '
order by 1, 2


-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

Select Location, date, population, total_cases, (CAST(total_cases AS FLOAT) / NULLIF(CAST(population AS FLOAT), 0))*100 as PopulationInfectedPercentage
From PortfolioProject..CovidDeaths
-- Where location like '%states%'
order by 1, 2


-- Looking at Countries with highest Infection Rate compared to their Population

Select Location, population, MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount,
    MAX(CAST(total_cases AS FLOAT) / NULLIF(CAST(population AS FLOAT), 0) * 100) as PopulationInfectedPercentage
From PortfolioProject..CovidDeaths
-- Where location like '%states%'
Group by location, population
order by PopulationInfectedPercentage DESC



-- Showing Countries with Highest Death Count per Population

Select Location, MAX(CAST(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
WHERE continent <> ' '
Group by location
order by TotalDeathCount DESC



-- LET'S BREAK THINGS DOWN BY CONTINENT

-- Showing the Continents with the highest Death count per Population
Select continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
WHERE continent <> ' '
Group by continent
order by TotalDeathCount DESC

Select location, MAX(CAST(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
WHERE continent = ' ' OR continent IS NULL
Group by location
order by TotalDeathCount DESC





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
SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent <> ' '
order by 2, 3


-- Use CTE
With PopVsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent <> ' '
--order by 2, 3
)
Select * 
From PopVsVac



-- Create View to store Data for later Visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent <> ' '
--order by 2, 3

Select *
From PercentPopulationVaccinated