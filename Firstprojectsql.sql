/*select * from firstpro1.coviddeaths
order by 3,4;


select * from firstpro1.covidvaccinations
order by 3,4;*/

# select data that we are going to use

select location,date,total_cases,new_cases,total_deaths,population
from firstpro1.coviddeaths
order by 1,2;


# looking at total cases vs total death
# showing likelihood of daying if you contract ovid  to your country

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathprecentage
from firstpro1.coviddeaths
where location like "%states%"
order by 1,2;


# looking at Total cases vs populations
#shows how many population got coved 

select location,date,total_cases,population,(total_cases/population)*100 as Precentegepopulationinfected
from firstpro1.coviddeaths
#where location like "%states%"
order by 1,2;


#looking at countries with highest infecation rate compared to populations 

select location,population,max(castotal_cases) as highestinfectioncountry,max((total_cases/population))*100 as Precentegepopulationinfected
from firstpro1.coviddeaths
group by location,population
order by Precentegepopulationinfected desc;

#showing countries with highest Death count per populations

select location,max(cast(total_deaths as unsigned)) as Totaldeathcount
from firstpro1.coviddeaths
where continent is not null
group by location
order by Totaldeathcount desc;

#Let's break things downs by continent


#showing continents with highest death count

select location,max(cast(total_deaths as signed)) as Totaldeathcount
from firstpro1.coviddeaths
where continent is not  null
group by location
order by Totaldeathcount desc;

#Global Numbers

select date,sum(total_cases),sum(cast(new_deaths as signed)) as totaldeaths,(sum(cast(new_deaths as signed))/sum(total_cases))*100 as Deathprecentage
from firstpro1.coviddeaths
#where location like "%states%"
where continent is not null
group by date
order by 1,2;

#Looking at Total populations vs vaccinations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as signed))  OVER (partition by dea.location order by dea.location,dea.date) as RollingPeoplevaccineted
from firstpro1.coviddeaths dea
join firstpro1.covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3
;


#use CTE
with popvsVac (continent,Location,Date,population,new_vaccinations,RollingPeoplevaccineted)
as(select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as signed))  OVER (partition by dea.location order by dea.location,dea.date) as RollingPeoplevaccineted
from firstpro1.coviddeaths dea
join firstpro1.covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
#order by 2,3
)

select *,(RollingPeoplevaccineted/population)*100
 from popvsVac;


#Creating view to store the data for later visulaizations

create view RollingPeoplevaccineted as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as signed))  OVER (partition by dea.location order by dea.location,dea.date) as RollingPeoplevaccineted
from firstpro1.coviddeaths dea
join firstpro1.covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
#order by 2,3




