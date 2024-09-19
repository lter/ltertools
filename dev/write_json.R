## --------------------------------------------------- ##
                    # Write JSON Function
## --------------------------------------------------- ##
# Author(s): Nick J Lyon

# Purpose:
## We want a function that makes (simple) JSON files that contain user-defined content
## Useful for housing user-specific information (incl. absolute file paths, emails, etc.)

## ----------------------------------- ##
# Exploration ----
## ----------------------------------- ##

# Load libraries
librarian::shelf(jsonlite, RJSONIO)

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

# End ----
