library(tibble)
library(DT)
library(dplyr)
library(tidygeocoder)

address_single2 <- tibble(singlelineaddress = "605 N High St, Columbus, Ohio 43215")

census_full1 <-
  address_single2 %>%
  geocode(
    address = singlelineaddress,
    method = 'census',
    full_results = TRUE,
    return_type = 'geographies'
  )

tracts_df <- as.data.frame(census_full1$`geographies.Census Tracts`)

blocks_df <- as.data.frame(census_full1$`geographies.2010 Census Blocks`)

glimpse(census_full1)
