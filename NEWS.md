## Version 2.1.0

- Function fix: `standardize` warning message for columns found in key but not data more succinctly
- Test update: unit test update for `ggplot2` version `4.0.0`

## Version 2.0.0

There are no ERRORs, WARNINGs, or NOTEs returned by `devtools::check()`. Changes from the preceding version are as follows:

- Removed function: `make_json`. The most critical dependency of this function is being archived and a suitable replacement cannot be found. Consider making a simple CSV of information rather than a JSON
- New function: `check_key` makes sure a column key is properly formatted to work with `ltertools::harmonize` and removes rows where no "tidy_name" is specified
- New function: `standardize` standarizes a single dataset (from a list) with the provided key object
- Improvement: `harmonize` now runs in approximately half the time for large (i.e., >5 MB) raw data files. No change to function inputs or outputs, just increased efficiency

## Version 1.2.0

There are no ERRORs, WARNINGs, or NOTEs returned by `devtools::check()`. Changes from the preceding version are as follows:

- New function: `expand_key` generates rows for a column key for only raw data files that are not already in an existing key or in an existing harmonized data table

## Version 1.1.0

There are no ERRORs, WARNINGs, or NOTEs returned by `devtools::check()`. Changes from the preceding version are as follows:

- New function: `make_json` creates a JSON containing name/value pairs from a named vector. Optionally adds the JSON file name to the 'gitignore' (if one can be found in the working directory)
- New function: `solar_day_info` identifies sunrise, sunset, solar noon, and day length for all dates within a user-specified range at particular coordinates
- Function update: `harmonize` now includes new defensive warning/error checks with informative messages for likely sources of error
- Unit tests added for all functions currently in package. Likely limited impact on users except better adherence to best practice will make for a stronger package in the long run

## Version 1.0.0

There are no ERRORs, WARNINGs, or NOTEs returned by `devtools::check()`. This is the first version of `ltertools`.

- New function: `read` -- reads in all data files in a particular folder and stores them in a list
- New function: `begin_key` -- creates the start of a "column key" for data harmonization
- New function: `harmonize` -- performs column key-based harmonization of raw data
- New function: `cv` -- calculates coefficient of variation for a vector of numbers
- New function: `convert_temp` -- converts temperature values from one specified unit to another
- New dataset: `lter_sites` -- includes primary habitat, latitude/longitude coordinates, and funding start/end years for every site currently in the network
- New function: `site_timeline` -- creates a `ggplot2`-style timeline of all sites that meet the user-specified criteria (for site code and/or habitat)
