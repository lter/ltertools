## ----------------------------------- ##
# Day Length
## ----------------------------------- ##

# PURPOSE:
## Identify day length for every day between two dates at a specified set of coordinates

## --------------------- ##
    # Housekeeping ----
## --------------------- ##

# Load libraries
librarian::shelf(tidyverse)

# Clear environment
rm(list = ls())

## --------------------- ##
# Script Variant ----
## --------------------- ##

# Create testing objects
lat <- 18.321056
lng <- -65.819722
start_date <- "2001-01-01"
end_date <- "2001-12-31"

# Identify all dates between the start and end
date_range <- seq(from = as.Date(start_date), to = as.Date(end_date), by = "days")

# Make an empty list
date_list <- list()

# Loop across these days
for(k in 1:length(date_range)){
  
  # Identify focal date
  focal_date <- date_range[k]
  
  # Message which date is being processed
  message("Retrieving data for ", focal_date)
  
  # Assemble query
  day_query <- paste0("https://api.sunrise-sunset.org/json?lat=",
                      lat, "&lng=", lng, "&date=", focal_date)
  
  # Test query
  day_info <- suppressWarnings(read.csv(file = url(description = day_query), header = F))
  
  # Extract to data frame
  single_df <- data.frame("date" = focal_date,
                          "v1" = day_info$V1,
                          "v2" = day_info$V2,
                          "v3" = day_info$V3,
                          "v4" = day_info$V4,
                          "v5" = day_info$V12)
  
  # Add to list
  date_list[[as.character(focal_date)]] <- single_df
  
} # Close loop

# Unlist to dataframe
day_df <- purrr::list_rbind(x = date_list) %>% 
  # Fix some formatting issues in retrieved information
  dplyr::mutate(sunrise = gsub(pattern = "[{]results:[{]sunrise:", replacement = "", x = v1),
                sunset = gsub(pattern = "sunset:", replacement = "", x = v2),
                solar_noon = gsub(pattern = "solar_noon:", replacement = "", x = v3),
                day_length = gsub(pattern = "day_length:", replacement = "", x = v4),
                time_zone = gsub(pattern = "tzid:|[}]", replacement = "", x = v5)) %>% 
  # Drop earlier variant of those columns
  dplyr::select(-dplyr::starts_with("v"))

# Check that output
str(day_df)
## View(day_df)

## --------------------- ##
# Function Variant ----
## --------------------- ##



# End ----
