# Load libraries
librarian::shelf(tidyverse, ltertools)

# Clear environment
rm(list = ls()); gc()

standardize <- function(focal_file = NULL, key = NULL, df_list = NULL){
  
  # Grab single key/data component
  focal_key <- dplyr::filter(key, source == focal_file)
  focal.df_orig <- df_list[[focal_file]]
  
  # Identify any columns in the column key but apparently not in the data
  missing_cols <- base::setdiff(x = unique(focal_key$raw_name),
                                y = names(focal.df_orig))
  
  # Warn the user if any are found (this is a warning so no `quiet` argument used)
  if(length(missing_cols) > 0){
    warning(message = paste0("Following columns in key NOT found in '", focal_file, "': '", missing_cols, "'", collapse = " & ")) }
  
  # Standardize this dataset
  focal.df_std <- focal.df_orig %>% 
    # Keep only columns with tidy equivalents
    dplyr::select(dplyr::all_of(unique(focal_key$raw_name))) %>% 
    # Make all columns characters
    dplyr::mutate(dplyr::across(.cols = dplyr::everything(),
                                .fns = as.character)) %>% 
    # Add a filename column
    dplyr::mutate(source = focal_file, .before = dplyr::everything()) %>% 
    # Standardize names with key
    supportR::safe_rename(data = ., bad_names = focal_key$raw_name,
                          good_names = focal_key$tidy_name)
  
  # Return the standard object
  return(focal.df_std) }

# Read in key
key_raw <- read.csv(file = file.path("dev", "key.csv"))
key_obj <- check_key(key = key_raw)
dplyr::glimpse(key_obj)

# Get list of raw files
data_list <- ltertools::read(raw_folder = file.path("dev", "test-data"),
                            data_format = "csv")
dplyr::glimpse(data_list[[10]])

# Invoke function
test_std <- standardize(key = key_obj, df_list = data_list, focal_file = names(data_list[10]))
dplyr::glimpse(test_std)
