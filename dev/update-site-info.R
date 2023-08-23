## ----------------------------------- ##
        # Update LTER Site Info
## ----------------------------------- ##

# Purpose:
## We need an easy way to update the LTER site information embedded in this package
## Assembling that dataframe here creates just such an update method
## while still keeping all package-relevant resources in a central location

## ----------------------------------- ##
            # Housekeeping ----
## ----------------------------------- ##
# Load libraries
## install.packages("librarian")
librarian::shelf(tidyverse)

# Create the folder we'll need later
dir.create(path = file.path("data"), showWarnings = F)

# Clear environment
rm(list = ls())

## ----------------------------------- ##
          # Custom Function ----
## ----------------------------------- ##

# Very small / niche custom function that we'll want later
as_lter_site <- function(name, code, hab, start, end, lat, lon, url, status){
  
  # Assemble provided data into a dataframe with pre-defined column names
  ## Also lets us do repetitive formatting in a consistent way
  lter_df <- data.frame("name" = paste(stringr::str_to_title(name), "LTER"),
                        "code" = toupper(code),
                        "habitat" = stringr::str_to_title(hab),
                        "start_year" = as.numeric(start),
                        "end_year" = as.numeric(end),
                        "latitude" = as.numeric(lat),
                        "longitude" = as.numeric(lon),
                        "site_url" = url,
                        "site_status" = status)
  
  # Return dataframe
  return(lter_df) }

## ----------------------------------- ##
          # Per Site Info ----
## ----------------------------------- ##

# Create a list to store separate sites' information in
site_list <- list()

# Order of information is as follows:
## c(full name, abbreviation, habitat, start_year, end_year, latit, longit, site_url, status)

# Andrews forest
site_list[["and"]] <- as_lter_site(name = "Andrews Forest", code = "AND", hab = "forest", 
                                   start = 1980, end = 2026, lat = 44.212, lon = -122.256, 
                                   url = "https://andrewsforest.oregonstate.edu/", status = "active")

# Arctic
site_list[["arc"]] <- as_lter_site(name = "Arctic", code = "ARC", hab = "tundra", 
                                   start = 1987, end = 2023, lat = 68.633333, lon = -149.606667, 
                                   url = "http://arc-lter.ecosystems.mbl.edu/", status = "active")

# Baltimore
site_list[["bes"]] <- as_lter_site(name = "Baltimore Ecosystem Study", code = "BES", hab = "urban", 
                                   start = 1997, end = 2021, lat = 39.1, lon = -76.3, 
                                   url = "https://baltimoreecosystemstudy.org/", status = "active")

# Beaufort Lagoon
site_list[["ble"]] <- as_lter_site(name = "Beaufort Lagoon Ecosystem", code = "BLE", hab = "marine", 
                                   start = 2017, end = 2022, lat = 71.3379, lon = -156.4165, 
                                   url = "https://ble.lternet.edu/", status = "active")

# Bonanza
site_list[["bnz"]] <- as_lter_site(name = "Bonanza Creek", code = "BNZ", hab = "forest", 
                                   start = 1987, end = 2023, lat = 64.8585, lon = -147.847, 
                                   url = "http://www.lter.uaf.edu/", status = "active")

# CA Current
site_list[["cce"]] <- as_lter_site(name = "California Current Ecosystem", code = "CCE", hab = "marine", 
                                   start = 2004, end = 2022, lat = 32.8736, lon = -120.28, 
                                   url = "https://ccelter.ucsd.edu/", status = "active")

# Cedar Creek
site_list[["cdr"]] <- as_lter_site(name = "Cedar Creek Ecosystem Science Reserve", code = "CDR", hab = "mixed", 
                    start = 1982, end = 2025, lat = 45.401, lon = -93.201, 
                    url = "http://cedarcreek.umn.edu/", status = "active")

# Central AZ - PHX
site_list[["cap"]] <- as_lter_site(name = "Central Arizona - Phoenix", code = "CAP", hab = "urban", 
                                   start = 1997, end = 2022, lat = 33.427, lon = -111.933, 
                                   url = "http://caplter.asu.edu/", status = "active")

# Coweeta
site_list[["cwt"]] <- as_lter_site(name = "Coweeta", code = "CWT", hab = "forest", 
                                   start = 1980, end = 2020, lat = 35, lon = -83.5, 
                                   url = "http://coweeta.uga.edu/", status = "active")

