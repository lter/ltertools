## ----------------------------------- ##
      # Harmonization Testing ----
## ----------------------------------- ##

# Purpose:
## Explore possibility of function variant of "data key"-based harmonization workflow

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

# Export one with a different filename that we won't include in the data key
write.csv(df2, file = file.path("dev", "test_df3.csv"), na = "", row.names = F)


# Create data key
(data_key <- data.frame("source" = c("test_df1.csv", "test_df1.csv", "test_df1.csv",
                               "test_df2.csv", "test_df2.csv", "test_df2.csv"),
                  "raw_name" = c("x", "gar_typo", "y", "NUMBERS", "LETTERS", "BONUS"),
                  "tidy_name" = c("numbers", "garbage", "letters", "numbers", "letters", NA)) )

## ----------------------------------- ##
          # Script Variant ----
## ----------------------------------- ##
# Data key harmonization _in script format_

# Make an empty list
file_list <- list()

# Loop across files named in the data key
for(file in unique(data_key$source)){
  ## file <- "test_df1.csv"
  
  # Prepare the data key
  data_key_sub <- data_key %>% 
    # Subset to just this file
    dplyr::filter(source == file) %>% 
    # Drop any instances where the harmonized name is absent (i.e., the raw column is unwanted)
    dplyr::filter(is.na(tidy_name) != TRUE & nchar(tidy_name) != 0)
  
  # Read in file
  df_v1 <- read.csv(file = file.path("dev", file))
  
  # Prepare the data for harmonization via data key
  df_v2 <- df_v1 %>% 
    # Add a source column and row number column to preserve original rows
    ## (name is bizarre to avoid overwriting extant column name)
    dplyr::mutate(xxxx_row_num = 1:nrow(.),
                  source = file) %>% 
    # Make all columns characters
    dplyr::mutate(dplyr::across(.cols = dplyr::everything(),
                                .fns = as.character)) %>% 
    # Pivot the data into 'ultimate' long format
    tidyr::pivot_longer(cols = -xxxx_row_num:-source,
                        names_to = "raw_name",
                        values_to = "values")
  
  # Identify any columns in the data key but apparently not in the data
  missing_cols <- setdiff(x = unique(data_key_sub$raw_name),
                          y = unique(df_v2$raw_name))
  
  # Warn the user if any are found
  if(length(missing_cols) != 0){
    message("Following columns in data key NOT found in '", file, "'. Removing from harmonization effort")
    print(missing_cols) }
  
  # Drop the missing cols object for the next iteration of the loop
  missing_cols <- NULL
  
  # Perform actual harmonization
  df_v3 <- df_v2 %>% 
    # Attach the data key to the data
    dplyr::left_join(y = data_key_sub, by = c("source", "raw_name")) %>% 
    # Drop any columns without a standardized name
    dplyr::filter(is.na(tidy_name) != TRUE & nchar(tidy_name) != 0) %>% 
    # Trash the old column names
    dplyr::select(-raw_name) %>% 
    # Pivot back to original format
    tidyr::pivot_wider(names_from = tidy_name, values_from = values) %>% 
    # Trash row number column created in loop
    dplyr::select(-xxxx_row_num)
  
  # Add to list
  file_list[[file]] <- df_v3 }

# Unlist the list
harmonized_df <- purrr::list_rbind(x = file_list)

# Check that out
harmonized_df

# Clear environment of everything except data key
rm(list = setdiff(x = ls(), y = "data_key"))

## ----------------------------------- ##
          # Function Variant ----
## ----------------------------------- ##
# Data key harmonization _in function format_

