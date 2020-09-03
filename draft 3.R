library(tibble)
library(dplyr)
library(tidygeocoder)
library(stringr)

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
                               na.omit(DifferentStreetSuffix),
                               na.omit(DifferentSuffixQualifier),
                               na.omit(DifferentSuffixDirection),
                               na.omit(DifferentCity),
                               na.omit(DifferentState),
                               na.omit(DifferentZIP))
           ) %>%
    pull(WhatToCheck) %>%
    unique() %>%
    str_squish()
  
  
  if (refinements == "Please check your") {
    as.data.frame(census_full$`geographies.Census Tracts`) %>%
      pull(GEOID)
  } else {
    refinements
  }

  
  
  # Urban Institute. 2020. Rental Assistance Priority Index. Accessible from https://datacatalog.urban.org/dataset/rental-assistance-priority-index. Data originally sourced from 2014-18 ACS, July 2020 update of the Urban Institute’s “Where Low-Income Jobs Are Being Lost to COVID-19” data tool, and the 2012–16 US Department of Housing and Urban Developments Comprehensive Housing Affordability Strategy data data . Developed at the Urban Institute, and made available under the ODC-BY 1.0 Attribution License.