# FL Everglades
site_list[["fce"]] <- as_lter_site(name = "Florida Coastal Everglades", code = "FCE", hab = "coastal", 
                                   start = 2000, end = 2025, lat = 25.4682, lon = -80.8533, 
                                   url = "https://fce.lternet.edu/", status = "active")

# GA Coastal
site_list[["gce"]] <- as_lter_site(name = "Georgia Coastal Ecosystems", code = "GCE", hab = "coastal", 
                                   start = 2000, end = 2025, lat = 31.427, lon = -81.371, 
                                   url = "http://gce-lter.marsci.uga.edu/", status = "active")

# Harvard Forest
site_list[["hfr"]] <- as_lter_site(name = "Harvard Forest", code = "HFR", hab = "forest", 
                                   start = 1988, end = 2025, lat = 42.53, lon = -72.19, 
                                   url = "http://harvardforest.fas.harvard.edu/", status = "active")

# Hubbard Brook
site_list[["hbr"]] <- as_lter_site(name = "Hubbard Brook", code = "HBR", hab = "forest", 
                                   start = 1988, end = 2023, lat = 43.94, lon = -71.751, 
                                   url = "http://hbr.lternet.edu/", status = "active")


# Illinois Rivers
site_list[["ilr"]] <- as_lter_site(name = "Illinois Rivers", code = "ILR", hab = "freshwater", 
                                   start = 1982, end = 1989, lat = 40.32, lon = -90.3, 
                                   url = "", status = "inactive")

# Jornada
site_list[["jrn"]] <- as_lter_site(name = "Jornada Basin", code = "JRN", hab = "mixed", 
                                   start = 1982, end = 2024, lat = 32.6179, lon = -106.74, 
                                   url = "http://jrn.lternet.edu/", status = "active")

# Kellogg
site_list[["kbs"]] <- as_lter_site(name = "Kellogg Biological Station", code = "KBS", hab = "grassland", 
                                   start = 1987, end = 2023, lat = 42.4, lon = -85.4, 
                                   url = "http://lter.kbs.msu.edu/", status = "active")

# Konza
site_list[["knz"]] <- as_lter_site(name = "Konza Prairie", code = "KNZ", hab = "grassland", 
                                   start = 1980, end = 2026, lat = 39.093, lon = -96.575, 
                                   url = "http://lter.konza.ksu.edu/", status = "active")

# Luquillo
site_list[["luq"]] <- as_lter_site(name = "Luquillo", code = "LUQ", hab = "forest", 
                                   start = 1988, end = 2025, lat = 18.3, lon = -65.8, 
                                   url = "https://luq.lter.network/", status = "active")

# McMurdo
site_list[["mcm"]] <- as_lter_site(name = "McMurdo Dry Valleys", code = "MCM", hab = "freshwater", 
                                   start = 1991, end = 2023, lat = -77.62317, lon = 162.90054, 
                                   url = "https://www.mcmlter.org/", status = "active")

# MN - St. Paul
site_list[["msp"]] <- as_lter_site(name = "Minneapolis-St. Paul", code = "MSP", hab = "urban", 
                                   start = 2021, end = 2027, lat = 44.985844, lon = -93.182944, 
                                   url = "https://mspurbanlter.umn.edu/", status = "active")

# Moorea
site_list[["mcr"]] <- as_lter_site(name = "Moorea Coral Reef", code = "MCR", hab = "coastal", 
                                   start = 2004, end = 2022, lat = -17.4909, lon = -149.826, 
                                   url = "http://mcr.lternet.edu/", status = "active")

# Niwot
site_list[["nwt"]] <- as_lter_site(name = "Niwot Ridge", code = "NWT", hab = "tundra", 
                                   start = 1980, end = 2022, lat = 40.05411, lon = -105.5891, 
                                   url = "https://nwt.lternet.edu/", status = "active")

# North Inlet
site_list[["nin"]] <- as_lter_site(name = "North Inlet", code = "NIN", hab = "coastal", 
                                   start = 1980, end = 1993, lat = 33.309355, lon = -79.203775, 
                                   url = "", status = "inactive")

# North Temperate Lakes
site_list[["ntl"]] <- as_lter_site(name = "North Temperate Lakes", code = "NTL", hab = "freshwater", 
                                   start = 1980, end = 2027, lat = 46.0124, lon = -89.672, 
                                   url = "http://lter.limnology.wisc.edu/", status = "active")

# Northeast Shelf
site_list[["nes"]] <- as_lter_site(name = "Northeast US Shelf", code = "NES", hab = "marine", 
                                   start = 2017, end = 2022, lat = 40.6967, lon = -70.8833, 
                                   url = "https://nes-lter.whoi.edu/", status = "active")

