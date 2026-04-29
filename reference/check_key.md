# Check and Prepare a Column Key Object

Accepts a column key dataframe and checks to make sure it has the needed
structure for
[`ltertools::harmonize`](https://lter.github.io/ltertools/reference/harmonize.md).
Also removes unnecessary columns and rows that lack a "tidy_name".
Function invoked 'under the hood' by
[`ltertools::harmonize`](https://lter.github.io/ltertools/reference/harmonize.md).

## Usage

``` r
check_key(key = NULL)
```

## Arguments

- key:

  (dataframe) key object including a "source", "raw_name" and
  "tidy_name" column. Additional columns are allowed but ignored

## Value

(dataframe) key object with only "source", "raw_name" and "tidy_name"
columns and only retains rows where a "tidy_name" is specified.

## Examples

``` r
# Generate a column key object manually
key_obj <- data.frame("source" = c(rep("df1.csv", 3), 
                                   rep("df2.csv", 3)),
                      "raw_name" = c("xx", "unwanted", "yy",
                                     "LETTERS", "NUMBERS", "BONUS"),
                      "tidy_name" = c("numbers", NA, "letters",
                                      "letters", "numbers", "kingdom"))

# Check it
ltertools::check_key(key = key_obj)
#>    source raw_name tidy_name
#> 1 df1.csv       xx   numbers
#> 2 df1.csv       yy   letters
#> 3 df2.csv  LETTERS   letters
#> 4 df2.csv  NUMBERS   numbers
#> 5 df2.csv    BONUS   kingdom
```
