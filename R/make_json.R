#' @title Make a JSON File with Specified Contents
#' 
#' @description Creates a JSON (JavaScript Object Notation) file containing the specified name/value pairs. These files are hugely flexible and interpretable by a wide variety of coding languages and thus extremely useful in many contexts. This function is meant to assist those who wish to use JSON files to store user-specific information (e.g., email addresses, absolute file paths, etc.) in collaborative contexts.
#' 
#' @param x (character) named vector from which to generate JSON content. Vector elements become JSON values and the vector element names become JSON names. A named vector can be created like so: `c("greeting" = "hello", "farewell" = "goodbye")`. The characters on the left of the equal signs are names and the characters on the right are values.
#' @param file (character) name of JSON file to create with contents provided to `x`. Must end with ".json"
#' @param git_ignore (logical) whether to add the file name (defined in `file`) to the '.gitignore' if one exists. Defaults to FALSE
#' 
#' @return Nothing. Called for side-effects (i.e., creating JSON file)
#' 
#' @export
#' 
#' @examples
#' # Create contents
#' my_info <- c("data_path" = "Users/me/documents/my_project/data")
#' 
#' # Generate a local folder for exporting
#' temp_folder <- tempdir()
#' 
#' # Create a JSON with those contents
#' make_json(x = my_info, file = file.path(temp_folder, "user.json"), git_ignore = FALSE)
#' 
#' # Read it back in
#' (user_info <- RJSONIO::fromJSON(content = file.path(temp_folder, "user.json")))
#' 
make_json <- function(x = NULL, file = NULL, git_ignore = FALSE){
  
  # Error for null and/or non-character 'x' argument
  if(is.null(x) == TRUE || is.character(x) != TRUE)
    stop("`x` must be a character vector")
  
  # Error for null and/or non-character 'file' argument
  if(is.null(file) == TRUE || is.character(file) != TRUE)
    stop("`file` must be a character vector")
  
  # Error for missing names in 'x'
  if(is.null(names(x)) == TRUE)
    stop("`x` must be a named character vector")
  
  # Remove empty/bad names
  names_found <- names(x)[!names(x) %in% c("")]
  
  # Error for different length of names/values
  if(length(names_found) != length(x))
    stop("All elements of `x` must have a name")
  
  # Error for non-unique names
  if(length(names_found) != length(unique(names_found)))
    stop("Each element of `x` must have a unique name")
  
  # Error for too many file names (in 'file')
  if(length(file) != 1)
    stop("`file` must be only a single JSON file name")
  
  # Error for non-JSON file name (in 'file')
  if(tools::file_ext(x = file) != "json")
    stop("`file` must end in '.json'")
  
  # Warning for malformed logical
  if(is.logical(git_ignore) != TRUE){
    warning("`git_ignore` must be a logical. Coercing to FALSE")
    git_ignore <- FALSE }
  
  # Transform contents to JSON format
  json_content <- RJSONIO::toJSON(x = x)
  
  # Export
  write(x = json_content, file = file)
  
  # If desired, add 'file' to .gitignore
  if(git_ignore == TRUE){
    
    # Give warning & skip if no .gitignore is found
    if(file.exists(".gitignore") != TRUE){
      warning("No '.gitignore' file found in working directory.\nNothing added to file.")
      
      # If .gitignore' *is* found...
    } else {
      
      # Read in .gitignore
      ignore_v1 <- readLines(con = ".gitignore")
      
      # Add file
      ignore_v2 <- c(ignore_v1, "", basename(file))
      
      # Save it out
      write(x = ignore_v2, file = ".gitignore")
    }
  }
}
