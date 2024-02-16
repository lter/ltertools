## ------------------------------------- ##
# Experiment with 'EML to Table'
## ------------------------------------- ##
# Purpose:
## Exploring whether it is doable to coerce EML (variant in XML format) into a dataframe
### (Or possibly a list?)
## Seems like it would increase the value/readability of the metadata for those who have a harder time "reading" EML

## --------------- ##
# Housekeeping ----
## --------------- ##

# Load needed libraries
librarian::shelf(tidyverse, devtools, XML, emld)

# Clear environment
rm(list = ls())

## --------------- ##
# Script Variant ----
## --------------- ##

## Download an EDI data package
# edi_download(package_id = "edi.1210.1", folder = file.path("dev", "edi"))

# Identify an EML file
edi_xml <- emld::as_emld(x = file.path("dev", "edi", "edi.1210.1", 
                                       "edi.1210.1-metadata.xml"), from = "xml")

# Check structure
str(edi_xml)

# Unlist to a vector
edi_vec <- unlist(x = edi_xml)

# Check structure of that
str(edi_vec)

# Convert the vector to a dataframe
edi_df <- tibble::enframe(x = edi_vec)

# Check structure of *that*
str(edi_df)
## Lot of content to wade through...




# End ----
