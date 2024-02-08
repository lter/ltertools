## ----------------------------------- ##
          # 'Read' Testing ----
## ----------------------------------- ##

# Purpose:
## Both `harmonize` and `begin_key` need to read in every data file in a user-defined folder
## This operation needs to be pretty flexible to handle different data types, so it makes sense to create a helper function to do this that both of those functions can then invoke to read in the desired data
## Future updates to supported data types can then be made here and will automatically affect the downstream functions without the need for semi-duplicated revisions

## ----------------------------------- ##
            # Housekeeping ----
## ----------------------------------- ##
# Load libraries
librarian::shelf(devtools, tidyverse)

# Clear environment / collect garbage
rm(list = ls())

## ----------------------------------- ##
          # Script Variant ----
## ----------------------------------- ##
# Initial reading in _script format_

# Create vector of file extensions to look for
sufx <- c(".csv", ".txt", ".xlsx", ".xls")

# Make an empty list
file_list <- list()

# Loop across these identifying files of each type in a particular folder
for(ext in sufx){
  
  # Check for files of that type in the folder
  found_vec <- dir(path = file.path("dev", "testing"), pattern = ext)
  
  # For the check of ".xls" files we need to do an additional step
  if(ext == ".xls"){
    
    # Identify any modern Excel files (.xlsx) were found
    modern_excel <- stringr::str_detect(string = found_vec, pattern = ".xlsx")
    
    # And remove them (they'll be found by the dedicated check for their file extension)
    found_vec <- setdiff(x = found_vec, y = found_vec[modern_excel]) }
  
  # Create a simple dataframe for storing this information
  found_df <- data.frame("name" = found_vec,
                         "type" = ext)
  
  # Add to the list
  file_list[[ext]] <- found_df }

# Unlist the list
file_df <- purrr::list_rbind(x = file_list)

# check that out
file_df





# Re-clear environment
rm(list = ls())

## ----------------------------------- ##
# Function Variant ----
## ----------------------------------- ##
# Initial reading in _function format_

# Define function



# Clear environment / collect garbage
rm(list = ls()); gc()

# End ----
