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

library(shinydashboard)
library(shiny)
library(shinyWidgets)
library(tidyverse)
library(tidygeocoder)

index <- read_csv("housing_index_state_adj.csv") %>%
  select(
    GEOID,
    state_name,
    total_index_quantile,
    housing_index_quantile,
    covid_index_quantile,
    equity_index_quantile
  ) %>%
  mutate(
    total_index_quantile = case_when(
      (total_index_quantile * 100) %% 10 == 1 ~
        paste0(total_index_quantile * 100, "st percentile"),
      (total_index_quantile * 100) %% 10 == 2 ~
        paste0(total_index_quantile * 100, "nd percentile"),
      (total_index_quantile * 100) %% 10 == 3 ~
        paste0(total_index_quantile * 100, "rd percentile"),
      TRUE ~
        paste0(total_index_quantile * 100, "th percentile")
    ), 
    housing_index_quantile = case_when(
      (housing_index_quantile * 100) %% 10 == 1 ~
        paste0(housing_index_quantile * 100, "st percentile"),
      (housing_index_quantile * 100) %% 10 == 2 ~
        paste0(housing_index_quantile * 100, "nd percentile"),
      (housing_index_quantile * 100) %% 10 == 3 ~
        paste0(housing_index_quantile * 100, "rd percentile"),
      TRUE ~
        paste0(housing_index_quantile * 100, "th percentile")
    ), 
    covid_index_quantile = case_when(
      (covid_index_quantile * 100) %% 10 == 1 ~
        paste0(covid_index_quantile * 100, "st percentile"),
      (covid_index_quantile * 100) %% 10 == 2 ~
        paste0(covid_index_quantile * 100, "nd percentile"),
      (covid_index_quantile * 100) %% 10 == 3 ~
        paste0(covid_index_quantile * 100, "rd percentile"),
      TRUE ~
        paste0(covid_index_quantile * 100, "th percentile")
    ), 
    equity_index_quantile = case_when(
      (equity_index_quantile * 100) %% 10 == 1 ~
        paste0(equity_index_quantile * 100, "st percentile"),
      (equity_index_quantile * 100) %% 10 == 2 ~
        paste0(equity_index_quantile * 100, "nd percentile"),
      (equity_index_quantile * 100) %% 10 == 3 ~
        paste0(equity_index_quantile * 100, "rd percentile"),
      TRUE ~
        paste0(equity_index_quantile * 100, "th percentile")
    )
  )

