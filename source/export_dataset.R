library(haven)
library(dplyr)

employ <- read_dta('data/healthEmploy_long.dta.dta')
spend <- read_dta('data/healthSpend_long.dta.dta')
pop <- read_dta('data/population_long.dta')

data <- 
  employ %>% 
  full_join(spend, by = c('state', 'year')) %>% 
  full_join(pop, by = c('state', 'year')) %>% 
  select(state, year, everything()) %>% 
  arrange(state, year)

write_dta(data, 'data/health_spending_and_employment.dta')