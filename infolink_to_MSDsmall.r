library(tidyverse)
library(dplyr)
library(readr)
library(janitor)
library(tidyr)

thailand_sites_infolink <- read_csv("FY21 Thailand infolink results - custom and MER - 2021_10_19.csv", 
                                                                     na = "NA")

glimpse(thailand_sites_infolink)

thailand_custom <- thailand_sites_infolink %>%
  clean_names() %>% 
  tidyr::pivot_longer(c(oct_to_dec_2020, jan_to_mar_2021, apr_to_jun_2021, jul_to_sep_2021)) %>% 
  dplyr::mutate(operatingunit = "Asia Region",
                country = orgunitlevel2,
                psnu = orgunitlevel3,
                sitename = orgunitlevel4,
                indicator = recode(dataname,
                                   )
                quarter  = recode(name,
                                    "oct_to_dec_2020" = "Q1",
                                    "jan_to_mar_2021" = "Q2",
                                    "apr_to_jun_2021" = "Q3",
                                    "jul_to_sep_2021" = "Q4"
                                    )) %>%
  select(operatingunit, country, psnu, sitename, quarter, value) %>%
  
  glimpse()
