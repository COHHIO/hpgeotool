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

shinyServer(function(input, output) {
    
    observeEvent(c(input$go), {
        
        output$Housing <- renderInfoBox({

            isolate(address <- tibble(singlelineaddress = c(input$address)))

            census_full <-
                address %>%
                geocode(
                    address = singlelineaddress,
                    method = 'census',
                    full_results = TRUE,
                    return_type = 'geographies'
                )

            nomatch <-  if_else(is.na(census_full$lat),
                                "No match. Check your address and try again.",
                                "ok")
            nomatch <- nomatch[1]

            if(nomatch == "ok") {census_full <- census_full %>%
                unnest('geographies.2010 Census Blocks') %>%
                mutate(GEOID = substr(GEOID, 1, 11))}

            if (nrow(census_full) == 1 & nomatch == "ok") {
                the_geocode <- census_full %>% pull(GEOID)
                your_state <- index %>%
                    filter(GEOID == the_geocode) %>%
                    pull(state_name)

                infoBox(subtitle = paste("Within", your_state),
                        title = "Housing Index",
                        index %>%
                            filter(GEOID == the_geocode) %>%
                            pull(housing_index_quantile),
                        icon = icon("house-user"))
            } else {
                infoBox(title = "")
            }
        })

        output$COVID19 <- renderInfoBox({

            isolate(address <- tibble(singlelineaddress = c(input$address)))

            census_full <-
                address %>%
                geocode(
                    address = singlelineaddress,
                    method = 'census',
                    full_results = TRUE,
                    return_type = 'geographies'
                )

            nomatch <-  if_else(is.na(census_full$lat),
                                "No match. Check your address and try again.",
                                "ok")
            nomatch <- nomatch[1]

                        if(nomatch == "ok") {census_full <- census_full %>%
                unnest('geographies.2010 Census Blocks') %>%
                mutate(GEOID = substr(GEOID, 1, 11))}

            if (nrow(census_full) == 1 & nomatch == "ok") {
                the_geocode <- census_full %>% pull(GEOID)
                your_state <- index %>%
                    filter(GEOID == the_geocode) %>%
                    pull(state_name)

                infoBox(subtitle = paste("Within", your_state),
                        title = "COVID-19 Index",
                        index %>%
                            filter(GEOID == the_geocode) %>%
                            pull(covid_index_quantile),
                        icon = icon("virus"))
            } else {
                infoBox(title = "")
            }
        })

        output$Equity <- renderInfoBox({

            isolate(address <- tibble(singlelineaddress = c(input$address)))

            census_full <-
                address %>%
                geocode(
                    address = singlelineaddress,
                    method = 'census',
                    full_results = TRUE,
                    return_type = 'geographies'
                )

            nomatch <-  if_else(is.na(census_full$lat),
                                "No match. Check your address and try again.",
                                "ok")
            nomatch <- nomatch[1]
            
            if(nomatch == "ok") {census_full <- census_full %>%
                unnest('geographies.2010 Census Blocks') %>%
                mutate(GEOID = substr(GEOID, 1, 11))}

            if (nrow(census_full) == 1 & nomatch == "ok") {
                the_geocode <- census_full %>% pull(GEOID)
                your_state <- index %>%
                    filter(GEOID == the_geocode) %>%
                    pull(state_name)

                infoBox(subtitle = paste("Within", your_state),
                        title = "Equity Index",
                        index %>%
                            filter(GEOID == the_geocode) %>%
                            pull(equity_index_quantile),
                        icon = icon("balance-scale-left"))
            } else {
                infoBox(title = "")
            }
        })
        
        output$Percentile <- renderInfoBox({
            
            isolate(address <-
                        tibble(singlelineaddress = c(input$address)))
            
            census_full <-
                address %>%
                geocode(
                    address = singlelineaddress,
                    method = 'census',
                    full_results = TRUE,
                    return_type = 'geographies'
                )
            
            nomatch <-  if_else(is.na(census_full$lat),
                                "No match.",
                                "ok")
            nomatch <- nomatch[1]
            
            if (nomatch == "ok") {
                census_full <- census_full %>%
                    unnest('geographies.2010 Census Blocks') %>%
                    mutate(GEOID = substr(GEOID, 1, 11))
            }
            
            if (nrow(census_full) == 1 & nomatch == "ok") {
                the_geocode <- census_full %>% pull(GEOID)
                your_state <- index %>%
                    filter(GEOID == the_geocode) %>%
                    pull(state_name)
                
                infoBox(
                    subtitle = paste("Within", your_state),
                    title = "Total Index",
                    index %>%
                        filter(GEOID == the_geocode) %>%
                        pull(total_index_quantile),
                    icon = icon("map-marker-alt"),
                    color = "black"
                )
            } else {
                if (nomatch == "ok" & nrow(census_full) > 1) {
                    insufficient_address <- census_full %>%
                        mutate(
                            DifferentStreetName = if_else(length(
                                unique(addressComponents.streetName)
                            ) > 1,
                            "Street Name", NULL),
                            DifferentStreetSuffix = if_else(
                                length(unique(addressComponents.suffixType)) > 1,
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
                            DifferentCity = if_else(length(unique(
                                addressComponents.city
                            )) > 1,
                            "City", NULL),
                            DifferentState = if_else(length(
                                unique(addressComponents.state)
                            ) > 1,
                            "State", NULL),
                            DifferentZIP = if_else(length(unique(
                                addressComponents.zip
                            )) > 1,
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
                    
                    infoBox(
                        title = "Error",
                        subtitle = print(insufficient_address),
                        icon = icon("times"),
                        color = "orange"
                    )
                } else{
                    infoBox(
                        title = nomatch,
                        subtitle = " Check your address and try again.",
                        icon = icon("times"),
                        color = "fuchsia", width = 12
                    )
                }
            }
        })
    }, 
    ignoreInit = TRUE)
})




