--create extension if not exists plpython3u;

-- number of countries per continent
do $$ 

import pandas as pd
import matplotlib.pyplot as plt

query = """
select continent, count(*) as num_countries
from countries
group by continent
order by num_countries"""

result = plpy.execute(query)

data = pd.DataFrame([dict(row) for row in result])

fig, ax = plt.subplots(figsize=(10, 8))
ax.barh(y='continent', width='num_countries', data=data)
ax.set_title('The Number of Countries in Each Continent')
ax.set_xlabel('Number of countries')
plt.tight_layout()
plt.savefig('/Users/yingliu/Documents/GitHub/World_Cities_Countries_and_Languages/outputs/The_number_of_countries_per_continent.png', dpi=300, transparent=True)

$$ language plpython3u;



-- population density per continent
do $$ 

import pandas as pd
import matplotlib.pyplot as plt

query = """
select continent, sum(population)/sum(surface_area) as population_density
from countries
group by continent
order by population_density"""

result = plpy.execute(query)

data = pd.DataFrame([dict(row) for row in result])

fig, ax = plt.subplots(figsize=(10, 8))
ax.barh(y='continent', width='population_density', data=data)
ax.set_title('The Population Density in Each Continent')
ax.set_xlabel('Population density')
plt.tight_layout()
plt.savefig('/Users/yingliu/Documents/GitHub/World_Cities_Countries_and_Languages/outputs/The_population_density_per_continent.png', dpi=300, transparent=True)

$$ language plpython3u;



-- average gnp per country in each continent
do $$ 

import pandas as pd
import matplotlib.pyplot as plt

query = """
select continent, sum(gnp)/count(*) as avg_gnp
from countries
group by continent
order by avg_gnp"""

result = plpy.execute(query)

data = pd.DataFrame([dict(row) for row in result])

fig, ax = plt.subplots(figsize=(10, 8))
ax.barh(y='continent', width='avg_gnp', data=data)
ax.set_title('The Average gnp per Country in Each Continent')
ax.set_xlabel('Average gnp (millions of USD)')
plt.tight_layout()
plt.savefig('/Users/yingliu/Documents/GitHub/World_Cities_Countries_and_Languages/outputs/The_average_gnp_per_country_in_each_continent.png', dpi=300, transparent=True)

$$ language plpython3u;



-- the top 10 countries with the highest number of languages
do $$

import pandas as pd
import matplotlib.pyplot as plt

query = """
select c.name as country, count(l.language) as total_languages
from countries c 
join country_languages l on c.code=l.country_code 
group by c.name
order by total_languages desc
limit 10
"""

result = plpy.execute(query)

data = pd.DataFrame([dict(row) for row in result])

fig, ax = plt.subplots(figsize=(10, 8))
ax.barh(y='country', width='total_languages', data=data)
ax.set_title('The Top 10 Countries with the Highest Number of Languages')
ax.set_xlabel('Total languages spoken in the country')
plt.tight_layout()
plt.savefig('/Users/yingliu/Documents/GitHub/World_Cities_Countries_and_Languages/outputs/The_top_10_countries_with_the_most_languages.png', dpi=300, transparent=True)

$$ language plpython3u;


-- calculate and plot the top10 most spoken languages
do $$

import pandas as pd
import matplotlib.pyplot as plt

query = """
select cl.language , sum(cl.percentage * c.population / 100) as spoken_by
from countries c
left join country_languages cl 
on c.code = cl.country_code
group by cl.language 
having cl.language is not null
order by spoken_by desc
limit 10
"""

result = plpy.execute(query)

data = pd.DataFrame([dict(row) for row in result])

fig, ax = plt.subplots(figsize=(10, 8))
ax.barh(y='language', width='spoken_by', data=data)
ax.set_title('The Top 10 Most Spoken Languages')
ax.set_xlabel('Total number of people spoken the language')
ax.set_xscale('log')
plt.tight_layout()
plt.savefig('/Users/yingliu/Documents/GitHub/World_Cities_Countries_and_Languages/outputs/The_top_10_most_spoken_languages.png', dpi=300, transparent=True)

$$ language plpython3u;