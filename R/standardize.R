#' @title Standardize a Single Dataset via a Column Key
#' 
#' @description A "column key" is meant to streamline harmonization of disparate datasets. This key must include three columns containing: (1) the name of each raw data file to be harmonized, (2) the name of all of the columns in each of those files, and (3) the "tidy name" that corresponds to each raw column name. This function accepts that key and a list of datasets that can be standardized with that key. The function standardizes the specified dataset out of any number of datasets in the key or list. While usable on its own, this function is intended to streamline internal operations of `ltertools::harmonize` -- which is the recommended tool for key-based harmonization.
#' 
#' @param focal_file (character) filename corresponding to one value of "source" column of "key" data and to one name in "df_list".
#' @param key (dataframe) key object including a "source", "raw_name" and "tidy_name" column. Additional columns are allowed but ignored
#' @param df_list (list) named list of dataframe-like objects where each name is the filename initially containing that data
#' 
#' @return (dataframe) single standardized dataframe including all columns defined in the "tidy_name" column of the key object
#' 
#' @importFrom magrittr %>% 
#' 
#' @export
#' 
#' @examples
#' #' # Generate two simple tables
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
#' # Read in list of these data files
#' data_list <- ltertools::read(raw_folder = temp_folder, data_format = "csv")
#'  
#' # Generate a column key object manually
#' key_obj <- data.frame("source" = c(rep("df1.csv", 3), 
#'                                    rep("df2.csv", 3)),
#'                       "raw_name" = c("xx", "unwanted", "yy",
#'                                      "LETTERS", "NUMBERS", "BONUS"),
#'                     "tidy_name" = c("numbers", NA, "letters",
#'                                     "letters", "numbers", "kingdom"))
#' # Standardize one dataset
#' standardize(focal_file = "df1.csv", key = key_obj, df_list = data_list)      
#'
standardize <- function(focal_file = NULL, key = NULL, df_list = NULL){
  # Squelch visible bindings note
  . <- NULL
  
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
