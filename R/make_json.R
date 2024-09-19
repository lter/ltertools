## --------------------------------------------------- ##
                    # Write JSON Function
## --------------------------------------------------- ##
# Author(s): Nick J Lyon

# Purpose:
## We want a function that makes (simple) JSON files that contain user-defined content
## Useful for housing user-specific information (incl. absolute file paths, emails, etc.)

# Load libraries
librarian::shelf(jsonlite, RJSONIO)

# Clear environment
rm(list = ls())

# Define function
make_json <- function(x = NULL, file = NULL){
  
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
    stop("'file' must end in '.json'")
  
  # Transform contents to JSON format
  json_content <- RJSONIO::toJSON(x = x)
  
  # Export
  write(x = json_content, file = file) }

# Invoke function
make_json(x = c("greeting" = "hello", "farewell" = "goodbye"),
          file = file.path("dev", "test.json"))

# Read in JSON and see if it looks 'right'
(user_info <- jsonlite::read_json(file.path("dev", "test.json")))

# Try to access an element
user_info$farewell

# Test errors
make_json(file = "hello")
make_json(x = "hello")
make_json(x = 1:3, file = file.path("dev", "test.json"))
make_json(x = "hello", file = file.path("dev", "test.json"))
make_json(x = c("greeting" = "hello", "goodbye"), file = file.path("dev", "test.json"))
make_json(x = c("greeting" = "hello", "greeting" = "goodbye"), file = file.path("dev", "test.json"))
make_json(x = c("greeting" = "hello"), file = c("first_name", "second_name"))
make_json(x = c("greeting" = "hello"), file = file.path("dev", "test"))

# End ----
