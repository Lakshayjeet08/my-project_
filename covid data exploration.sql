select * ,
  from `inspiring-team-364113.portfolio_project.covid_deaths`
  order by 3,4
  limit 50; 
--   -- select the data that we are going to use;

Select  location,date,total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from `inspiring-team-364113.portfolio_project.covid_deaths`
where location = "India"
-- group by location
order by 1,2;

-- total case in india  vs total population in india 

Select location,date,total_cases,population, (total_cases/population)*100 as affected_percentage
from `inspiring-team-364113.portfolio_project.covid_deaths`
where location = "India"
-- group by location
order by 1,2;

-- looking at the countries with highest no of covid cases 

Select location, max(total_cases) as highestinfected, max((total_cases/population)*100) as infected_population
from `inspiring-team-364113.portfolio_project.covid_deaths`
group by location ,population
order by highestinfected desc;

-- showing countries highest death count

Select location, max(total_deaths) as deathcount
from `inspiring-team-364113.portfolio_project.covid_deaths`
where continent is not null
group by location ,population
order by deathcount desc;

-- showing continents with highest death counts 

Select location, max(total_deaths) as deathcount
from `inspiring-team-364113.portfolio_project.covid_deaths`
where continent is  null
group by location
order by deathcount desc;

-- global numbers 

Select  date ,sum(new_cases) as total_case ,sum(new_deaths)as total_deaths , (sum(new_deaths)/sum(new_cases))*100 as death_percentage
from `inspiring-team-364113.portfolio_project.covid_deaths`
where continent is  null
and new_cases != 0
group by date 
order by 1,2;

select dea.location, dea.date ,new_vaccinations,dea.population,dea.continent, sum(vac.new_vaccinations)over(partition by dea.location order by dea.date ,dea.location)as RollingPopulationVaccinated,
-- (RollingPopulationVaccinated/population)*100 as vaccinated_population
from `inspiring-team-364113.portfolio_project.covid_deaths`dea
join `inspiring-team-364113.portfolio_project.covid_vacc`vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null 
order by 1,2,3;

-- creating cte to create total percentage of population vaccinated 
-- popvsvacc
With PopvsVac  as (
  select dea.location, dea.date ,vac.new_vaccinations,dea.population,dea.continent, sum(vac.new_vaccinations)over(partition by dea.location order by dea.date ,dea.location)as RollingPopulationVaccinated
-- (RollingPopulationVaccinated/population)*100 as vaccinated_population
from `inspiring-team-364113.portfolio_project.covid_deaths`dea
join `inspiring-team-364113.portfolio_project.covid_vacc`vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null 
order by 1,2,3
)
select*,(RollingPopulationVaccinated/population)*100 as vaccinated_population
from popvsvac;

-- creating view 
 create view inspiring-team-364113.portfolio_project.PercentPopulationVaccinated as 
select dea.location, dea.date ,vac.new_vaccinations,dea.population,dea.continent, sum(vac.new_vaccinations)over(partition by dea.location order by dea.date ,dea.location)as RollingPopulationVaccinated
-- (RollingPopulationVaccinated/population)*100 as vaccinated_population
from `inspiring-team-364113.portfolio_project.covid_deaths`dea
join `inspiring-team-364113.portfolio_project.covid_vacc`vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
;

