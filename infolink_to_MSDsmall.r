library(tidyverse)
library(dplyr)
library(readr)
library(janitor)
library(tidyr)

thailand_sites_infolink <- read_csv("data/FY20-21 Thailand infolink results - 2021_11_03.csv", 
                                    na = "NA")

glimpse(thailand_sites_infolink)
table(thailand_sites_infolink$dataname)

thailand_custom <- thailand_sites_infolink %>%
  clean_names() %>% 
  tidyr::pivot_longer(cols = contains("_2"), names_to = "month_year", values_to = "values") %>%
  dplyr::filter(str_detect(dataname,"VERIFY"), !is.na(values)) %>%
  dplyr::mutate(country_name = orgunitlevel2,
                PSNU = orgunitlevel3,
                sitename = orgunitlevel5,
                indicator = if_else(str_detect(dataname, "TX_PVLS_VERIFY"), "TX_PVLS_VERIFY", dataname),
                funding_agency = "USAID",
                standardized_disaggregate = if_else(dataname == "TX_PVLS_VERIFY (D)", "Total Denominator", "Total Numerator"),
                month = stringr::str_extract(month_year, "^.*(?=_20)"), #STR PRECEDED BY "_20"
                q = recode(month,
                           "december" = "Q1",
                           "march" = "Q2",
                           "june" = "Q3",
                           "september" = "Q4"),
                fiscal_year = if_else(month=="december", as.double(stringr::str_extract(month_year, "(?<=_20).*"))+1, as.double(stringr::str_extract(month_year, "(?<=_20).*"))),
                FY = str_c("FY",fiscal_year,sep = ""),
                quarter = str_c(FY,q, sep = " ")) %>%
  select(country_name, funding_agency, PSNU, sitename, standardized_disaggregate, indicator, values, FY, quarter) %>%
  glimpse()

write.csv(thailand_custom, "dataout/Thailand FY20-21 Custom Indicators.csv", na = "", row.names = FALSE)
