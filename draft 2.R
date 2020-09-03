library(tidycensus)

source("00420.R")
census_api_key(key = key , install = TRUE)

my.address <- readline(prompt="Enter address: ")

