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
## Non-LTER Bees: https://portal.edirepository.org/nis/mapbrowse?packageid=edi.1210.1
## BES shapefile: "https://portal.edirepository.org/nis/mapbrowse?scope=knb-lter-bes&identifier=52"
## AND trees: https://portal.edirepository.org/nis/mapbrowse?packageid=knb-lter-and.4544.4
## KNZ soil: https://portal.edirepository.org/nis/mapbrowse?packageid=knb-lter-knz.180.2


# Define links
edi_links <- c("https://portal.edirepository.org/nis/mapbrowse?packageid=edi.1210.1", "https://portal.edirepository.org/nis/mapbrowse?scope=knb-lter-bes&identifier=52", "https://portal.edirepository.org/nis/mapbrowse?packageid=knb-lter-and.4544.4", "https://portal.edirepository.org/nis/mapbrowse?packageid=knb-lter-knz.180.2")

# Make a copy for later
pasta_ids <- edi_links

# Loop across that vector
for(link in edi_links){
  
  # Deduce the PASTA idenfitier from the search link
  if(stringr::str_detect(string = link, pattern = "\\?packageid\\=")){
    
    # Remove that link from the PASTA identifier vector
    pasta_ids <- setdiff(x = pasta_ids, y = link)
    
    # Drop rest of URL
    id_v1 <- gsub(pattern = "https\\:\\/\\/portal.edirepository.org\\/nis\\/mapbrowse\\?packageid\\=", replacement = "", x = link)
    
    # Replace periods with slashes
    id_v2 <- gsub(pattern = "\\.", replacement = "/", x = id_v1)
    
    # Re-assemble into PASTA identifier
    pasta_id <- paste0("https://pasta.lternet.edu/package/eml/", id_v2)
    
    # Add the finished ID back onto the vector of IDs
    pasta_ids <- c(pasta_ids, pasta_id) }
  
  # Deduce the PASTA identifier from the *identifier* link
  if(stringr::str_detect(string = link, pattern = "\\&identifier\\=")){
    
    # Remove that link from the PASTA identifier vector
    pasta_ids <- setdiff(x = pasta_ids, y = link)
    
    # Replace ampersand with a slash
    id_v1 <- gsub(pattern = "\\&", replacement = "/", x = link)
    
    # Drop rest of URL
    id_v2 <- gsub(pattern = "https\\:\\/\\/portal.edirepository.org\\/nis\\/mapbrowse\\?scope\\=|identifier\\=", replacement = "", x = id_v1)
    
    # Replace periods with slashes
    # id_v3 <- gsub(pattern = "\\.", replacement = "/", x = id_v2)
    
    # Re-assemble into PASTA identifier
    pasta_id <- paste0("https://pasta.lternet.edu/package/eml/", id_v2)
    
    # Add the finished ID back onto the vector of IDs
    pasta_ids <- c(pasta_ids, pasta_id)
    
  }
} # Close loop

# Check what that returns
pasta_ids




edi_link <- "https://portal.edirepository.org/nis/mapbrowse?packageid=edi.1210.1"
edi_pasta <- "https://pasta.lternet.edu/package/eml/edi/1210/1"

# Attempt the download
# utils::download.file(url = pasta_id, destfile = temp_dest,
#                      method = "auto", quiet = TRUE)



## --------------- ##
# Function Var. ----
## --------------- ##


# End ----
