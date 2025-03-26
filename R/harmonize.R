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
  raw_name <- NULL
  
  # Check / prepare provided key
  key_actual <- ltertools::check_key(key = key)
  
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
                         .f = ~ ltertools::standardize(focal_file = .x,
                                                       key = key_actual,
                                                       df_list = list_orig))
  
  # Unlist the list
  harmonized_df <- purrr::list_rbind(x = list_std)
  
  # Return that
  return(harmonized_df) }
