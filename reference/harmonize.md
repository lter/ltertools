# Harmonize Data via a Column Key

A "column key" is meant to streamline harmonization of disparate
datasets. This key must include three columns containing: (1) the name
of each raw data file to be harmonized, (2) the name of all of the
columns in each of those files, and (3) the "tidy name" that corresponds
to each raw column name. This function accepts that key and the path to
a folder containing all raw data files included in the key. Each dataset
is then read in and the original column names are replaced with their
respective "tidy_name" indicated in the key. Once this has been done to
all files, a single dataframe is returned with only columns indicated in
the column name. Currently the following file formats are supported for
the raw data: CSV, TXT, XLS, and XLSX

Note that raw column names without an associated tidy name in the key
are removed. We recommend using the `begin_key` function in this package
to generate the skeleton of the key to make achieving the required
structure simpler.

## Usage

``` r
harmonize(
  key = NULL,
  raw_folder = NULL,
  data_format = c("csv", "txt", "xls", "xlsx"),
  quiet = TRUE
)
```

## Arguments

- key:

  (dataframe) key object including a "source", "raw_name" and
  "tidy_name" column. Additional columns are allowed but ignored

- raw_folder:

  (character) folder / folder path containing data files to include in
  key

- data_format:

  (character) file extensions to identify within the `raw_folder`.
  Default behavior is to search for all supported file types.

- quiet:

  (logical) whether to suppress certain non-warning messages. Defaults
  to `TRUE`

## Value

(dataframe) harmonized dataframe including all columns defined in the
"tidy_name" column of the key object

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

# Generate a column key object manually
key_obj <- data.frame("source" = c(rep("df1.csv", 3), 
                                   rep("df2.csv", 3)),
                      "raw_name" = c("xx", "unwanted", "yy",
                                     "LETTERS", "NUMBERS", "BONUS"),
                    "tidy_name" = c("numbers", NA, "letters",
                                    "letters", "numbers", "kingdom"))

# Use that to harmonize the 'raw' files we just created
ltertools::harmonize(key = key_obj, raw_folder = temp_folder, data_format = "csv")
#>    source numbers letters  kingdom
#> 1 df1.csv       1       a     <NA>
#> 2 df1.csv       2       b     <NA>
#> 3 df1.csv       3       c     <NA>
#> 4 df2.csv       4       d  plantae
#> 5 df2.csv       5       e animalia
#> 6 df2.csv       6       f    fungi
#> 7 df2.csv       7       g protista
```
