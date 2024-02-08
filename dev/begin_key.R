## ----------------------------------- ##
        # 'Make Key' Testing ----
## ----------------------------------- ##

# Purpose:
## Support "data key"-based harmonization workflow by testing a function that can create (the start of) the column key

# Clear environment
rm(list = ls())

# Load libraries
librarian::shelf(devtools, tidyverse)

# Load all ltertools functions
devtools::load_all()

# Define function
begin_key <- function(raw_folder = NULL, data_format = c("csv", "txt", "xls", "xlsx")){
  # raw_folder = file.path("dev", "testing")
  # data_format = c("csv", "txt", "xls", "xlsx")
  
  # Read in all files in folder of specified type
  df_list <- ltertools::read(raw_folder = raw_folder, data_format = data_format)
  
  # Error out if no files are in that folder
  if(length(df_list) == 0)
    stop("No files of supported file types found in supplied path")
  
  # Make an empty list
  key_list <- list()
  
  # Loop across elements of the list provided by `read`
  for(g in 1:length(df_list)){
    
    # Identify file name
    file_name <- names(df_list)[g]
    
    # Identify the column names within that file
    col_names <- names(df_list[[g]])
    
    # Assemble this facet of the column key and add to the list
    key_list[[file_name]] <- data.frame("source" = file_name,
                                        "raw_name" = col_names) }
  
  # Unlist into a dataframe
  key_df <- purrr::list_rbind(x = key_list)
  
  # Create a column for the tidy name
  key_skeleton <- dplyr::mutate(.data = key_df,
                                tidy_name = NA)
  
  # Return this key skeleton
  return(key_skeleton) }

# Invoke function
fxn_out <- begin_key(raw_folder = file.path("dev", "testing"),
                     data_format = c("csv", "txt", "xls", "xlsx"))

# Look at output
fxn_out




# End ----
