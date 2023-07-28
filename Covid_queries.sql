-- Covid related queries  (2020 - 2023)

select * 
from PortfolioProject.dbo.CovidDeaths

-- Percentage of population that were covid infected 

select location, population, MAX(total_cases) as HighestInfectionCount, MAX(cast(total_cases as int)/ population)*100 AS PercentInfectedPopulation
from PortfolioProject.dbo.CovidDeaths
group by location, population
order by PercentInfectedPopulation desc


-- Countries with highest Infection rate compared to population 

select location, population, MAX(total_cases) AS HighestContractionCount, MAX((cast(total_cases as float)/ population)*100) AS ContractionPercent
from PortfolioProject.dbo.CovidDeaths
group by location, population
order by ContractionPercent desc
 
 -- breaking down total death counts around the world under differnet segments

 select location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
 from PortfolioProject.dbo.CovidDeaths
 where continent is null
 group by location
 order by TotalDeathCount desc

 --continents with highest death count per population

select continent, MAX(total_deaths) AS HighestDeathCount
from PortfolioProject.dbo.CovidDeaths
where continent is not null
group by continent
order by HighestDeathCount desc


-- Total death counts categorized between various continents
-- Excluding the european union for not including the numbers of the EU countries.
-- Excluding locations categorized into their income status

select location, SUM(cast(new_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
and location not in ('World', 'European Union', 'International','High income', 'Upper middle income', 'Lower middle income', 'Low income')
Group by location
order by TotalDeathCount desc

-- Global Numbers

select  SUM(new_cases) AS Total_cases, SUM(new_deaths) AS Total_deaths, SUM(new_deaths)/nullif(SUM(new_cases),0)*100 AS DeathPercentage
from PortfolioProject.dbo.CovidDeaths
-- where location = 'United States'
where continent is not null
order by 1,2 

-- Total population vs Vaccinations (JOIN tables)

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
from PortfolioProject.dbo.CovidDeaths as dea
join PortfolioProject.dbo.CovidVaccinations as vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Use of CTE (common table expression) for rolling population count

With PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated ) 
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from PortfolioProject.dbo.CovidDeaths as dea
join PortfolioProject.dbo.CovidVaccinations as vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated/Population)*100  
from PopvsVac


-- Temporary Table

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
from PortfolioProject.dbo.CovidDeaths as dea
join PortfolioProject.dbo.CovidVaccinations as vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select *, (RollingPeopleVaccinated/Population)*100  
from #PercentPopulationVaccinated

-- Creating view for storing data for visualisation

create view VaccinePercentPopulation AS
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
from PortfolioProject.dbo.CovidDeaths as dea
join PortfolioProject.dbo.CovidVaccinations as vac 
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

-- selecting all data from the temp table 

select *
from VaccinePercentPopulation;


-- Location, population and date included highest infection rate

select location, population, date, MAX(total_cases) as HighestInfectionCount, MAX(cast(total_cases as int)/ population)*100 AS PercentInfectedPopulation
from PortfolioProject.dbo.CovidDeaths
group by location, population, date
order by PercentInfectedPopulation desc
