## ------------------------------------- ##
# Experiment with Downloading EDI Data
## ------------------------------------- ##
# Purpose:
## Want to make a tool that lets users download *any* EDI dataset
## Using the PASTA identifier makes sense as an initial stab

## --------------- ##
# Housekeeping ----
## --------------- ##

# Load needed libraries
librarian::shelf(tidyverse, devtools)

# Clear environment
rm(list = ls())

## --------------- ##
# Script Variant ----
## --------------- ##

# Define a local folder for downloading
folder <- file.path("dev", "edi")

# Create that folder if it doesn't exist
dir.create(path = folder, showWarnings = F)

# Identify a data package
## Bees: https://portal.edirepository.org/nis/mapbrowse?packageid=edi.1210.1
edi_link <- "https://portal.edirepository.org/nis/mapbrowse?packageid=edi.1210.1"


# Attempt the download
# utils::download.file(url = pasta_id, destfile = temp_dest,
#                      method = "auto", quiet = TRUE)



## --------------- ##
# Function Var. ----
## --------------- ##


# End ----
