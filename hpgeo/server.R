# COHHIO_HMIS
# Copyright (C) 2020  Coalition on Homelessness and Housing in Ohio (COHHIO)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details at
# <https://www.gnu.org/licenses/>.

library(shiny)
library(tidyverse)
library(tidygeocoder)

shinyServer(function(input, output) {
    
    observeEvent(c(input$go), {
        
        output$Percentile <- renderText({
            address <- tibble(singlelineaddress = c(input$address))
            
            census_full <-
                address %>%
                geocode(
                    address = singlelineaddress,
                    method = 'census',
                    full_results = TRUE,
                    return_type = 'geographies'
                ) %>%
                select(singlelineaddress,
                       matchedAddress,
                       starts_with("addressComponents"),
                       `geographies.2010 Census Blocks`) %>%
                unnest('geographies.2010 Census Blocks')

            if (nrow(census_full) == 1) {
                the_geocode <- census_full %>% pull(GEOID)
                
                print(the_geocode)
            } else {
                insufficient_address <- census_full %>%
                    mutate(
                        DifferentStreetName = if_else(length(
                            unique(addressComponents.streetName)
                        ) > 1,
                        "Street Name", NULL),
                        DifferentStreetSuffix = if_else(
                            length(unique(
                                addressComponents.suffixType
                            )) > 1,
                            "Street Suffix (for example: Ave, Street, Way)",
                            NULL
                        ),
                        DifferentSuffixDirection = if_else(
                            length(unique(
                                addressComponents.suffixDirection
                            )) > 1,
                            "Street Direction (for example: N, W)",
                            NULL
                        ),
                        DifferentSuffixQualifier = if_else(length(
                            unique(addressComponents.suffixQualifier)
                        ) > 1,
                        "Suffix Qualifier", NULL),
                        DifferentCity = if_else(length(
                            unique(addressComponents.city)
                        ) > 1,
                        "City", NULL),
                        DifferentState = if_else(length(
                            unique(addressComponents.state)
                        ) > 1,
                        "State", NULL),
                        DifferentZIP = if_else(length(
                            unique(addressComponents.zip)
                        ) > 1,
                        "ZIP Code", NULL),
                        WhatToCheck = paste(
                            "Please check your",
                            na.omit(DifferentStreetName),
                            na.omit(DifferentStreetSuffix),
                            na.omit(DifferentSuffixQualifier),
                            na.omit(DifferentSuffixDirection),
                            na.omit(DifferentCity),
                            na.omit(DifferentState),
                            na.omit(DifferentZIP)
                        )
                    ) %>%
                    pull(WhatToCheck) %>%
                    unique() %>%
                    str_squish()
                
                print(insufficient_address)
            }
        })
    })
})




