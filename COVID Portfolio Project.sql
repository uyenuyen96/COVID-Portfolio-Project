SELECT *
FROM Covid.CovidDeaths
WHERE continent IS NULL;


SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Covid.CovidDeaths
order by 1,2;


-- Looking at Total deaths vs Total cases
SELECT location, date, total_cases, total_deaths, (total_deaths/CovidDeaths.total_cases)*100 AS death_percentage
FROM Covid.CovidDeaths
WHERE location like '%state%'
order by 1,2;

-- Looking at Total cases vs Population
SELECT location, date, total_cases, population, (total_cases/CovidDeaths.population)*100 AS case_percentage
FROM Covid.CovidDeaths
WHERE location like '%state%'
order by 1,2;

-- Looking at Countries with Highest Infection Rate compared to Population
SELECT location,MAX(total_cases) AS highest_infection_count, population, MAX((total_cases/CovidDeaths.population))*100 AS infection_case_percentage
FROM Covid.CovidDeaths
GROUP BY location,population
order by  infection_case_percentage DESC;

-- Showing Countries with Highest Death Count by Location
SELECT location,MAX(total_deaths) AS total_death_count
FROM Covid.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
order by total_death_count DESC;

-- Let's break things down by Continent
SELECT continent,MAX(total_deaths) AS total_death_count
FROM Covid.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
order by total_death_count DESC;

-- Global numbers
SELECT SUM(new_cases), SUM(new_deaths),SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM Covid.CovidDeaths
WHERE continent IS NOT NULL
-- GROUP BY date
ORDER BY 1,2;


SELECT *
FROM Covid.CovidDeaths
JOIN Covid.CovidVaccinations
    ON CovidDeaths.location = CovidVaccinations.location
    AND CovidDeaths.date = CovidVaccinations.date;

-- Looking at Total Population vs Vaccinations
SELECT CovidDeaths.continent, CovidDeaths.location, CovidDeaths.population, CovidVaccinations.new_vaccinations, SUM(CovidVaccinations.new_vaccinations) OVER (PARTITION BY CovidDeaths.location ORDER BY CovidDeaths.location, CovidDeaths.date) as RollingPeopleVac
FROM Covid.CovidDeaths
JOIN Covid.CovidVaccinations
    ON CovidDeaths.location = CovidVaccinations.location
    AND CovidDeaths.date = CovidVaccinations.date
WHERE CovidDeaths.continent IS NOT NULL
ORDER BY 2,3;

-- Temp Table
CREATE TABLE PercentPopulationVac
(
   Continent nvarchar(255),
    Location nvarchar(255),
    Date datetime,
    Population numeric,
    RollingPeopleVac numeric
);

CREATE VIEW Covid.PercentagePopulationVac AS
SELECT CovidDeaths.continent,
       CovidDeaths.location,
       CovidDeaths.population,
       CovidVaccinations.new_vaccinations,
       SUM(CovidVaccinations.new_vaccinations) OVER (PARTITION BY CovidDeaths.location ORDER BY CovidDeaths.location, CovidDeaths.date) as RollingPeopleVac
FROM Covid.CovidDeaths
JOIN Covid.CovidVaccinations
    ON CovidDeaths.location = CovidVaccinations.location
    AND CovidDeaths.date = CovidVaccinations.date
WHERE CovidDeaths.continent IS NOT NULL;
-- ORDER BY 2,3