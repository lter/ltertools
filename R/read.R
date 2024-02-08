#' @title Read Data from Folder
#' 
#' @description Reads in all data files of specified types found in the designated folder. Returns a list with one element for each data file. Currently supports CSV, TXT, XLS, and XLSX. This function was built by the following authors: Nicholas Lyon
#' 
#' @param raw_folder (character) folder / folder path containing data files to read
#' @param data_formats (character) file extensions to identify within the `raw_folder`. Default behavior is to search for all supported file types.
#' 
#' @return (list) data found in specified folder / of specified file format
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' # Read in all CSV files in the "raw_data" folder
#' df_list <- read(raw_folder = "raw_data", data_formats = "csv")
#' }
#' 
read <- function(raw_folder = NULL, data_formats = c("csv", "txt", "xls", "xlsx")){
  # raw_folder <- file.path("dev", "testing")
  # data_formats <- c(".csv", ".txt", ".xls", ".xlsx", "xlsx")
  
  # Error out for missing raw folder
  if(is.null(x = raw_folder) == TRUE)
    stop("Raw folder must be specified")
  
  # # Check for unsupported file types
  # bad_ext <- setdiff(x = data_formats, y = c("csv", "txt", "xls", "xlsx"))
  # 
  # # Warn / skip unsupported file types
  # if(length(bad_ext) != 0){
  #   
  #   message()
  #   
  # }

    # Make sure periods are not included in file extensions and drop non-unique entries
  formats <- unique(gsub(pattern = "\\.", replacement = "", x = data_formats))
  
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
      found_vec <- setdiff(x = found_vec, y = found_vec[modern_excel]) }
    
    # Create a simple dataframe for storing this information
    found_df <- data.frame("name" = found_vec,
                           "type" = ext)
    
    # Add to the list
    type_list[[ext]] <- found_df } # Close file type loop
  
  # Unlist the type list
  type_df <- purrr::list_rbind(x = type_list)
  
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
