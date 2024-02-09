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
# EDI Method ----
## --------------- ##

# # Define URL
# inUrl1  <- "https://pasta.lternet.edu/package/data/eml/edi/1210/1/c71bb3c137607da2d03d06342f9f1cad" 
# 
# # Create tempfile
# infile1 <- tempfile()
# 
# # Try one mode of downloading
# try(download.file(url = inUrl1, destfile = infile1, method = "curl"))
# 
# # Try another if that doesn't work
# if(is.na(file.size(infile1))) 
#   download.file(url = inUrl1, destfile = infile1, method = "auto")
# 

## --------------- ##
# Script Variant ----
## --------------- ##

# Create a local folder for downloading
dir.create(path = file.path("dev", "edi"), showWarnings = F)

# Identify a data package
## Non-LTER Bees: https://portal.edirepository.org/nis/mapbrowse?packageid=edi.1210.1
## BES shapefile: "https://portal.edirepository.org/nis/mapbrowse?scope=knb-lter-bes&identifier=52"
## AND trees: https://portal.edirepository.org/nis/mapbrowse?packageid=knb-lter-and.4544.4
## KNZ soil: https://portal.edirepository.org/nis/mapbrowse?packageid=knb-lter-knz.180.2

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


test <- httr::GET(url = "https://pasta.lternet.edu/package/data/eml/edi/1210/1/c71bb3c137607da2d03d06342f9f1cad")

str(test)

test$all_headers[[1]]$headers$`content-type`



httr::GET(url = "https://pasta.lternet.edu/package/data/eml/knb-lter-bes/52/600/9e734d0cbec91202f2442edb8a3399d4")



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
