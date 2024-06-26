#' @title Harmonize Data via a Column Key
#' 
#' @description A "column key" is meant to streamline harmonization of disparate datasets. This key must include three columns containing: (1) the name of each raw data file to be harmonized, (2) the name of all of the columns in each of those files, and (3) the "tidy name" that corresponds to each raw column name. This function accepts that key and the path to a folder containing all raw data files included in the key. Each dataset is then read in and the original column names are replaced with their respective "tidy_name" indicated in the key. Once this has been done to all files, a single dataframe is returned with only columns indicated in the column name. Currently the following file formats are supported for the raw data: CSV, TXT, XLS, and XLSX
#' 
#' Note that raw column names without an associated tidy name in the key are removed. We recommend using the `begin_key` function in this package to generate the skeleton of the key to make achieving the required structure simpler. 
#'
#' @param key (dataframe) key object including a "source", "raw_name" and "tidy_name" column. Additional columns are allowed but ignored
#' @param raw_folder (character) folder / folder path containing data files to include in key
#' @param data_format (character) file extensions to identify within the `raw_folder`. Default behavior is to search for all supported file types.
#' @param quiet (logical) whether to suppress certain non-warning messages. Defaults to `TRUE`
#' 
#' @return (dataframe) harmonized dataframe including all columns defined in the "tidy_name" column of the key object
#' 
#' @importFrom magrittr %>% 
#' 
#' @export
#' 
#' @examples
#' # Generate two simple tables
#' ## Dataframe 1
#' df1 <- data.frame("xx" = c(1:3),
#'                   "unwanted" = c("not", "needed", "column"),
#'                   "yy" = letters[1:3])
#' ## Dataframe 2
#' df2 <- data.frame("LETTERS" = letters[4:7],
#'                   "NUMBERS" = c(4:7),
#'                   "BONUS" = c("plantae", "animalia", "fungi", "protista"))
#' 
#' # Generate a local folder for exporting
#' temp_folder <- tempdir()
#' 
#' # Export both files to that folder
#' utils::write.csv(x = df1, file = file.path(temp_folder, "df1.csv"), row.names = FALSE)
#' utils::write.csv(x = df2, file = file.path(temp_folder, "df2.csv"), row.names = FALSE)
#' 
#' # Generate a column key object manually
#' key_obj <- data.frame("source" = c(rep("df1.csv", 3), 
#'                                    rep("df2.csv", 3)),
#'                       "raw_name" = c("xx", "unwanted", "yy",
#'                                      "LETTERS", "NUMBERS", "BONUS"),
#'                     "tidy_name" = c("numbers", NA, "letters",
#'                                     "letters", "numbers", "kingdom"))
#' 
#' # Use that to harmonize the 'raw' files we just created
#' ltertools::harmonize(key = key_obj, raw_folder = temp_folder, data_format = "csv")
#' 
harmonize <- function(key = NULL, raw_folder = NULL, data_format = c("csv", "txt", "xls", "xlsx"), quiet = TRUE){
  # Squelch 'visible bindings' NOTE
  . <- raw_name <- tidy_name <- xxxx_row_num <- values <- ct <- NULL

  # Error out if column key does not contain all needed information
  if(all(c("source", "raw_name", "tidy_name") %in% names(key)) != TRUE)
    stop("Column key must include 'source', 'raw_name' and 'tidy_name' columns")
  
  # Drop any unnecessary column key columns
  key_actual <- key %>% 
    dplyr::select(source, raw_name, tidy_name) %>% 
    dplyr::distinct()
  
  # Read in all files in folder of specified type(s)
  df_list <- ltertools::read(raw_folder = raw_folder, data_format = data_format)
  
  # Collapse data formats into a 1-element vector
  formats <- paste0(data_format, collapse = "|")
  
  # Identify available raw files *that are also present in the column key*
  raw_files <- base::intersect(x = dir(path = raw_folder, pattern = formats),
                               y = unique(key_actual$source))
  
  # Identify any files present but not in column key
  unk_files <- base::setdiff(x = dir(path = raw_folder, pattern = formats),
                             y = unique(key_actual$source))
  
  # If any are found and `quiet` isn't `TRUE`, report on these files
  if(length(unk_files) != 0 & quiet != TRUE){
    message("Following files found in raw path but not in column key:")
    print(paste0("'", unk_files, "'", collapse = " & ")) }
  
  # Create an empty list for storing each harmonized raw file (pre-combination)
  file_list <- list()
  
  # Loop across files that *are* in the column key
  for(focal_file in raw_files){

    # Prepare the column key
    key_sub <- key_actual %>% 
      # Subset to just this file
      dplyr::filter(source == focal_file) %>% 
      # Drop any instances where the harmonized name is absent
      ## (assuming that raw column is unwanted in harmonized data object)
      dplyr::filter(is.na(tidy_name) != TRUE & nchar(tidy_name) != 0)
    
    # Error out if duplicate tidy names are discovered
    if(nrow(key_sub) != length(unique(key_sub$tidy_name)))
      stop("All 'tidy_name' entries must be unique")
    
    # Grab that file from the list generated by `ltertools::read`
    dat_v1 <- df_list[[focal_file]]
    
    # Prepare the data for harmonization via column key
    dat_v2 <- dat_v1 %>% 
      # Add a source column and row number column to preserve original rows
      ## (name is bizarre to avoid overwriting extant column name)
      dplyr::mutate(xxxx_row_num = 1:nrow(x = .),
                    source = focal_file) %>% 
      # Make all columns characters
      dplyr::mutate(dplyr::across(.cols = dplyr::everything(),
                                  .fns = as.character)) %>% 
      # Pivot the data into 'ultimate' long format
      tidyr::pivot_longer(cols = -xxxx_row_num:-source,
                          names_to = "raw_name",
                          values_to = "values")
    
    # Identify any columns in the column key but apparently not in the data
    missing_cols <- base::setdiff(x = unique(key_sub$raw_name),
                                  y = unique(dat_v2$raw_name))
    
    # Warn the user if any are found (this is a warning so no `quiet` argument used)
    if(length(missing_cols) != 0){
      warning(message = paste0("Removing the following columns in column key NOT found in '", focal_file, "': '", missing_cols, "'", collapse = " & ")) }
    
    # Attach tidy names
    dat_v3 <- dat_v2 %>% 
      # Attach the column key to the data
      dplyr::left_join(y = key_sub, by = c("source", "raw_name")) %>% 
      # Drop any columns without a standardized name
      dplyr::filter(is.na(tidy_name) != TRUE & nchar(tidy_name) != 0) %>% 
      # Trash the old column names
      dplyr::select(-raw_name)
      
    # Check for problem columns that will create list-cols
    list_check <- dat_v3 %>% 
      # Count rows within combinations of known grouping variables
      dplyr::group_by(xxxx_row_num, source, tidy_name) %>% 
      dplyr::summarize(ct = dplyr::n()) %>% 
      dplyr::ungroup() %>% 
      # Filter to only instances with duplicates
      dplyr::filter(ct > 1)
    
    # Return a warning if any problems found
    if(nrow(list_check) != 0){
      warning(message = paste0("Replicates (i.e., rows) will not be uniquely identified. Following columns result in this issue for ", focal_file, "': '", unique(list_check$tidy_name), "'", collapse = " & ")) }
      
    # Perform actual harmonization
    dat_v4 <- dat_v3 %>% 
      # Pivot back to original format
      tidyr::pivot_wider(names_from = tidy_name, values_from = values) %>% 
      # Trash row number column created in loop
      dplyr::select(-xxxx_row_num)
    
    # Add to list
    file_list[[focal_file]] <- dat_v4 } # Close harmonization loop
  
  # Unlist the list
  files_df <- purrr::list_rbind(x = file_list)
  
  # Return that
  return(files_df) }
