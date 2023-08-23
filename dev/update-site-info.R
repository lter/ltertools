## ----------------------------------- ##
        # Update LTER Site Info
## ----------------------------------- ##

# Purpose:
## We need an easy way to update the LTER site information embedded in this package
## Assembling that dataframe here creates just such an update method
## while still keeping all package-relevant resources in a central location

## ----------------------------------- ##
# Housekeeping ----
## ----------------------------------- ##
# Load libraries

# Create the folder we'll need later
dir.create(path = file.path("data"), showWarnings = F)

# Clear environment
rm(list = ls())

## ----------------------------------- ##
# Per Site Info ----
## ----------------------------------- ##

# Begin by creating each site's relevant information as separate objects


# End ----