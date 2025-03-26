# Load libraries
libarian::shelf(tidyverse, ltertools)

# Clear environment
rm(list = ls()); gc()

# Function for checking data key structure / contents
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

# Read in key
key_obj <- read.csv(file = file.path("dev", "key.csv"))
dplyr::glimpse(key_obj)

# Test me
key_checked <- check_key(key = key_obj)
dplyr::glimpse(key_checked)
