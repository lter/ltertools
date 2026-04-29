# Calculate Coefficient of Variation

Computes the coefficient of variation (CV), by dividing the standard
deviation (SD) by the arithmetic mean of a set of numbers. If `na_rm` is
`TRUE` then missing values are removed before calculation is completed

## Usage

``` r
cv(x, na_rm = TRUE)
```

## Arguments

- x:

  (numeric) vector of numbers for which to calculate CV

- na_rm:

  (logical) whether to remove missing values from both average and SD
  calculation

## Value

(numeric) coefficient of variation

## Examples

``` r
# Convert from Fahrenheit to Celsius
cv(x = c(4, 5, 6, 4, 5, 5), na_rm = TRUE)
#> [1] 0.1557461
```