# Northern Gulf of AK
site_list[["nga"]] <- as_lter_site(name = "Northern Gulf of Alaska", code = "NGA", hab = "marine", 
                                   start = 2017, end = 2022, lat = 59.045, lon = -148.7, 
                                   url = "https://nga.lternet.edu/", status = "active")

# Okefenokee
site_list[["oke"]] <- as_lter_site(name = "Okefenokee", code = "OKE", hab = "freshwater", 
                                   start = 1982, end = 1989, lat = 30.6669, lon = -82.3332, 
                                   url = "", status = "inactive")

# Palmer
site_list[["pal"]] <- as_lter_site(name = "Palmer Antarctic", code = "PAL", hab = "marine", 
                                   start = 1990, end = 2022, lat = -64.7742, lon = -64.0545, 
                                   url = "https://pallter.marine.rutgers.edu/", status = "active")

# Plum Island
site_list[["pie"]] <- as_lter_site(name = "Plum Island Ecosystems", code = "PIE", hab = "coastal", 
                                   start = 1998, end = 2022, lat = 42.759, lon = -70.891, 
                                   url = "http://pie-lter.ecosystems.mbl.edu/", status = "active")

# Santa Barbara Coastal
site_list[["sbc"]] <- as_lter_site(name = "Santa Barbara Coastal", code = "SBC", hab = "coastal", 
                                   start = 2000, end = 2024, lat = 34.4125, lon = -119.842, 
                                   url = "http://sbc.lternet.edu/", status = "active")

# Sevilleta
site_list[["sev"]] <- as_lter_site(name = "Sevilleta", code = "SEV", hab = "mixed", 
                                   start = 1988, end = 2023, lat = 34.353, lon = -106.882, 
                                   url = "https://sevlter.unm.edu/", status = "active")

# Shortgrass Steppe
site_list[["sgs"]] <- as_lter_site(name = "Shortgrass Steppe", code = "SGS", hab = "grassland", 
                    start = 1982, end = 2014, lat = 40.83, lon = -104.72,
                    url = "", status = "inactive")

# VA Coast
site_list[["vcr"]] <- as_lter_site(name = "Virginia Coast Reserve", code = "VCR", hab = "coastal", 
                                   start = 1987, end = 2024, lat = 37.283, lon = -75.913, 
                                   url = "http://www.vcrlter.virginia.edu/", status = "active")

# Preserve the LTER Network Office information
## Network Office 1
site_list[["lno1"]] <- data.frame("name" = "LTER Network Office", "code" = "LNO-UW", 
                                  "habitat" = stringr::str_to_title("admin"),
                                  "start_year" = 1987, "end_year" = 1998,
                                  "latitude" = 43.0766, "longitude" = -89.4125,
                                  "site_url" = "", "site_status" = "active")

## Network Office 2
site_list[["lno2"]] <- data.frame("name" = "Network Communication Office", "code" = "LNO-UMN", 
                                  "habitat" = stringr::str_to_title("admin"),
                                  "start_year" = 1998, "end_year" = 2015,
                                  "latitude" = 44.9740, "longitude" = -93.2277,
                                  "site_url" = "", "site_status" = "active")

## Network Office 3
site_list[["lno3"]] <- data.frame("name" = "LTER Network Office", "code" = "LNO-UCSB", 
                                  "habitat" = stringr::str_to_title("admin"),
                                  "start_year" = 2015, "end_year" = 2024,
                                  "latitude" = 34.4140, "longitude" = -119.8489,
                                  "site_url" = "https://lternet.edu/", "site_status" = "active")

## ----------------------------------- ##
       # Combine Across Sites ----
## ----------------------------------- ##

# Now we can combine that information across sites!
site_df <- purrr::list_rbind(x = site_list)

# Check structure of that
dplyr::glimpse(site_df)

# View it if desired
## tibble::view(site_df)

## ----------------------------------- ##
          # Process & Save ----
## ----------------------------------- ##

# Any final wrangling to be done before export into the package proper?
lter_sites <- site_df %>%
  # Drop inactive sites & the status column
  dplyr::filter(site_status != "inactive") %>%
  dplyr::select(-site_status) %>%
  # Arrange by habitat and starting year
  dplyr::arrange(habitat, start_year)

# Check structure once more
dplyr::glimpse(lter_sites)
# tibble::view(lter_sites)


# End ----
