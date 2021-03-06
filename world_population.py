# mapping global data sets json format
import json
import pygal
from pygal.style import RotateStyle as RS  # for changing color
from pygal.style import LightColorizedStyle as LCS  # for lightening color theme

from country_codes import get_country_code

# load the data into a list
filename = 'population_data.json'
with open(filename) as f:
    pop_data = json.load(f)

# build a dictionary of population data
cc_populations = {}
for pop_dict in pop_data:
    if pop_dict['Year'] == '2010':
        country_name = pop_dict['Country Name']
        # convert into numerical value
        population = int(float(pop_dict['Value']))
        code = get_country_code(country_name)
        if code:
            cc_populations[code] = population
        else:
            print('error' + country_name)

# group countries into three population levels to offer more contrast
cc_pops_1, cc_pops_2, cc_pops_3 = {}, {}, {}
for cc, pop in cc_populations.items():
    if pop < 10000000:
        cc_pops_1[cc] = pop
    elif pop < 1000000000:
        cc_pops_2[cc] = pop
    else:
        cc_pops_3[cc] = pop

# see how many countries are in each level
print(len(cc_pops_1), len(cc_pops_2), len(cc_pops_3))

# adjust colors
wm_style = RS('#226699', base_style=LCS)
wm = pygal.maps.world.World(style=wm_style)

wm = pygal.maps.world.World()
wm.title = 'World Population in 2010, by Country'
wm.add('0-10m', cc_pops_1)
wm.add('10m-1b', cc_pops_2)
wm.add('>1bn', cc_pops_3)

wm.render_to_file('world_population.svg')

# raw data = inconsistent so often times, decimal can't be stored as integer
# in these instances, change to float then change to integer
# float turns string into decimal. int drops the decimal and returns int
