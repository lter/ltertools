## --------------------------------------------------- ##
                    # Write JSON Function
## --------------------------------------------------- ##
# Author(s): Nick J Lyon

# Purpose:
## We want a function that makes (simple) JSON files that contain user-defined content
## Useful for housing user-specific information (incl. absolute file paths, emails, etc.)

# Load libraries
librarian::shelf(jsonlite, RJSONIO)

## ----------------------------------- ##
# Exploration ----
## ----------------------------------- ##

# Clear environment
rm(list = ls())

# Make simple test objects
(contents_vec <- c("greeting" = "hello"))

# Make these into JSONs
(contents_json <- RJSONIO::toJSON(x = contents_vec))

# Attempt to save as a JSON
write(x = contents_json, file = file.path("dev", "test.json"))

# Read in JSON and see if it looks 'right'
user_info <- jsonlite::read_json(file.path("dev", "test.json"))
str(user_info)

## ----------------------------------- ##
# Function Dev ----
## ----------------------------------- ##

# Clear environment
rm(list = ls())

# Define function
make_json <- function(x = NULL, file = NULL){
  
  # Error for null arguments
  # Error for non-character arguments
  # Error for different length of names/values
  # Error for non-unique names
  # Warning for 'file' not ending in '.json'
  
  # Transform contents to JSON format
  json_content <- RJSONIO::toJSON(x = x)
  
  # Export
  write(x = json_content, file = file)
  
}

# Invoke function
make_json(x = c("greeting" = "hello", "farewell" = "goodbye"),
          file = file.path("dev", "test.json"))

# Read in JSON and see if it looks 'right'
(user_info <- jsonlite::read_json(file.path("dev", "test.json")))

user_info$farewell



# End ----
