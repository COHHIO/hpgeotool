library(tibble)
library(dplyr)
library(tidygeocoder)

address <- tibble(singlelineaddress = "6576 Borr Ave, Columbus, OH 43068")

census_full <-
  address %>%
  geocode(
    address = singlelineaddress,
    method = 'census',
    full_results = TRUE,
    return_type = 'geographies'
  ) 

  refinements <- census_full %>%
    select(singlelineaddress, matchedAddress, starts_with("addressComponents")) %>%
    mutate(DifferentStreetName = if_else(length(unique(addressComponents.streetName)) > 1,
                                         "Street Name", NULL),
           DifferentStreetSuffix = if_else(length(unique(addressComponents.suffixType)) > 1,
                                          "Street Suffix (for example: Ave, Street, Way)", NULL),
           DifferentSuffixDirection = if_else(length(unique(addressComponents.suffixDirection)) > 1,
                                              "Street Direction (for example: N, W)", NULL),
           DifferentSuffixQualifier = if_else(length(unique(addressComponents.suffixQualifier)) > 1,
                                              "Suffix Qualifier", NULL),
           DifferentCity = if_else(length(unique(addressComponents.city)) > 1,
                                   "City", NULL),
           DifferentState = if_else(length(unique(addressComponents.state)) > 1,
                                    "State", NULL),
           DifferentZIP = if_else(length(unique(addressComponents.zip)) > 1,
                                  "ZIP Code", NULL),
           WhatToCheck = paste("Please check your", 
                               na.omit(DifferentStreetName),
                               DifferentStreetSuffix,
                               DifferentSuffixQualifier,
                               DifferentSuffixDirection,
                               DifferentCity, 
                               DifferentState,
                               DifferentZIP)
           ) %>%
    pull(WhatToCheck) %>%
    unique()

tracts_df <- if(refinements == "Please check your NA NA NA NA NA NA NA") {
  as.data.frame(census_full$`geographies.Census Tracts`)
  }

tract_no <- tracts_df %>%
  pull(GEOID)

