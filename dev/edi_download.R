## ------------------------------------- ##
# Experiment with Downloading EDI Data
## ------------------------------------- ##
# Purpose:
## Want to make a tool that lets users download *any* EDI dataset
## Using the Package ID identifier makes sense as an initial stab

## --------------- ##
# Housekeeping ----
## --------------- ##

# Load needed libraries
librarian::shelf(tidyverse, devtools, XML, httr)

# Clear environment
rm(list = ls())

# Create a local folder for downloading
dir.create(path = file.path("dev", "edi"), showWarnings = F)

## --------------- ##
# Function Var. ----
## --------------- ##

# Define function
edi_download <- function(package_id = NULL, folder = getwd(), quiet = FALSE){
  
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
  products <- utils::read.csv(file = url(description = pasta_ident), header = F) %>%
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
    
    # If the product is the EML metadata:
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

# Tests of function with various data types in the package
## Generic CSV + XML
edi_download(package_id = "edi.1210.1", folder = file.path("dev", "edi"))

## Zipped Shapefile + XML
edi_download(package_id = "knb-lter-bes.52.600", folder = file.path("dev", "edi"))

## GeoJSON + ZIP + XML
edi_download(package_id = "knb-lter-cap.710.1", folder = file.path("dev", "edi"))

## NetCDF + XML
edi_download(package_id = "knb-lter-sbc.162.1", folder = file.path("dev", "edi"))

# Clear environment
rm(list = ls())

## --------------- ##
# Downstream Checks ----
## --------------- ##

# Load package functions
devtools::load_all()

# Examine compatibility with `read` function
test_out <- ltertools::read(raw_folder = file.path("dev", "edi", "edi.1210.1"))

# Check structure
str(test_out)

## --------------- ##

## --------------- ##

# Name the path to one of the XML docs
xml_path <- file.path("dev", "edi", "edi.1210.1", "edi.1210.1-metadata.xml")

# Parse the XML doc
(meta <- XML::xmlParse(file = xml_path) )

# End ----
