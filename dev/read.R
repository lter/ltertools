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
rm(list = ls()); gc()

## ----------------------------------- ##
# Script Variant ----
## ----------------------------------- ##
# List files ending in CSV in the directory (`raw_folder`)
raw_files <- dir(path = file.path("dev"), pattern = ".csv")

# Make an empty list
file_list <- list()

# Loop across identified files
for(file in raw_files){
  
  # Read it in
  df <- read.csv(file = file.path("dev", file))
  
  # Grab the column names
  df_names <- names(x = df)
  
  # Assemble this facet of the data key
  key_sub <- data.frame("source" = file,
                        "raw_name" = df_names,
                        "tidy_name" = NA)
  
  # Add that to the file list
  file_list[[file]] <- key_sub }

# Unlist the file list
key <- purrr::list_rbind(x = file_list)

# See if that worked
key

# Re-clear environment
rm(list = ls())

## ----------------------------------- ##
# Function Variant ----
## ----------------------------------- ##
# Initial key creation _in function format_

# Define function
begin_key <- function(raw_folder = NULL){
  # raw_folder <- "dev"
  
  # List files ending in CSV in the supplied directory
  raw_files <- dir(path = file.path(raw_folder), pattern = ".csv")
  
  # Error out if no CSVs are in that folder
  if(length(raw_files) == 0)
    stop("No CSV files detected in supplied path")
  
  # Make an empty list
  file_list <- list()
  
  # Loop across identified files
  for(file in raw_files){
    
    # Read it in
    df <- read.csv(file = file.path(raw_folder, file))
    
    # Grab the column names
    df_names <- names(x = df)
    
    # Assemble this facet of the data key
    key_sub <- data.frame("source" = file,
                          "raw_name" = df_names,
                          "tidy_name" = NA)
    
    # Add that to the file list
    file_list[[file]] <- key_sub }
  
  # Unlist the file list
  key <- purrr::list_rbind(x = file_list)
  
  # Return that dataframe
  return(key) }

# Invoke function
fxn_out <- begin_key(raw_folder = "dev")

# Look at output
fxn_out

# Clear environment / collect garbage
rm(list = ls()); gc()

# End ----
