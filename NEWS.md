# Version 2.1.1

## New Features

- `standardize()` runs `check_key()` internally before attempting to standardize data with that key.
- `check_key()` now rejects "source" as a user-specified "tidy_name" in the data key. Necessary to reserve "source" for storing the file name in the standardized output.

## Documentation & Testing

- Adds unit tests for `check_key()`.
- Updates maintainer email.

# Version 2.1.0

## New Features

- `standardize()` warning message for columns found in key but not data is more succinct.

## Documentation & Testing

- Updates affected units tests for `ggplot2` version 4.0.0.

# Version 2.0.0

## Breaking Changes 

- Deprecates `make_json()` due to loss of key dependency.

## New Features

- `check_key()` ensures a column key is properly formatted to work with `harmonize()`.
- `standardize()` uses the provided column key to standarize a single dataset (from a named list).
- `harmonize()` runs in approximately half the time for large (i.e., >5 MB) raw data files.

# Version 1.2.0

- `expand_key()` generates rows for a column key for only those raw data files that are not already in an existing key or in an existing harmonized data table.

# Version 1.1.0

## New Features

- `make_json()` creates a JSON containing name/value pairs from a named vector. Optionally adds the JSON file name to the `.gitignore` if one is found in the working directory.
- `solar_day_info()` identifies sunrise, sunset, solar noon, and day length for all dates within a user-specified range at particular coordinates.
- `harmonize()` includes new defensive warning/error checks with informative messages for likely sources of error.

## Documentation & Testing

- Unit tests added for all functions currently in package.

# Version 1.0.0

- `read`() reads in all data files in a particular folder and stores them in a list.
- `begin_key()` creates the start of a "column key" for data harmonization.
- `harmonize()` performs column key-based harmonization of raw data.
- `cv()` calculates coefficient of variation for a vector of numbers.
- `convert_temp()` converts temperature values from one specified unit to another.
- `site_timeline()` creates a `ggplot2`-style timeline of all sites that meet the user-specified criteria.
