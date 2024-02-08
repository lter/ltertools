## ----------------------------------- ##
# 'Make Key' Testing ----
## ----------------------------------- ##

# Purpose:
## Support "data key"-based harmonization workflow by testing a function that can create (the start of) the column key

## ----------------------------------- ##
# Housekeeping ----
## ----------------------------------- ##
# Clear environment / collect garbage
rm(list = ls()); gc()

# Load libraries
librarian::shelf(devtools, tidyverse)

# Create data objects to harmonize
(df1 <- data.frame("x" = c(1:3),
                   "garbage" = c("52", "hello", "ooo"),
                   "y" = letters[1:3]))
(df2 <- data.frame("LETTERS" = letters[4:6],
                   "NUMBERS" = c(4:6),
                   "BONUS" = c("not", "needed", "column")))

# Export both of these for later re-use
write.csv(df1, file = file.path("dev", "test_df1.csv"), na = "", row.names = F)
write.csv(df2, file = file.path("dev", "test_df2.csv"), na = "", row.names = F)

# Clear environment again
rm(list = ls())

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
