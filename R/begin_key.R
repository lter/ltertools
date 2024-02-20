#' @title Generate the Skeleton of a Column Key
#'
#' @description Creates the start of a 'column key' for harmonizing data. A column key includes a column for the file names to be harmonized into a single data object as well as a column for the column names in those files. Finally, it includes a column indicating the tidied name that corresponds with each raw column name. Harmonization can accept this key object and use it to rename all raw column names--in a reproducible way--to standardize across datasets. Currently supports raw files of the following formats: CSV, TXT, XLS, and XLSX
#' 
#' @param raw_folder (character) folder / folder path containing data files to include in key
#' @param data_format (character) file extensions to identify within the `raw_folder`. Default behavior is to search for all supported file types.
#' @param guess_tidy (logical) whether to attempt to "guess" what the tidy name equivalent should be for each raw column name. This is accomplished via coercion to lowercase and removal of special character/repeated characters. If `FALSE` (the default) the "tidy_name" column is returned empty
#' 
#' @return (dataframe) skeleton of column key 
#' 
#' @importFrom magrittr %>%
#' 
#' @export
#' 
#' @examples
#' \dontrun{
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
#' dir.create(path = "ltertools_test", showWarnings = FALSE)
#' 
#' # Export both files to that folder
#' utils::write.csv(x = df1, file = file.path("ltertools_test", "df1.csv"), row.names = FALSE)
#' utils::write.csv(x = df2, file = file.path("ltertools_test", "df2.csv"), row.names = FALSE)
#' 
#' # Generate a column key with "guesses" at tidy column names
#' ltertools::begin_key(raw_folder = "ltertools_test", data_format = "csv", guess_tidy = TRUE)
#' }
#' 
begin_key <- function(raw_folder = NULL, data_format = c("csv", "txt", "xls", "xlsx"), guess_tidy = FALSE){
  # Squelching 'visible bindings' NOTE
  raw_name <- tidy_name <- NULL
  lower_name <- no_paren_end <- no_spec_char <- no_dups <- no_trail_score <- NULL
  
  # Warn if `guess_tidy` isn't a logical and coerce to FALSE
  if(is.logical(guess_tidy) != TRUE){
    guess_tidy <- FALSE
    message("`guess_tidy` argument must be provided as TRUE or FALSE; defaulting to FALSE") }
    
  # Read in all files in folder of specified type
  df_list <- ltertools::read(raw_folder = raw_folder, data_format = data_format)
  
  # Error out if no files are in that folder
  if(length(df_list) == 0)
    stop("No files of supported file types found in supplied path")
  
  # Make an empty list
  key_list <- list()
  
  # Loop across elements of the list provided by `read`
  for(g in 1:length(df_list)){
    
    # Identify file name
    file_name <- names(df_list)[g]
    
    # Identify the column names within that file
    col_names <- names(df_list[[g]])
    
    # Assemble this facet of the column key and add to the list
    key_list[[file_name]] <- data.frame("source" = file_name,
                                        "raw_name" = col_names) }
  
  # Unlist into a dataframe
  key_df <- purrr::list_rbind(x = key_list)
  
  # Create a column for the tidy name
  ## If `guess_tidy` is TRUE attempt to "guess" each raw name's tidy equivalent
  if(guess_tidy == TRUE){
    key_skeleton <- key_df %>% 
      # Wrangling performed one step at a time
      dplyr::mutate(
        # Make lowercase
        lower_name = tolower(raw_name),
        # Drop any trailing parentheses
        no_paren_end = gsub(pattern = "\\)", replacement = "", x = lower_name),
        # Coerce all special characters to underscores
        no_spec_char = gsub(pattern = "\\.| |\\-|\\/|\\(", 
                            replacement = "_", x = no_paren_end),
        # Remove runs of multiple underscores and replace with just one
        no_dups = gsub(pattern = "_+", replacement = "_", x = no_spec_char),
        # If the final character is an underscore, remove it
        no_trail_score = ifelse(test = stringr::str_sub(string = no_dups, 
                                                        start = nchar(no_dups), 
                                                        end = nchar(no_dups)) == "_",
                                yes = stringr::str_sub(string = no_dups, 
                                                       start = 1, 
                                                       end = nchar(no_dups) - 1),
                                no = no_dups)
        # Finish `mutate` call for wrangling
      ) %>% 
      # After this, name the final one appropriately
      dplyr::rename(tidy_name = no_trail_score) %>% 
      # And drop any intermediary columns (implicitly)
      dplyr::select(source, raw_name, tidy_name)

    ## Otherwise, simply create an empty column with the correct name
  } else { key_skeleton <- dplyr::mutate(.data = key_df, tidy_name = NA) }
  
  # Return the key skeleton
  return(key_skeleton) }
