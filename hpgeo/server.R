#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(tidygeocoder)

# Define server logic required to draw a histogram
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
            )
        
        refinements <- census_full %>%
            select(singlelineaddress,
                   matchedAddress,
                   starts_with("addressComponents")) %>%
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
        
        
        if (refinements == "Please check your") {
            as.data.frame(census_full$`geographies.Census Tracts`) %>%
                pull(GEOID)
        } else {
            refinements
        }
    })
    })
 