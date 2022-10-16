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

# data comes from: 
# https://datacatalog.urban.org/dataset/rental-assistance-priority-index/resource/181f439f-fdff-499f-9e02-cae969a34188

library(shinydashboard)
library(shiny)
library(shinyWidgets)
library(tidyverse)
library(tidygeocoder)
library(scales)

index <- read_csv("housing_index_state_adj.csv") %>%
  select(
    GEOID,
    state_name,
    total_index_quantile,
    housing_index_quantile,
    covid_index_quantile,
    equity_index_quantile,
    num_ELI
  ) %>%
  mutate(
    total_index_quantile = paste(ordinal(total_index_quantile * 100), "percentile"),
    covid_index_quantile = paste(ordinal(covid_index_quantile * 100), "percentile"),
    equity_index_quantile = paste(ordinal(equity_index_quantile * 100), "percentile"),
    housing_index_quantile = paste(ordinal(housing_index_quantile * 100), "percentile")
  )


