library(raster)     # functions for working with raster/vector data
library(sp)         # foundational spatial data package
library(rgdal)      # R interface to the C/C++ library gdal 
library(rgeos)      # R interface to vector processing library geos 
library(tidyverse)  
library(leaflet)      # R interface to JavaScript library leaflet, for interactive maps  
library(leafsync)     # plotting/syncing multiple leaflet maps
library(FRK)          # Convert spacial polygon df to df
library(dplyr)
library(ggmap)

source("00420.R")

register_google(key = key)

my.address <- readline(prompt="Enter address: ")

my.latlong <- geocode(my.address)


#Make a latlong column
addresses_df <- addresses_df %>%
  mutate(latlong = paste(lat, ", ", lon))



#__________________________


tractscounties <- read.csv("data/tractscounties.csv")

tracts_shp <- readOGR(dsn = path.expand("shapefiles/ohio_census_tracts"), layer = "tl_2019_39_tract")

us <- getData('GADM', country='USA', level=2)
counties_shp <- subset(us, NAME_1 == "Ohio")
subsetcounties_shp <- subset(counties_shp, NAME_2 != "Lake Erie")

#Import Licking PIT 2019 and recent information data

rawpit2020points <- read.csv("data/PointInTimeExport_02-12-2020.csv")

pit2020points <- rawpit2020points %>%
  select(response_id, survey, user_name, user_email, number_in_household, lat, lng, is_archived)

pit2020points <- pit2020points %>%
  filter(!is.na(lat) & pit2020points$is_archived == 0)

pit_points_sheltered <- pit2020points %>%
  filter(pit2020points$survey == "Sheltered Survey 2020")

pit_points_unsheltered <- pit2020points %>%
  filter(pit2020points$survey != "Sheltered Survey 2020")


#Rename columns so that coordinates function works

colnames(pit_points_sheltered)[colnames(pit_points_sheltered) == 'lat'] <- 'latitude'
colnames(pit_points_sheltered)[colnames(pit_points_sheltered) == 'lng'] <- 'longitude'

colnames(pit_points_unsheltered)[colnames(pit_points_unsheltered) == 'lat'] <- 'latitude'
colnames(pit_points_unsheltered)[colnames(pit_points_unsheltered) == 'lng'] <- 'longitude'

#Convert to spacial object by defining coordinates

coordinates(pit_points_sheltered) <- c("longitude", "latitude")
coordinates(pit_points_unsheltered) <- c("longitude", "latitude")

proj4string(pit_points_sheltered) <- proj4string(tracts_shp)
proj4string(pit_points_unsheltered) <- proj4string(tracts_shp)


counties <- read.csv("data/counties.csv")

simmtracts <- read.csv("data/ActivityTracts.csv") %>%
  
  filter(sample == "YES")

#Add counties to alltractsdf

alltractsdf <- left_join(simmtracts, tractscounties, by = "tract_id")

alltractsdf <- alltractsdf[order(alltractsdf$county, alltractsdf$tract_id),]


#Add BoS sample tracks and counties to census shapefile

alltractsdf <- alltractsdf %>%
  select(tract_id, designation, county)

alltractsdf <- alltractsdf %>%
  mutate(tract_id = as.character(tract_id))

names(alltractsdf) <- c("GEOID", "DES", "COUNTY")

tracts_shp@data <- left_join(tracts_shp@data, alltractsdf, by = "GEOID")

subsettracts_shp <- subset(tracts_shp, !is.na(DES))


#Identify the census tracts in which pins fall

pit_points_unsheltered$pip_area <- over(pit_points_unsheltered, subsettracts_shp)$GEOID %>% as.factor()


outsidetract <- as.data.frame(pit_points_unsheltered) %>%
  filter(is.na(pit_points_unsheltered$pip_area))

#Create CSV for Hannah

outside_tract_csv_for_hannah <- outsidetract %>%
  select(response_id, survey, user_name, user_email, number_in_household, latitude, longitude,)

outside_tract_csv_for_hannah$number_in_household[is.na(outside_tract_csv_for_hannah$number_in_household)] <- 1

outside_tract_csv_for_hannah <- outside_tract_csv_for_hannah[order(outside_tract_csv_for_hannah$latitude),]

write.csv(outside_tract_csv_for_hannah, file = "/Users/thirtysix/Dropbox/HMIS & BoSCoC Planning/HIC PIT/2020 HIC PIT/R/pit2020_unsheltered_outside_of_tracts.csv")

#Create Colors for dates

facpal <- colorFactor(palette(rainbow(2)), levels(factor(subsettracts_shp$DES)), ordered = FALSE,
                      na.color = "#808080", alpha = FALSE, reverse = FALSE)

#Color Palette possible alternative
#pal <- colorNumeric(palette = "RdBu", domain = c(1:2))

#Create Map

coordinates(outsidetract) <- c("longitude", "latitude")




