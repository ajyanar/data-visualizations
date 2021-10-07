setwd("~/Desktop/projects/cb_2018_us_county_5m")

# where to find data:
# https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.2018.html
# https://hudgis-hud.opendata.arcgis.com/datasets/HUD::location-affordability-index-v-3/about

# download necessary packages
pacman::p_load(pacman, tmap, tmaptools, sf, leaflet, ggplot2, dplyr, rgdal)

library("tmap")
library("tmaptools")
library("sf")
library("leaflet")
library("rgdal")

options(scipen = 999) # set to avoid scientific notation

# downloading shapefile
my_map <- st_read(dsn = ".", layer = "cb_2018_us_county_5m")

# both of these attributes are characters, thus must change to numeric
my_map$GEOID = as.numeric(my_map$GEOID) 
my_map$STATEFP = as.numeric(my_map$STATEFP)

# downloading and subsetting LA Data
df_csv <- read.csv("~/Desktop/projects/Location_Affordability_Index_v.3.csv")
df1 <- df_csv[c(1:11, 15:21, 26:31)]

# subsetting further to make faster to run 
georgia_data <- df1[ which(df1$STATE=='13'), ]
georgia_map <- my_map[which(my_map$STATEFP=='13'),]

# inner_join using shapefile's GEOID and LA's CNTY_FIPS
georgia_df <- inner_join(georgia_map, georgia_data, by = c("GEOID" = "CNTY_FIPS"))

# making all further maps interactive
tmap_mode("view")

# Examining Attributes of Georgia Counties
ggplot(georgia_df) +
  geom_sf(aes(fill = median_hh_income)) +
  scale_color_gradient(low = '#56b1f7', high = '#132b43') +
  labs( x = "Longitude", y = "Latitude", 
     title = "Median Household Income by County in Georgia")

# Median Household Income in Georgia
tm_shape(georgia_df) + 
  tm_polygons("median_hh_income", id = 'NAME', palette = "Greens") + 
  tm_layout(title = 'Median Household Income by County in Georgia')

# Percent Renters in Georgia
tm_shape(georgia_df) + 
  tm_polygons("pct_renters", id = 'NAME', palette = "Blues") + 
  tm_layout(title = 'Percent Renters by County in Georgia')

# Median Gross Rent in Georgia 
tm_shape(georgia_df) + 
  tm_polygons("median_gross_rent", id = 'NAME', palette = "Reds") + 
  tm_layout(title = 'Median Gross Rent by County in Georgia')

# subsetting and joining Idaho data
idaho_data <- df1[ which(df1$STATE=='16'), ]
idaho_map <- my_map[which(my_map$STATEFP=='16'),]
idaho_df <- inner_join(idaho_map, idaho_data, by = c("GEOID" = "CNTY_FIPS"))

# Household Income Idaho
tm_shape(idaho_df) + 
  tm_polygons("median_hh_income", id = 'NAME', palette = "Greens") + 
  tm_layout(title = 'Median Household Income by County in Idaho')

# Percent Renters Idaho
tm_shape(idaho_df) + 
  tm_polygons("pct_renters", id = 'NAME', palette = "Blues") +
  tm_layout(title = "Percent Renters by County in Idaho")

# Gross Rent Idaho
tm_shape(idaho_df) + 
  tm_polygons("median_gross_rent", id = 'NAME', palette = "Reds") +
  tm_layout(title = 'Median Gross Rent by County in Idaho')


# subsetting and joining California data
cali_data <- df1[which(df1$STATE=='6'),]
cali_map <- my_map[which(my_map$STATEFP=='6'),]
cali_df <- inner_join(cali_map, cali_data, by = c("GEOID" = "CNTY_FIPS"))

# Median Household Income California
tm_shape(cali_df) + 
  tm_polygons("median_hh_income", id = 'NAME', palette = "Greens") + 
  tm_layout(title = 'Median Household Income by County in California')

# Percent Renters California
tm_shape(cali_df) + 
  tm_polygons("pct_renters", id = 'NAME', palette = "Blues") +
  tm_layout(title = "Percent Renters by County in California")

# Median Gross Rent California
tm_shape(cali_df) + 
  tm_polygons("median_gross_rent", id = 'NAME', palette = "Reds") +
  tm_layout(title = 'Median Gross Rent by County in California')
