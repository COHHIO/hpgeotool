library(tidyverse)
library(tidygeocoder)
library(scales)
library(patchwork)


index <- read_csv("housing_index_state_adj.csv") %>%
  select(
    GEOID,
    state_name,
    county_name,
    total_index_quantile,
    housing_index_quantile,
    covid_index_quantile,
    equity_index_quantile
  ) %>%
  filter(
state_name == "Ohio"     # &
    # !county_name %in% c(
    #   "Mahoning County",
    #   "Cuyahoga County",
    #   "Hamilton County",
    #   "Franklin County",
    #   "Lucas County",
    #   "Stark County",
    #   "Summit County",
    #   "Montgomery County"
    # )
  )

distribution_total <- hist(index$total_index_quantile)
distribution_housing <- hist(index$housing_index_quantile)
distribution_covid <- hist(index$covid_index_quantile)
distribution_equity <- hist(index$equity_index_quantile)

total <- ggplot(index, aes(total_index_quantile)) +
  geom_histogram(bins = 15) +
  theme_minimal()

housing <- ggplot(index, aes(housing_index_quantile)) +
  geom_histogram(bins = 15) +
  theme_minimal()

equity <- ggplot(index, aes(equity_index_quantile)) +
  geom_histogram(bins = 15) +
  theme_minimal()

covid <- ggplot(index, aes(covid_index_quantile)) +
  geom_histogram(bins = 15) +
  theme_minimal()

total / (housing + covid + equity)
