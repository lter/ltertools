## ----------------------------------- ##
      # Harmonization Testing ----
## ----------------------------------- ##

# Purpose:
## Explore possibility of function variant of "data key"-based harmonization workflow

## ----------------------------------- ##
            # Housekeeping ----
## ----------------------------------- ##
# Clear environment / collect garbage
rm(list = ls()); gc()

# Load libraries
librarian::shelf(devtools, tidyverse)

# Create data objects to harmonize
df1 <- data.frame("x" = c(1:3),
                  "y" = letters[1:3])
df2 <- data.frame("NUMBERS" = c(4:6),
                  "LETTERS" = letters[4:6])

# Export both of these for later re-use
write.csv(df1, file = file.path("dev", "test_df1.csv"), na = "", row.names = F)
write.csv(df2, file = file.path("dev", "test_df2.csv"), na = "", row.names = F)

# Create data key
key <- data.frame("source" = c("test_df1.csv", "test_df1.csv", "test_df2.csv", "test_df2.csv"),
                  "raw_name" = c("x", "y", "NUMBERS", "LETTERS"),
                  "harmony_name" = c("numbers", "letters", "numbers", "letters"))


## ----------------------------------- ##
# Script Variant ----
## ----------------------------------- ##



## ----------------------------------- ##
# Function Variant ----
## ----------------------------------- ##

# Clear environment / collect garbage
rm(list = ls()); gc()

# End ----
