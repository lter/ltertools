# Changelog

## Version 2.1.1

CRAN release: 2026-09-18

### New Features

- [`standardize()`](https://lter.github.io/ltertools/reference/standardize.md)
  runs
  [`check_key()`](https://lter.github.io/ltertools/reference/check_key.md)
  internally before attempting to standardize data with that key.
- [`check_key()`](https://lter.github.io/ltertools/reference/check_key.md)
  now rejects “source” as a user-specified “tidy_name” in the data key.
  Necessary to reserve “source” for storing the file name in the
  standardized output.

### Documentation & Testing

- Adds unit tests for
  [`check_key()`](https://lter.github.io/ltertools/reference/check_key.md).
- Updates maintainer email.

## Version 2.1.0

CRAN release: 2025-09-02

### New Features

- [`standardize()`](https://lter.github.io/ltertools/reference/standardize.md)
  warning message for columns found in key but not data is more
  succinct.

### Documentation & Testing

- Updates affected units tests for `ggplot2` version 4.0.0.

## Version 2.0.0

CRAN release: 2025-03-26

### Breaking Changes

- Deprecates `make_json()` due to loss of key dependency.

### New Features

- [`check_key()`](https://lter.github.io/ltertools/reference/check_key.md)
  ensures a column key is properly formatted to work with
  [`harmonize()`](https://lter.github.io/ltertools/reference/harmonize.md).
- [`standardize()`](https://lter.github.io/ltertools/reference/standardize.md)
  uses the provided column key to standarize a single dataset (from a
  named list).
- [`harmonize()`](https://lter.github.io/ltertools/reference/harmonize.md)
  runs in approximately half the time for large (i.e., \>5 MB) raw data
  files.

## Version 1.2.0

CRAN release: 2025-02-21

- [`expand_key()`](https://lter.github.io/ltertools/reference/expand_key.md)
  generates rows for a column key for only those raw data files that are
  not already in an existing key or in an existing harmonized data
  table.

## Version 1.1.0

CRAN release: 2024-09-20

### New Features

- `make_json()` creates a JSON containing name/value pairs from a named
  vector. Optionally adds the JSON file name to the `.gitignore` if one
  is found in the working directory.
- [`solar_day_info()`](https://lter.github.io/ltertools/reference/solar_day_info.md)
  identifies sunrise, sunset, solar noon, and day length for all dates
  within a user-specified range at particular coordinates.
- [`harmonize()`](https://lter.github.io/ltertools/reference/harmonize.md)
  includes new defensive warning/error checks with informative messages
  for likely sources of error.

### Documentation & Testing

- Unit tests added for all functions currently in package.

## Version 1.0.0

CRAN release: 2024-02-23

- `read`() reads in all data files in a particular folder and stores
  them in a list.
- [`begin_key()`](https://lter.github.io/ltertools/reference/begin_key.md)
  creates the start of a “column key” for data harmonization.
- [`harmonize()`](https://lter.github.io/ltertools/reference/harmonize.md)
  performs column key-based harmonization of raw data.
- [`cv()`](https://lter.github.io/ltertools/reference/cv.md) calculates
  coefficient of variation for a vector of numbers.
- [`convert_temp()`](https://lter.github.io/ltertools/reference/convert_temp.md)
  converts temperature values from one specified unit to another.
- [`site_timeline()`](https://lter.github.io/ltertools/reference/site_timeline.md)
  creates a `ggplot2`-style timeline of all sites that meet the
  user-specified criteria.
