#' @title Generate the Skeleton of a Column Key for Only New Data Files
#' 
#' @description Data discovery--and harmonization--is an iterative process. For those already depending upon a column key and the `harmonize` function, it can be cumbersome to add rows to an existing column key. This function formats rows for an existing column key for only datasets that are not already (A) in the column key or (B) in the harmonized data table.
#' 
#' @param key (dataframe) key object including a "source", "raw_name" and "tidy_name" column. Additional columns are allowed but ignored
#' @param raw_folder (character) folder / folder path containing data files to include in key
#' @param harmonized_df (dataframe) harmonized data table produced with the current version of the column key. Must include a "source" column but other columns are ignored.
#' @param data_format (character) file extensions to identify within the `raw_folder`. Default behavior is to search for all supported file types.
#' @param guess_tidy (logical) whether to attempt to "guess" what the tidy name equivalent should be for each raw column name. This is accomplished via coercion to lowercase and removal of special character/repeated characters. If `FALSE` (the default) the "tidy_name" column is returned empty
#' 
#' @return (dataframe) skeleton of rows to add to column key for data sources not already in harmonized data table
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
#' # Generate a column key with "guesses" at tidy column names
#' key1 <- ltertools::begin_key(raw_folder = temp_folder, data_format = "csv", guess_tidy = TRUE)
#' 
#' # Harmonize the data
#' harmony <- ltertools::harmonize(key = key1, raw_folder = temp_folder)
#' 
#' # Make a new data file
#' df3 <- data.frame("xx" = c(10:15),
#'                   "letters" = letters[10:15])
#' 
#' # Export this locally to the temp folder too
#' utils::write.csv(x = df3, file = file.path(temp_folder, "df3.csv"), row.names = FALSE)
#' 
#' # Identify what needs to be added to the existing column key
#' ltertools::expand_key(key = key1, raw_folder = temp_folder, harmonized_df = harmony,
#'                       data_format = "csv", guess_tidy = TRUE)
#' 
expand_key <- function(key = NULL, raw_folder = NULL, harmonized_df = NULL, 
                       data_format = c("csv", "txt", "xls", "xlsx"), guess_tidy = FALSE){
  
  # Error out if column key does not contain all needed information
  if(all(c("source", "raw_name", "tidy_name") %in% names(key)) != TRUE)
    stop("Column key must include 'source', 'raw_name' and 'tidy_name' columns")
  
  # Error if harmonized data is not a dataframe / isn't formatted right
  if("data.frame" %in% class(harmonized_df) != T)
    stop("'harmonized_df' must be dataframe-like")
  if("source" %in% names(harmonized_df) != T)
    stop("'harmonized_df' must include a column named 'source'")
  
  # Make a fresh key using all data in the raw folder
  ## Error checks for these arguments already handled by `begin_key`
  fresh_key <- ltertools::begin_key(raw_folder = raw_folder, 
                                    data_format = data_format, 
                                    guess_tidy = guess_tidy)
  
  # Pare that down to only the new files
  new_key_only <- fresh_key %>% 
    # Remove files already in the data key
    dplyr::filter(!source %in% key$source) %>% 
    # Remove files already in the harmonized data
    dplyr::filter(!source %in% harmonized_df$source)
  
  # Return that
  return(new_key_only) }
