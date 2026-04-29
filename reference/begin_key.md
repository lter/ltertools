# Generate the Skeleton of a Column Key

Creates the start of a 'column key' for harmonizing data. A column key
includes a column for the file names to be harmonized into a single data
object as well as a column for the column names in those files. Finally,
it includes a column indicating the tidied name that corresponds with
each raw column name. Harmonization can accept this key object and use
it to rename all raw column names–in a reproducible way–to standardize
across datasets. Currently supports raw files of the following formats:
CSV, TXT, XLS, and XLSX

## Usage

``` r
begin_key(
  raw_folder = NULL,
  data_format = c("csv", "txt", "xls", "xlsx"),
  guess_tidy = FALSE
)
```

## Arguments

- raw_folder:

  (character) folder / folder path containing data files to include in
  key

- data_format:

  (character) file extensions to identify within the `raw_folder`.
  Default behavior is to search for all supported file types.

- guess_tidy:

  (logical) whether to attempt to "guess" what the tidy name equivalent
  should be for each raw column name. This is accomplished via coercion
  to lowercase and removal of special character/repeated characters. If
  `FALSE` (the default) the "tidy_name" column is returned empty

## Value

(dataframe) skeleton of column key

## Examples

``` r
# Generate two simple tables
## Dataframe 1
df1 <- data.frame("xx" = c(1:3),
                  "unwanted" = c("not", "needed", "column"),
                  "yy" = letters[1:3])
## Dataframe 2
df2 <- data.frame("LETTERS" = letters[4:7],
                  "NUMBERS" = c(4:7),
                  "BONUS" = c("plantae", "animalia", "fungi", "protista"))

# Generate a local folder for exporting
temp_folder <- tempdir()

# Export both files to that folder
utils::write.csv(x = df1, file = file.path(temp_folder, "df1.csv"), row.names = FALSE)
utils::write.csv(x = df2, file = file.path(temp_folder, "df2.csv"), row.names = FALSE)

# Generate a column key with "guesses" at tidy column names
ltertools::begin_key(raw_folder = temp_folder, data_format = "csv", guess_tidy = TRUE)
#>    source raw_name tidy_name
#> 1 df1.csv       xx        xx
#> 2 df1.csv unwanted  unwanted
#> 3 df1.csv       yy        yy
#> 4 df2.csv  LETTERS   letters
#> 5 df2.csv  NUMBERS   numbers
#> 6 df2.csv    BONUS     bonus
```
