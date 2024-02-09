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

# Define function
edi_download <- function(package_id = NULL, folder = NULL, quiet = FALSE){
  
  # Error out for missing package ID or folder path
  if(is.null(package_id) == TRUE | is.null(folder) == TRUE)
    stop("Package ID and destination folder path must be supplied")
  
  # Error out for incorrect class of package ID object
  if(is.character(package_id) != TRUE)
    stop("Package ID must be supplied as a character")
  
  # Error out for malformed package ID
  ## NEED TO ASK EDI MORE ON THIS TOPIC
  ## I.e., need to know what rules there are for these IDs to be able to recognize deviations from those rules
  
  if(is.logical(quiet) != TRUE){
    quiet <- FALSE
    message("`quiet` argument must be set to a logical, defaulting to FALSE") }
  
  # Add the package ID to the end of the folder path
  path <- file.path(folder, package_id)
  
  # Create a folder for the package
  dir.create(path = path, showWarnings = F)
  
  # Identify the PASTA identifier
  pasta_ident <- paste0("https://pasta.lternet.edu/package/eml/",
                        gsub(pattern = "\\.", replacement = "/", x = package_id))
  
  # Identify the products within that package
  products <- read.csv(file = url(description = pasta_ident), header = F) %>%
    ## Dropping the identifier we just used
    dplyr::filter(V1 != pasta_ident)
  
  # If `quiet` isn't `TRUE`, print a message about how many files there are
  if(quiet != TRUE){
    message(length(products[, 1]), " files identified in specified data package")
  }
  
  # Loop across the number of files in the package
  for(k in 1:length(products[, 1])){
    
    # Generate a temporary file name
    temp_name <- tempfile()
    
    # Grab the specific product URL
    prod_url <- products[k, 1]
    
    # GET information on that link (needed later)
    link_info <- httr::GET(url = prod_url)
    
    # Attempt a download with the 'curl' method
    try(utils::download.file(url = prod_url, destfile = temp_name,
                             method = "curl", quiet = quiet))
    
    # Download with the 'auto' method if the other one didn't work
    if(is.na(file.size(temp_name)) == TRUE){
      utils::download.file(url = prod_url, destfile = temp_name,
                           method = "auto", quiet = quiet) }
    
    # Grab the content type and disposition
    type <- link_info$all_headers[[1]]$headers$`content-type`
    disp <- link_info$all_headers[[1]]$headers$`content-disposition`
    
    # If the product is the metadata:
    if(stringr::str_detect(string = prod_url, pattern = "package/metadata/eml") == TRUE){
      
      # Generate a neat file name
      file_name <- paste0(package_id, "-metadata.xml")
      
      # If the product is the quality report
    } else if(stringr::str_detect(string = prod_url, pattern = "package/report/eml")){
      
      # Generate a neat file name
      file_name <- paste0(package_id, "-quality-report.xml")
      
      # If the disposition is missing:
    } else if(is.null(disp) == TRUE){
      # Process the content type to infer the file extension
      ext <- gsub(pattern = "\\/", replacement = ".", 
                  x = stringr::str_extract(string = type, pattern = "/[:alnum:]{3,10}"))
      
      # Assemble into a full file name
      file_name <- paste0(package_id, "-file-", k, ext)
      
      # Otherwise:
    } else {
      # Grab the "content disposition" and trim off unwanted components
      file_name <- gsub(pattern = '\"|attachment\\; filename\\=', replacement = "", 
                        x = disp)
    }
    
    # Move that file where we want it do be
    file.copy(from = temp_name, to = file.path(path, file_name), overwrite = TRUE)
    
  } # Close loop 
}

# Invoke function
edi_download(package_id = "edi.1210.1", folder = file.path("dev", "edi"))

# Other tests of function on different data products
edi_download(package_id = "knb-lter-bes.52.600", folder = file.path("dev", "edi"))
edi_download(package_id = "knb-lter-and.4544.4", folder = file.path("dev", "edi"))
edi_download(package_id = "knb-lter-knz.180.2", folder = file.path("dev", "edi"))

# Clear environment
rm(list = ls())

## --------------- ##
# Script Variant ----
## --------------- ##

# Clear environment
rm(list = ls())

# Define objects that are equivalent to function arguments
package_id <- "knb-lter-and.4544.4"
folder <- file.path("dev", "edi")
quiet <- FALSE

# Add the package ID to the end of the folder path
path <- file.path(folder, package_id)

# Create a folder for the package
dir.create(path = path, showWarnings = F)

# Identify the PASTA identifier
pasta_ident <- paste0("https://pasta.lternet.edu/package/eml/",
                      gsub(pattern = "\\.", replacement = "/", x = package_id))

# Identify the products within that package
products <- read.csv(file = url(description = pasta_ident), header = F) %>%
  ## Dropping the identifier we just used
  dplyr::filter(V1 != pasta_ident)

# If `quiet` isn't `TRUE`, print a message about how many files there are
if(quiet != TRUE){
  message(length(products[, 1]), " files identified in specified data package")
}

# Loop across the number of files in the package
for(k in 1:length(products[, 1])){
  
  # Generate a temporary file name
  temp_name <- tempfile()
  
  # Grab the specific product URL
  prod_url <- products[k, 1]
  
  # GET information on that link (needed later)
  link_info <- httr::GET(url = prod_url)
  
  # Attempt a download with the 'curl' method
  try(utils::download.file(url = prod_url, destfile = temp_name,
                           method = "curl", quiet = quiet))
  
  # Download with the 'auto' method if the other one didn't work
  if(is.na(file.size(temp_name)) == TRUE){
    utils::download.file(url = prod_url, destfile = temp_name,
                         method = "auto", quiet = quiet) }
  
  # Grab the content type and disposition
  type <- link_info$all_headers[[1]]$headers$`content-type`
  disp <- link_info$all_headers[[1]]$headers$`content-disposition`
  
  # If the product is the metadata:
  if(stringr::str_detect(string = prod_url, pattern = "package/metadata/eml") == TRUE){
    
    # Generate a neat file name
    file_name <- paste0(package_id, "-metadata.xml")
    
    # If the product is the quality report
  } else if(stringr::str_detect(string = prod_url, pattern = "package/report/eml")){
    
    # Generate a neat file name
    file_name <- paste0(package_id, "-quality-report.xml")
    
    # If the disposition is missing:
  } else if(is.null(disp) == TRUE){
    # Process the content type to infer the file extension
    ext <- gsub(pattern = "\\/", replacement = ".", 
                x = stringr::str_extract(string = type, pattern = "/[:alnum:]{3,10}"))
    
    # Assemble into a full file name
    file_name <- paste0(package_id, "-file-", k, ext)
    
    # Otherwise:
  } else {
    # Grab the "content disposition" and trim off unwanted components
    file_name <- gsub(pattern = '\"|attachment\\; filename\\=', replacement = "", 
                      x = disp)
  }
  
  # Move that file where we want it do be
  file.copy(from = temp_name, to = file.path(path, file_name), overwrite = TRUE)
  
} # Close loop 

# End ----
