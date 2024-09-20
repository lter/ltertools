## -------------------------------------------- ##
                # Edit `.gitignore`
## -------------------------------------------- ##
# Author(s): Nick J Lyon

# Purpose:
## Edit (add to) the `.gitignore` via an R function

# Load libraries
librarian::shelf(devtools)

## ----------------------------- ##
# Explore ----
## ----------------------------- ##

# Clear environment
rm(list = ls())

# Try to read the `.gitignore`
(ignore_v1 <- readLines(con = ".gitignore"))

# Define stuff to add
new_val <- "HELLO WORLD"

# Add stuff
(ignore_v2 <- c(ignore_v1, "", new_val))

# Save it out
write(x = ignore_v2, file = ".gitignore")

# End ----
