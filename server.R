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
  
    output$aboutText <- renderUI({
        HTML(
            "<p>This tool was built by COHHIO and is using the data from the Urban
        Institute's
        <a href = \"https://www.urban.org/features/where-prioritize-emergency-rental-assistance-keep-renters-their-homes\">ERA Prioritization Tool</a>.
        The Ohio Balance of State CoC is incorporating the Indices into our
        targeting and prioritization process for our Homelessness Prevention and
        Emergency Rental Assistance projects. We needed our case managers to be able
        to find the Index for a specific household in a very user-friendly way.</p>
        <p>Of course any CoC in the US may use this tool as it includes the data
        from each state. We plan to maintain it until there is something better or
        it is not needed by anyone. The code for this Shiny app is available
        <a href = \"https://github.com/COHHIO/hpgeotool\">here</a>.
        <p>For more information about incorporating Racial Equity into the
        implementation of your ESG-CV dollars, please visit
        <a href =\"https://housingequityframework.org/\">housingequityframework.org</a>."
        )})
    
    output$citationsText <- renderUI({
        HTML(
            "<p>Urban Institute. 2021 Rental Assistance Priority Index.
        Accessible from
        <a href = \"https://datacatalog.urban.org/dataset/rental-assistance-priority-index\">here</a>.
        Data originally sourced from 2015-19 ACS, March 2021 update of the Urban 
        Institute’s “Where Low-Income Jobs Are Being Lost to COVID-19” data tool, 
        and the 2013–17 US Department of Housing and Urban Developments 
        Comprehensive Housing Affordability Strategy data. Developed at the 
        Urban Institute, and made available under the ODC-BY 1.0 Attribution 
        License.</p>

        <p>Wickham et al., (2019). Welcome to the
        <a href=\"https://doi.org/10.21105/joss.01686\">tidyverse</a>. Journal
        of Open Source Software, 4(43), 1686</p>

        <p>Winston Chang, Joe Cheng, JJ Allaire, Yihui Xie and Jonathan McPherson
        (2020). <a href=\"https://CRAN.R-project.org/package=shiny\">shiny</a>:
        Web Application Framework for R. R package version 1.5.0. </p>

        <p>Winston Chang and Barbara Borges Ribeiro (2018).
        <a href=\"https://CRAN.R-project.org/package=shinydashboard\">shinydashboard</a>:
        Create Dashboards with &#39;Shiny&#39;. R package version 0.7.1. </p>

        <p>Jesse Cambon (2020). <a href=\"https://CRAN.R-project.org/package=tidygeocoder\">tidygeocoder</a>:
        Geocoding Made Easy. R package version 1.0.1.</p>

        <p>Please send inquiries to the <a href = \"mailto:hmis@cohhio.org.\">COHHIO HMIS team</a>."
        )})
    
    observeEvent(input$go, {
        address <- reactive(tibble(singlelineaddress = c(input$address)))
        
        withProgress(message = "Looking for your address", {
            
            one_observation <- nrow(
                census_full <-
                    address() %>%
                    geocode(
                        address = singlelineaddress,
                        method = 'census',
                        full_results = TRUE,
                        api_options = list(census_return_type = 'geographies')
                    )
            ) == 1
            
            lat_valid <- !is.na(census_full$lat[1])
            
            status <- case_when(
                one_observation == FALSE ~ "insufficient",
                one_observation == TRUE &
                    lat_valid == TRUE ~ "good",
                one_observation == TRUE &
                    lat_valid == FALSE ~ "bad",
                TRUE ~ "contact administrator"
            )
            
            # if the address is "bad", the census blocks can't be unnested
            if (status != "bad") {
                census <-
                    census_full %>%
                    unnest('geographies.2020 Census Blocks') %>%
                    mutate(GEOID = substr(GEOID, 1, 11))
            }
            
            the_geocode <-
                reactive(census %>% pull(GEOID))
            
            your_state <- reactive(index %>%
                                       filter(GEOID == the_geocode()) %>%
                                       pull(state_name))
            
            output$Indices <- renderUI({
                if (status == "good") {
                    list(
                        infoBox(
                            subtitle = paste("Within", your_state()),
                            title = "Total Index",
                            index %>%
                                filter(GEOID == the_geocode()) %>%
                                pull(total_index_quantile),
                            icon = icon("location-dot"),
                            color = "black",
                            width = 12
                        ),
                        infoBox(
                            subtitle = paste("Within", your_state()),
                            title = "Housing Index",
                            index %>%
                                filter(GEOID == the_geocode()) %>%
                                pull(housing_index_quantile),
                            icon = icon("house-user")
                        ),
                        infoBox(
                            subtitle = paste("Within", your_state()),
                            title = "COVID Index",
                            index %>%
                                filter(GEOID == the_geocode()) %>%
                                pull(covid_index_quantile),
                            icon = icon("virus")
                        ),
                        infoBox(
                            subtitle = paste("Within", your_state()),
                            title = "Equity Index",
                            index %>%
                                filter(GEOID == the_geocode()) %>%
                                pull(equity_index_quantile),
                            icon = icon("scale-unbalanced")
                        )
                    )
                } else{
                    
                }
            })
            
            output$Insufficient <- renderUI({
                if (status == "insufficient") {
                    difference <- function(x)
                        length(unique(x)) > 1
                    
                    address_check <- census %>%
                        select(starts_with("addressComponents")) %>%
                        map_dbl(difference)
                    
                    to_check <-
                        names(address_check)[address_check == 1]
                    
                    friendly_names <- case_when(
                        to_check == "addressComponents.preQualifier" ~
                            "Pre-Qualifier, like \"Old\", \"New\"",
                        to_check == "addressComponents.preDirection" ~
                            "Direction, like \"North\", \"SW\"",
                        to_check == "addressComponents.preType" ~
                            "Type, like \"Route\", \"US HWY\", or \"Via\"",
                        to_check == "addressComponents.streetName" ~
                            "Street",
                        to_check == "addressComponents.suffixType" ~
                            "Suffix, like \"Street\" or \"Blvd\"",
                        to_check == "addressComponents.suffixDirection" ~
                            "Direction, like \"North\", \"SW\"",
                        to_check == "addressComponents.suffixQualifier" ~
                            "Post-Qualifier, like \"Bypass\", \"Private\"",
                        to_check == "addressComponents.city" ~
                            "City",
                        to_check == "addressComponents.state" ~
                            "State",
                        to_check == "addressComponents.zip" ~
                            "ZIP"
                    )
                    
                    insufficient_address <-
                        paste("Please check your",
                              paste(friendly_names,
                                    collapse = " & "))
                    
                    infoBox(
                        title = "Error",
                        subtitle = print(insufficient_address),
                        icon = icon("xmark"),
                        color = "orange",
                        width = 12
                    )
                } else{
                }
            })
            
            output$Garbage <- renderUI({
                if (status == "bad") {
                    infoBox(
                        title = "NO MATCH",
                        subtitle = "Check your address and try again.",
                        icon = icon("xmark"),
                        color = "fuchsia",
                        width = 12
                    )
                    
                } else{
                    
                }
            })
            
            output$Interpret <- renderUI({
              if(status == "good")
                HTML(paste(
                  "PLEASE NOTE: The Rental Assistance Priority Index and its 
                  subindexes are built on historical census data and estimates 
                  that may not capture the current need in each neighborhood. We
                  recommend using this tool in conjunction with a community-based 
                  process that includes examining local homelessness data and 
                  engaging stakeholders from groups and neighborhoods that local 
                  data show are disproportionately represented in evictions, 
                  homelessness, and COVID-19 infection and mortality. The higher 
                  the percentile, the higher the priority.<p><p>",
                  "The address entered is in census tract",
                  the_geocode(),
                  ". This census tract's Rental Assistance Priority Index is",
                  index %>%
                    filter(GEOID == the_geocode()) %>%
                    pull(total_index_quantile) %>%
                    as.character(),
                  ". This index is comprised of three subindexes:<p>
                  <ul><li>The Housing Index</li>
                  <li>The Covid Index</li>
                  <li>The Equity Index</li></ul>
                  <p>The census tract your address is located in has a Housing
                  Index of",
                  index %>%
                    filter(GEOID == the_geocode()) %>%
                    pull(housing_index_quantile),
                  ". This index represents the extent to which renters in your 
                  census tract are living in poverty, are severely cost-burdened 
                  and low-income, whose annual incomes are less than $35,000 and 
                  pay 50 percent or more of their incomes in gross rent, the area 
                  has a higher percent of renter-occupied housing units,

 severely overcrowded households: percentage of renter-occupied households with more
than 1.5 occupants per room  Share of unemployed people"
                ))
                
            })
            {
                incProgress(1 / 2)
            }
        })
    },
    ignoreInit = TRUE)
})
