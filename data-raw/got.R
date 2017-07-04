library(readr)
library(purrr)
library(stringr)

not_na <- function(...) {
  x <- c(...)
  x[!is.na(x)]
}

## battles

battles <- read_csv( "data-raw/battles.csv" ) %>%
  mutate(
    attacker = pmap( list(attacker_1, attacker_2, attacker_3, attacker_4), not_na ),
    defender = pmap( list(defender_1, defender_2, defender_3, defender_4), not_na ),
    attacker_commander = map( attacker_commander, ~str_split( ., pattern = ", +")[[1]]  ),
    defender_commander = map( defender_commander, ~str_split( ., pattern = ", +")[[1]]  )
  ) %>%
  select( -(attacker_1:attacker_4), -(defender_1:defender_4) )
use_data( battles, overwrite = TRUE)

# character-deaths
deaths <- read_csv( "data-raw/character-deaths.csv") %>%
  set_names( gsub( " ", "_", names(.) ) ) %>%
  mutate_at( vars(GoT:DwD), as.logical) %>%
  mutate(
    Gender = ifelse(Gender==1, "male", "female"),
    Nobility = ifelse( Nobility == 1, "nobel", "commoner")
  )
use_data( deaths, overwrite = TRUE )
