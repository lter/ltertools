#' @title Check and Prepare a Column Key Object
#' 
#' @description Accepts a column key dataframe and checks to make sure it has the needed structure for `ltertools::harmonize`. Also removes unnecessary columns and rows that lack a "tidy_name". Function invoked 'under the hood' by `ltertools::harmonize`.
#' 
#' @param key (dataframe) key object including a "source", "raw_name" and "tidy_name" column. Additional columns are allowed but ignored
#' 
#' @return (dataframe) key object with only "source", "raw_name" and "tidy_name" columns and only retains rows where a "tidy_name" is specified.
#' 
#' @importFrom magrittr %>% 
#' 
#' @export
#' 
#' @examples
#' # Generate a column key object manually
#' key_obj <- data.frame("source" = c(rep("df1.csv", 3), 
#'                                    rep("df2.csv", 3)),
#'                       "raw_name" = c("xx", "unwanted", "yy",
#'                                      "LETTERS", "NUMBERS", "BONUS"),
#'                     "tidy_name" = c("numbers", NA, "letters",
#'                                     "letters", "numbers", "kingdom"))
#' 
#' # Check it
#' check_key(key = key_obj)
#' 
check_key <- function(key = NULL){
  # Squelch 'visible bindings' NOTE
  raw_ct <- tidy_ct <- raw_name <- tidy_name <- NULL
  
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
