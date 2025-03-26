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
  . <- raw_name <- tidy_name <- xxxx_row_num <- values <- ct <- NULL
  
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

# Read in key
key_obj <- read.csv(file = file.path("dev", "key.csv"))
dplyr::glimpse(key_obj)

# Invoke Function
test_out <- harm_v2(key = key_obj, raw_folder = file.path("dev", "test-data"),
                    data_format = "csv", quiet = F)

# Check structure
dplyr::glimpse(test_out[1:50])

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
  
  # Number of times to test
  times = 50) # Close `microbenchmark`

# March 25, 2025 -- Speed Test Results:
## ver.    min         lq          mean         median       uq          max      neval  cld
## CRAN    14.995852   18.674327   19.76731     19.31185     20.57290    26.03305  50     a 
## v2     7.908361     8.399373    12.18750     12.25346     15.02888    18.68110  50     b

# End ----
