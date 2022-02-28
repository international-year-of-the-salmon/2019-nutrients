library(tidyverse)
library(lubridate)
library(readxl)
library(parsedate)
library(googledrive)
library(here)

dates <- read_excel(here("original_data", "raw_data", 
                         "IYS_GoA_2019_Hydro&Chemistry_20190326.xlsx"),
                    sheet = "Hydro_GoA") %>% 
  select(Station, date) %>% 
  distinct() %>% 
  # No time available to group profiles by so create profile_id 
  mutate(profile_id = paste0(date, ":Stn", 1:n(), ":profile", 1:n()))

chemistry <- read_excel(here("original_data", "raw_data", "IYS_GoA_2019_Hydro&Chemistry_20190326.xlsx"), sheet = "Chemistry_GoA")

# Inlcude date in chemistry sheet
chemistry <- left_join(dates, chemistry) %>% 
  select(Station:"NO3  [mkM/l]") %>% 
  mutate(Longitude = ifelse(Longitude > 180, -360 + Longitude, Longitude))


write_csv(chemistry, here("original_data", "IYS_2019_nutrients_O2.csv"))
