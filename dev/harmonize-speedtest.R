# Load needed libraries
librarian::shelf(tidyverse, supportR, microbenchmark, parallel)

# Clear enviro.
rm(list = ls()); gc()

## ----------------------------- ##
# Define / Test V2 ----
## ----------------------------- ##

# Define new function
harm_v2 <- function(key = NULL, raw_folder = NULL, data_format = c("csv", "txt", "xls", "xlsx"), quiet = TRUE){
  # Squelch 'visible bindings' NOTE

  
  # Error out if column key does not contain all needed information
  if(all(c("source", "raw_name", "tidy_name") %in% names(key)) != TRUE)
    stop("Column key must include 'source', 'raw_name' and 'tidy_name' columns")
  
  # Streamline the data key
  key_actual <- key %>% 
    dplyr::select(source, raw_name, tidy_name) %>% 
    dplyr::filter(is.na(tidy_name) != TRUE & nchar(tidy_name) > 0) %>% 
    dplyr::distinct()
  
  # Check for non-unique tidy names
  key_test <- key_actual %>% 
    dplyr::group_by(source) %>% 
    dplyr::summarize(raw_ct = dplyr::n(),
                     tidy_ct = length(unique(tidy_name))) %>% 
    dplyr::filter(raw_ct != tidy_ct)
  
  # Error if any are found
  if(nrow(key_test) != 0){
    stop("Non-unique 'tidy_name' entries found within following dataset(s): ",
         paste(key_test$source, collapse = " & ")) }
  
  # Read in all files in folder of specified type(s)
  list_orig <- ltertools::read(raw_folder = raw_folder, data_format = data_format)
  
  # Identify files in raw folder
  raw_files <- dir(path = raw_folder, pattern = paste0(data_format, collapse = "|"))
  
  # Identify any files present in folder but not in key
  unk_files <- base::setdiff(x = raw_files, y = unique(key_actual$source))
  
  # If any are found and `quiet` isn't `TRUE`, report on these files
  if(length(unk_files) != 0 & quiet != TRUE){
    message("Following files found in raw path but not in key:")
    print(paste0("'", unk_files, "'", collapse = " & ")) }
  
  # Remove unknown files from set of raw files
  known_files <- base::intersect(x = raw_files, y = unique(key_actual$source))
  
  # Create an empty list for storing each harmonized raw file (pre-combination)
  list_std <- list()
  
  # Loop across files that *are* in the column key
  for(focal_file in known_files){
    
    # Subset the key & data list to just this file
    focal_key <- dplyr::filter(.data = key_actual, source == focal_file)
    focal.df_orig <- list_orig[[focal_file]]
    
    # Identify any columns in the column key but apparently not in the data
    missing_cols <- base::setdiff(x = unique(focal_key$raw_name),
                                  y = names(focal.df_orig))
    
    # Warn the user if any are found (this is a warning so no `quiet` argument used)
    if(length(missing_cols) > 0){
      warning(message = paste0("Following columns in key NOT found in '", focal_file, "': '", missing_cols, "'", collapse = " & ")) }
    
    # Identify columns in data but not in key
    untidy_cols <- setdiff(x = names(focal.df_orig), y = unique(focal_key$raw_name))
    
    # Prepare the data for harmonization via column key
    focal.df_std <- focal.df_orig %>% 
      # Keep only coluns with tidy equivalents
      dplyr::select(dplyr::all_of(unique(focal_key$raw_name))) %>% 
      # Make all columns characters
      dplyr::mutate(dplyr::across(.cols = dplyr::everything(),
                                  .fns = as.character)) %>% 
      # Add a filename column
      dplyr::mutate(source = focal_file, .before = dplyr::everything()) %>% 
      # Standardize names with key
      supportR::safe_rename(data = ., bad_names = focal_key$raw_name,
                            good_names = focal_key$tidy_name)
    
    # Add to list
    list_std[[focal_file]] <- focal.df_std } # Close harmonization loop
  
  # Unlist the list
  harmonized_df <- purrr::list_rbind(x = list_std)
  
  # Return that
  return(harmonized_df) }

# # Read in key
# key_obj <- read.csv(file = file.path("dev", "key.csv"))
# dplyr::glimpse(key_obj)
# 
# # Invoke Function
# test_out <- harm_v2(key = key_obj, raw_folder = file.path("dev", "test-data"),
#                     data_format = "csv", quiet = F)
# 
# # Check structure
# dplyr::glimpse(test_out[1:50])

## ----------------------------- ##
# Define / Test V3 ----
## ----------------------------- ##

# Same spirit as v2 but makes greater use of sub-functions

