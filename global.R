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
library(scales)

index <- read_csv("housing_index_state_adj.csv") %>%
  select(
    GEOID,
    state_name,
    total_index_quantile,
    housing_index_quantile,
    covid_index_quantile,
    equity_index_quantile,
    housing_index,
    covid_index,
    equity_index,
    total_index
  )

