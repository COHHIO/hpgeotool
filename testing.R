address <- tibble(singlelineaddress = c("6576 borr ave columbus oh 43068"))

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

