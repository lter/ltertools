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
df1 <- data.frame("x" = c(1:3),
                  "y" = letters[1:3])
df2 <- data.frame("LETTERS" = letters[4:6],
                  "NUMBERS" = c(4:6))

# Export both of these for later re-use
write.csv(df1, file = file.path("dev", "test_df1.csv"), na = "", row.names = F)
write.csv(df2, file = file.path("dev", "test_df2.csv"), na = "", row.names = F)

# Create data key
key <- data.frame("source" = c("test_df1.csv", "test_df1.csv", 
                               "test_df2.csv", "test_df2.csv"),
                  "raw_name" = c("x", "y", "NUMBERS", "LETTERS"),
                  "harmony_name" = c("numbers", "letters", "numbers", "letters"))

## ----------------------------------- ##
          # Script Variant ----
## ----------------------------------- ##
# Data key harmonization _in script format_

# Make an empty list
file_list <- list()

# Loop across files named in the data key
for(file in unique(key$source)){
  ## file <- "test_df1.csv"
  
  # Prepare the data key
  key_sub <- key %>% 
    # Subset to just this file
    dplyr::filter(source == file) %>% 
    # Drop any instances where the harmonized name is absent (i.e., the raw column is unwanted)
    dplyr::filter(is.na(harmony_name) != TRUE & nchar(harmony_name) != 0)
  
  # Read in file
  df_v1 <- read.csv(file = file.path("dev", file))
  
  # Prepare the data for harmonization via data key
  df_v2 <- df_v1 %>% 
    # Add a row number column to preserve original rows
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
  
  # Identify any columns in the data key but apparently not in the data key
  missing_cols <- setdiff(x = unique(key_sub$raw_name),
                          y = unique(df_v2$raw_name))
  
  # Warn the user if any are found
  if(length(missing_cols) != 0){
    message("Following columns in ", file, " _not_ found in data key")
    print(missing_cols) }
  
  # Drop the missing cols object for the next iteration of the loop
  missing_cols <- NULL
  
  # Perform actual harmonization
  df_v3 <- df_v2 %>% 
    # Attach the data key to the data
    dplyr::left_join(y = key_sub, by = c("source", "raw_name")) %>% 
    # Drop any columns without a standardized name
    dplyr::filter(is.na(harmony_name) != TRUE & nchar(harmony_name) != 0) %>% 
    # Trash the old column names
    dplyr::select(-raw_name) %>% 
    # Pivot back to original format
    tidyr::pivot_wider(names_from = harmony_name, values_from = values) %>% 
    # Trash row number column created in loop
    dplyr::select(-xxxx_row_num)
  
  # Add to list
  file_list[[file]] <- df_v3 }

# Unlist the list
harmonized_df <- purrr::list_rbind(x = file_list)

# Check that out
harmonized_df


## ----------------------------------- ##
# Function Variant ----
## ----------------------------------- ##
# Data key harmonization _in function format_








# Clear environment / collect garbage
rm(list = ls()); gc()

# End ----
