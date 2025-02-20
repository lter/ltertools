## ltertools Version 1.1.0.900

This is the development version; changes will be listed as they are made.

- New function: `expand_key` generates rows for a column key for only raw data files that are not already in an existing key or in an existing harmonized data table

## ltertools Version 1.1.0

There are no ERRORs, WARNINGs, or NOTEs returned by `devtools::check()`.

- New function: `make_json` creates a JSON containing name/value pairs from a named vector. Optionally adds the JSON file name to the 'gitignore' (if one can be found in the working directory)
- New function: `solar_day_info` identifies sunrise, sunset, solar noon, and day length for all dates within a user-specified range at particular coordinates
- Function update: `harmonize` now includes new defensive warning/error checks with informative messages for likely sources of error
- Unit tests added for all functions currently in package. Likely limited impact on users except better adherence to best practice will make for a stronger package in the long run

## ltertools Version 1.0.0

There are no ERRORs, WARNINGs, or NOTEs returned by `devtools::check()`.

- New function: `read` -- reads in all data files in a particular folder and stores them in a list
- New function: `begin_key` -- creates the start of a "column key" for data harmonization
- New function: `harmonize` -- performs column key-based harmonization of raw data
- New function: `cv` -- calculates coefficient of variation for a vector of numbers
- New function: `convert_temp` -- converts temperature values from one specified unit to another
- New dataset: `lter_sites` -- includes primary habitat, latitude/longitude coordinates, and funding start/end years for every site currently in the network
- New function: `site_timeline` -- creates a `ggplot2`-style timeline of all sites that meet the user-specified criteria (for site code and/or habitat)
