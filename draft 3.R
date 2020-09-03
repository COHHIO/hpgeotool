library(tibble)
library(DT)
library(dplyr)
library(tidygeocoder)

address_single1 <- tibble(singlelineaddress = c('11 Wall St, NY, NY', 
                                               '600 Peachtree Street NE, Atlanta, Georgia'))

address_single2 <- tibble(singlelineaddress = "605 N High St, Columbus, Ohio")

census_full1 <- address_single1 %>% geocode(address = singlelineaddress, 
                                           method = 'census', full_results = TRUE, return_type = 'geographies')
glimpse(census_full1)