# Checks on key structure / contents
## Streamlines early error checks of `harmonize`
## Potentially useful in and of itself for people making their own keys (maybe)
check_key <- function(key = NULL){
  # Squelch 'visible bindings' NOTE
  
  
  # Error for missing / inappropriate key
  if(is.null(key) || "data.frame" %in% class(key) != T)
    stop("'key' must be provided as a dataframe-like object")
  
  # Error out if column key does not contain all needed information
  if(all(c("source", "raw_name", "tidy_name") %in% names(key)) != TRUE)
    stop("Column key must include 'source', 'raw_name' and 'tidy_name' columns")
  
  # Streamline the data key
  key_actual <- key %>% 
    dplyr::select(source, raw_name, tidy_name) %>% 
    dplyr::filter(is.na(tidy_name) != TRUE & nchar(tidy_name) > 0) %>% 
    dplyr::distinct()
  
  # Check for non-unique tidy names
  key_test <- key_actual %>% 
    dplyr::group_by(source) %>% 
    dplyr::summarize(raw_ct = dplyr::n(),
                     tidy_ct = length(unique(tidy_name))) %>% 
    dplyr::filter(raw_ct != tidy_ct)
  
  # Error if any are found
  if(nrow(key_test) != 0){
    stop("Non-unique 'tidy_name' entries found within following dataset(s): ",
         paste(key_test$source, collapse = " & ")) }
  
  # Return refined key object
  return(key_actual) }

# Single-file standardization sub-function
## Allows replacing loop with `purrr::map`
## Enables (future) parallelization
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

# Define new function
harm_v3 <- function(key = NULL, raw_folder = NULL, data_format = c("csv", "txt", "xls", "xlsx"), quiet = TRUE){
  # Squelch 'visible bindings' NOTE
  
  # Check / prepare provided key
  key_actual <- check_key(key = key)
  
  # Read in all files in folder of specified type(s)
  list_orig <- ltertools::read(raw_folder = raw_folder, data_format = data_format)
  
  # Identify files in raw folder
  raw_files <- dir(path = raw_folder, pattern = paste0(data_format, collapse = "|"))
  
  # Identify any files present in folder but not in key
  unk_files <- base::setdiff(x = raw_files, y = unique(key_actual$source))
  
  # If any are found and `quiet` isn't `TRUE`, report on these files
  if(length(unk_files) != 0 & quiet != TRUE){
    message("Following files found in raw path but not in key:")
    print(paste0("'", unk_files, "'", collapse = " & ")) }
  
  # Remove unknown files from set of raw files
  known_files <- base::intersect(x = raw_files, y = unique(key_actual$source))
  
  # Standardize each data file
  list_std <- purrr::map(.x = known_files,
                         .f = ~ standardize(focal_file = .x,
                                            key = key_actual,
                                            df_list = list_orig))
  
  # Unlist the list
  harmonized_df <- purrr::list_rbind(x = list_std)
  
  # Return that
  return(harmonized_df) }

# # Read in key
# key_obj <- read.csv(file = file.path("dev", "key.csv"))
# dplyr::glimpse(key_obj)
# 
# # Invoke Function
# test_out <- harm_v3(key = key_obj, raw_folder = file.path("dev", "test-data"),
#                     data_format = "csv", quiet = F)
# 
# # Check structure
# dplyr::glimpse(test_out[1:50])

## ----------------------------- ##
# Speed Tests ----
## ----------------------------- ##

# Get needed input(s)
# Read in key
key_obj <- read.csv(file = file.path("dev", "key.csv"))
dplyr::glimpse(key_obj)

# Speed test new vs. old harmonize functions
# Actually do speed testing
microbenchmark::microbenchmark(
  
  # Old Version
  cran_harmony <- ltertools::harmonize(key = key_obj, raw_folder = file.path("dev", "test-data"),
                                       data_format = "csv", quiet = F),
  
  # Upgraded version
  v2_harmony <- harm_v2(key = key_obj, raw_folder = file.path("dev", "test-data"),
                        data_format = "csv", quiet = F),
  
  # Refactored variant of upgrade (uses sub-functions)
  v3_harmony <- harm_v3(key = key_obj, raw_folder = file.path("dev", "test-data"),
                        data_format = "csv", quiet = F),
  
  # Number of times to test
  times = 15) # Close `microbenchmark`


# March 26, 2025 -- Speed Test Results:
## ver   min        lq        mean      median     uq        max       neval  cld
## CRAN  19.454487  20.45221  22.15415  23.10916   23.56972  24.45299  15     a 
## v2    7.222776   10.37443  11.26496  11.51429   11.99468  14.55221  15     b
## v3   9.524724    10.33883  11.12759  11.13571   11.52320  13.79922  15     b

# March 25, 2025 -- Speed Test Results:
## ver.    min         lq          mean         median       uq          max      neval  cld
## CRAN    14.995852   18.674327   19.76731     19.31185     20.57290    26.03305  50     a 
## v2     7.908361     8.399373    12.18750     12.25346     15.02888    18.68110  50     b

# End ----
