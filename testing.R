address <- tibble(singlelineaddress = c(""))

census_full <-
  address %>%
  geocode(
    address = singlelineaddress,
    method = 'census',
    full_results = TRUE,
    return_type = 'geographies'
  ) 

nomatch <-  if_else(is.na(census_full$lat),
                    "No match. Please check your address and try again.",
                    "ok")

nomatch <- nomatch[1]

if(nomatch == "ok") {
  census_full <- census_full %>%
    unnest('geographies.2010 Census Blocks') %>%
    mutate(GEOID = substr(GEOID, 1, 11))
}

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
  
  print(insufficient_address)}  else{
    print(nomatch)
  }

nrow(
  census_full <-
    address %>%
    geocode(
      address = singlelineaddress
    )
) == 1 &
  !is.na(census_full$lat[1])

tbl <- tribble(~col, ~adress.stname, ~adress.suffix, ~adress.city, ~adress.state, ~adress.zip,
               1, "a", "b", "foo", "oh", "3333",
               1, "a", "c", "boo", "oh", "3333",
               1, "a", "b", "loo", "oh", "3333"
)
tbl

foo_uniq <- function(x) length(unique(x)) > 1

ad_test <-
  tbl %>%
  select(starts_with("adress")) %>%
  map_lgl(foo_uniq)

wrong_item <- names(ad_test)[ad_test == TRUE]  

case_when(
  wrong_item == "adress.stname" ~ "state",
  wrong_item == "adress.suffix" ~ "suffix",
  wrong_item == "adress.city" ~ "city",
  wrong_item == "adress.zip" ~ "zip") -> wrong_msg
paste("Wrong", paste(wrong_msg, collapse = " & "))
