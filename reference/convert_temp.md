# Convert Temperature Values

Converts a given set of temperature values from one unit to another

## Usage

``` r
convert_temp(value = NULL, from = NULL, to = NULL)
```

## Arguments

- value:

  (numeric) temperature values to convert

- from:

  (character) starting units of the value, not case sensitive.

- to:

  (character) units to which to convert, not case sensitive.

## Value

(numeric) converted temperature values

## Examples

``` r
# Convert from Fahrenheit to Celsius
convert_temp(value = 32, from = "Fahrenheit", to = "c")
#> [1] 0
```