# Define function
harmonize <- function(key = NULL, raw_folder = NULL, quiet = TRUE){
  # key <- data_key
  # raw_folder <- "dev"
  # quiet <- F
  
  # Error out if data key does not contain all needed information
  if(all(c("source", "raw_name", "tidy_name") %in% names(key)) != TRUE)
    stop("Data key must include 'source', 'raw_name' and 'tidy_name' columns")
  
  # Drop any unnecessary data key columns
  key_actual <- key %>% 
    dplyr::select(source, raw_name, tidy_name) %>% 
    dplyr::distinct()
  
  # Identify available raw files *that are also present in the data key*
  raw_files <- generics::intersect(x = dir(path = raw_folder, pattern = ".csv"),
                                   y = unique(key_actual$source))
  
  # Identify any files present but not in data key
  unk_files <- generics::setdiff(x = dir(path = raw_folder, pattern = ".csv"),
                                 y = unique(key_actual$source))
  
  # If any are found and `quiet` isn't `TRUE`, report on these files
  if(length(unk_files) != 0 & quiet != TRUE){
    message("Following files found in raw path but not in data key:")
    print(paste0("'", unk_files, "'", collapse = " & ")) }
  
  # Create an empty list for storing each harmonized raw file (pre-combination)
  file_list <- list()
  
  # Loop across files that *are* in the data key
  for(focal_file in raw_files){
    # focal_file <- "test_df1.csv"
    
    # Prepare the data key
    key_sub <- key_actual %>% 
      # Subset to just this file
      dplyr::filter(source == focal_file) %>% 
      # Drop any instances where the harmonized name is absent
      ## (assuming that raw column is unwanted in harmonized data object)
      dplyr::filter(is.na(tidy_name) != TRUE & nchar(tidy_name) != 0)
    
    # Read in the first file
    dat_v1 <- read.csv(file = file.path(raw_folder, focal_file))
    
    # Prepare the data for harmonization via data key
    dat_v2 <- dat_v1 %>% 
      # Add a source column and row number column to preserve original rows
      ## (name is bizarre to avoid overwriting extant column name)
      dplyr::mutate(xxxx_row_num = 1:nrow(.),
                    source = focal_file) %>% 
      # Make all columns characters
      dplyr::mutate(dplyr::across(.cols = dplyr::everything(),
                                  .fns = as.character)) %>% 
      # Pivot the data into 'ultimate' long format
      tidyr::pivot_longer(cols = -xxxx_row_num:-source,
                          names_to = "raw_name",
                          values_to = "values")
    
    # Identify any columns in the data key but apparently not in the data
    missing_cols <- generics::setdiff(x = unique(key_sub$raw_name),
                                      y = unique(dat_v2$raw_name))
    
    # Warn the user if any are found (this is a warning so no `quiet` argument used)
    if(length(missing_cols) != 0){
      rlang::warn(message = paste0("Removing the following columns in data key NOT found in '", focal_file, "': '", missing_cols, "'", collapse = " & ")) }
    
    # Perform actual harmonization
    dat_v3 <- dat_v2 %>% 
      # Attach the data key to the data
      dplyr::left_join(y = key_sub, by = c("source", "raw_name")) %>% 
      # Drop any columns without a standardized name
      dplyr::filter(is.na(tidy_name) != TRUE & nchar(tidy_name) != 0) %>% 
      # Trash the old column names
      dplyr::select(-raw_name) %>% 
      # Pivot back to original format
      tidyr::pivot_wider(names_from = tidy_name, values_from = values) %>% 
      # Trash row number column created in loop
      dplyr::select(-xxxx_row_num)
    
    # Add to list
    file_list[[focal_file]] <- dat_v3
    
  } # Close harmonization loop
  
  # Unlist the list
  files_df <- purrr::list_rbind(x = file_list)
  
  # Return that
  return(files_df) }

# Invoke function
fxn_out <- harmonize(key = data_key, raw_folder = "dev", quiet = F)

# Invoke function where `quiet` is allowed to default to `TRUE`
fxn_out <- harmonize(key = data_key, raw_folder = "dev")

# Look at output
fxn_out

# Clear environment / collect garbage
rm(list = ls()); gc()

# End ----
