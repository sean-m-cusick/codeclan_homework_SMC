# Packages
#--------------------------------------------------------------------------#
library(tidyverse)
library(janitor)
require(readr)
require(here)
library(jsonlite)


# Functions
#--------------------------------------------------------------------------#

# Function for fetching data from API ----
api_data_fetch <- function(api_id){
  
  api_url = "https://www.opendata.nhs.scot/api/3/action/datastore_search?resource_id="
  api_limit = "&limit=999999"
  
  # construct URL for fetching process
  url_link <- paste0(api_url, api_id, api_limit) %>%
    fromJSON()
  
  # construct data frame from URL
  api_df <-  url_link[["result"]][["records"]] %>% 
    clean_names()
  
  return(api_df)
}

# Function for writing .csv to sub-directory
write_csv_path <- function(df,filename,sep,path){
  write.csv(df,paste0(path,filename,sep = sep))
}


# API IDs
#--------------------------------------------------------------------------#
# Incidence at Scotland Level - 3400 records
api_scotland_cancer_incidence = "72c852b8-ee28-4fd8-84a9-5f415f4bc325"


# Incidence by Health Board - 47,600 records
api_hb_cancer_incidence = "3aef16b7-8af6-4ce0-a90b-8a29d6870014"


# 5 year summary Incidence by Health Board - 1632 records
api_5y_summary_cancer_incidence = "e8d33b2b-1fb2-4d59-ad21-20fa2f76d9d5"


# Load in API Dataframe and export
#--------------------------------------------------------------------------#
# Incidence at Scotland Level - 3400 records
scotland_cancer_incidence = api_data_fetch(api_scotland_cancer_incidence)

write_csv_path(df = scotland_cancer_incidence,
               filename =
                 "scotland_cancer_incidence.csv",
               sep = "",
               path = here("raw_data//"))

# Incidence by Health Board - 47,600 records
hb_cancer_incidence = api_data_fetch(api_hb_cancer_incidence)

write_csv_path(df = hb_cancer_incidence,
               filename =
                 "hb_cancer_incidence.csv",
               sep = "",
               path = here("raw_data//"))

# 5 year summary Incidence by Health Board - 1632 records
summary_cancer_incidence = api_data_fetch(api_5y_summary_cancer_incidence)

write_csv_path(df = summary_cancer_incidence,
               filename =
                 "summary_cancer_incidence",
               sep = "",
               path = here("raw_data//"))

