# Create health employment data by importing BLS series from FRED on health sector employment

# Load packages
library(fImport) # Imports Fred series 
library(dplyr)
library(readr)
library(lubridate)
library(tidyr)

from <- '1990-01-01'
to <- '2017-12-31'

# Load series names
series <- read_csv('data/health_employment/fred_series_ids.csv')

# Select which series we pull 
# We only want states with health employment data OR 
# states with health care and social assistance employment AND social assistance employment.
# We'll back out health employment in the latter case. 
series_to_pull <- 
  series %>% 
    left_join(
      series %>% 
        group_by(state) %>% 
        summarize(
          health_care = max(industry == 'health care')
          ,health_and_sa = max(industry == 'health care and social assistance')
          ,sa = max(industry == 'social assistance')
        ) %>% 
        mutate(keep_state = (health_care == 1) | (health_and_sa == 1 & sa == 1)) 
    ) %>% 
    dplyr::filter(keep_state)

# Import series
data_import <- fredSeries(series_to_pull$series_id, from, to)

# Clean data
data <- as_data_frame(data_import)
data$year <- year(labels(data)[[1]])
data$month <- month(labels(data)[[1]])
rownames(data) <- c()

# Reshape data
data <- gather(data, series_id, value, -year, -month)

data <- 
  data %>% 
  left_join(series_to_pull %>% select(state, industry, series_id)) %>% 
  select(-series_id) %>% 
  spread(industry, value) %>% 
  mutate(
    health_care_total = coalesce(`health care`,  
                        `health care and social assistance` - `social assistance`
                        )
    ) 
  
# Average data by year
annual_data <- 
  data %>% 
  select(year, month, state, health_employ = health_care_total) %>% 
  group_by(state, year) %>% 
  summarize(health_employ = mean(health_employ)) %>% 
  spread(state, health_employ) 

# Export employment data (all figures in 000's of persons)
write_csv(data, 'data/health_employment/health_employment_monthly.csv')
write_csv(annual_data, 'data/health_employment/health_employment_annual.csv', na = '')








