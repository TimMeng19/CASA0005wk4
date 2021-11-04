library(here)
library(sf)
library(tidyverse)
library(dplyr)
library(janitor)

gender_diff <- read_csv(here::here("data", "Gender Inequality Index (GII).csv"),
                        skip =5, na = c("NA",".."," ")) %>% clean_names() %>%
  #calculate the differences
  mutate(diff = (x2019-x2010)) %>% 
  select(., c("country","diff"))
#load world data
worldshp <- st_read(here("data", "World_Countries__Generalized_.shp")) %>%
  #join the data
  left_join(., gender_diff, by = c("COUNTRY"="country"))

#plot data
library(tmap)
tmap_mode("plot")
m <- tm_shape(worldshp) + 
  tm_polygons("diff", 
              style="pretty",
              palette="-YlOrRd", n = 5,
              midpoint=-0.2,
              title="Gender Inequality Differences",
              alpha = 0.5) +
  tm_layout(title="CASA0005Week4", legend.outside = TRUE, legend.position = c("right", "bottom"))

tmap_save(m, "map.png")
