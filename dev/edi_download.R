## ------------------------------------- ##
# Experiment with Downloading EDI Data
## ------------------------------------- ##
# Purpose:
## Want to make a tool that lets users download *any* EDI dataset
## Using the PASTA identifier makes sense as an initial stab

# Some potentially valuable testing datasets' links
## Non-LTER Bees: https://portal.edirepository.org/nis/mapbrowse?packageid=edi.1210.1
## BES shapefile: "https://portal.edirepository.org/nis/mapbrowse?scope=knb-lter-bes&identifier=52"
## AND trees: https://portal.edirepository.org/nis/mapbrowse?packageid=knb-lter-and.4544.4
## KNZ soil: https://portal.edirepository.org/nis/mapbrowse?packageid=knb-lter-knz.180.2

## --------------- ##
# Housekeeping ----
## --------------- ##

# Load needed libraries
librarian::shelf(tidyverse, devtools)

# Clear environment
rm(list = ls())

# Create a local folder for downloading
dir.create(path = file.path("dev", "edi"), showWarnings = F)

## --------------- ##
# Function Var. ----
## --------------- ##



## --------------- ##
# Script Variant ----
## --------------- ##

# Define some Package IDs
package_ids <- c("edi.1210.1", "knb-lter-bes.52.600",
                 "knb-lter-and.4544.4", "knb-lter-knz.180.2")

# Pick one
id <- unique(package_ids)[1]

# Generate a file path for the package
folder <- file.path("dev", "edi", id)

# Create a folder for the package
dir.create(path = folder, showWarnings = F)

# Identify the PASTA identifier
pasta_ident <- paste0("https://pasta.lternet.edu/package/eml/",
                      gsub(pattern = "\\.", replacement = "/", x = id))

# Identify the products within that package
products <- read.csv(file = url(description = pasta_ident), header = F) %>%
  ## Dropping the identifier we just used
  dplyr::filter(V1 != pasta_ident)

# Loop across the number of files in the package
# for(k in 1){
for(k in 1:length(products[, 1])){
  
  # Generate a temporary file name
  temp_name <- tempfile()
  
  # GET information on that link (needed later)
  link_info <- httr::GET(url = products[k, 1])
  
  # Attempt a download one way
  try(utils::download.file(url = products[k, 1], destfile = temp_name,
                           method = "curl", quiet = FALSE))
  
  # Download with the 'auto' method if the other one didn't work
  if(is.na(file.size(temp_name)) == TRUE){
    utils::download.file(url = products[k, 1], destfile = temp_name,
                         method = "auto", quiet = FALSE) }
  
  # Identify the file's actual extension
  type <- stringr::str_extract(string = link_info$all_headers[[1]]$headers$`content-type`,
                               pattern = "/[:alnum:]{3,10}")
  
  # Swap slash for period
  ext <- gsub(pattern = "\\/", replacement = ".", x = type)
  
  # Generate a nice(r) file name for that
  real_name <- paste0(id, "-file-", k, ext)
  
  # Move that file where we want it do be
  file.rename(from = temp_name, to = file.path(folder, real_name))
  
} # Close loop

# End ----
