# Read Data from Folder

Reads in all data files of specified types found in the designated
folder. Returns a list with one element for each data file. Currently
supports CSV, TXT, XLS, and XLSX

## Usage

``` r
read(raw_folder = NULL, data_format = c("csv", "txt", "xls", "xlsx"))
```

## Arguments

- raw_folder:

  (character) folder / folder path containing data files to read

- data_format:

  (character) file extensions to identify within the `raw_folder`.
  Default behavior is to search for all supported file types.

## Value

(list) data found in specified folder of specified file format(s)

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

# Read in all CSV files in that folder
read(raw_folder = temp_folder, data_format = "csv")
#> $df1.csv
#>   xx unwanted yy
#> 1  1      not  a
#> 2  2   needed  b
#> 3  3   column  c
#> 
#> $df2.csv
#>   LETTERS NUMBERS    BONUS
#> 1       d       4  plantae
#> 2       e       5 animalia
#> 3       f       6    fungi
#> 4       g       7 protista
#> 
#> $df3.csv
#>   xx letters
#> 1 10       j
#> 2 11       k
#> 3 12       l
#> 4 13       m
#> 5 14       n
#> 6 15       o
#> 
```
