#' @title Read Data from Folder
#' 
#' @description Reads in all data files of specified types found in the designated folder. Returns a list with one element for each data file. Currently supports CSV, TXT, XLS, and XLSX
#' 
#' @param raw_folder (character) folder / folder path containing data files to read
#' @param data_format (character) file extensions to identify within the `raw_folder`. Default behavior is to search for all supported file types.
#' 
#' @return (list) data found in specified folder of specified file format(s)
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
#' # Read in all CSV files in that folder
#' read(raw_folder = temp_folder, data_format = "csv")
#' 
read <- function(raw_folder = NULL, data_format = c("csv", "txt", "xls", "xlsx")){
  
  # Error out for missing raw folder
  if(is.null(x = raw_folder) == TRUE)
    stop("Raw folder must be specified")
  
  # Make sure periods are not included in file extensions and drop non-unique entries
  formats <- unique(gsub(pattern = "\\.", replacement = "", x = data_format))
  
  # Check for unsupported file types
  bad_ext <- generics::setdiff(x = formats, y = c("csv", "txt", "xls", "xlsx"))
  
  # Warn / skip unsupported file types
  if(length(bad_ext) != 0){
    
    # Removal of unsupported file types
    formats <- generics::setdiff(x = formats, y = bad_ext)
    
    # Warning about them
    message("The following are not supported file types and will be ignored: ", paste(bad_ext, collapse = "; ")) }
  
  # Make an empty list
  type_list <- list()
  
  # Loop across user-supplied file extensions
  for(ext in formats){
    
    # Check for files of that type in the folder
    found_vec <- dir(path = raw_folder, pattern = paste0(".", ext))
    
    # For the check of ".xls" files we need to do an additional step
    if(ext == "xls"){
      
      # Identify any modern Excel files (.xlsx) were found
      modern_excel <- stringr::str_detect(string = found_vec, pattern = ".xlsx")
      
      # And remove them (they'll be found by the dedicated check for their file extension)
      found_vec <- generics::setdiff(x = found_vec, y = found_vec[modern_excel]) }
    
    # If at least one file is found:
    if(length(x = found_vec) != 0){
      # Create a simple dataframe and add to the list
      type_list[[ext]] <- data.frame("name" = found_vec,
                                     "type" = ext) } 
  } # Close file type loop
  
  # Unlist the type list
  type_df <- purrr::list_rbind(x = type_list)
  
  # Error out if no supported files are found in the specified folder
  if(nrow(type_df) == 0)
    stop("No files of supported type(s) found in specified folder")
  
  # Create a new list
  data_list <- list()
  
  # Loop across rows of the type dataframe
  for(k in 1:nrow(type_df)){
    
    # CSV Files
    if(type_df[k,]$type %in% c("csv")){
      # Read in
      data <- utils::read.csv(file = file.path(raw_folder, type_df[k,]$name))
      
      # Add to list
      data_list[[type_df[k,]$name]] <- data }
    
    # TXT files
    if(type_df[k,]$type %in% c("txt")){
      # Read in
      data <- utils::read.delim(file = file.path(raw_folder, type_df[k,]$name))
      
      # Add to list
      data_list[[type_df[k,]$name]] <- data }
    
    # Microsoft Excel files
    if(type_df[k,]$type %in% c("xls", "xlsx")){
      # Read in
      data <- readxl::read_excel(path = file.path(raw_folder, type_df[k,]$name))
      
      # Add to list
      data_list[[type_df[k,]$name]] <- data }
    
  } # Close loop
  
  # Return that list
  return(data_list) }
