# Identify Solar Day Information

For all days between the specified start and end date, identify the time
of sunrise, sunset, and solar noon (in UTC) as well as the day length.
The idea for this function was contributed by [Miguel C.
Leon](https://luquillo.lter.network/) and a Python equivalent lives in
the Luquillo site's [LUQ-general-utils GitHub
repository](https://github.com/LUQ-LTER/LUQ-general-utils).

## Usage

``` r
solar_day_info(
  lat = NULL,
  lon = NULL,
  start_date = NULL,
  end_date = NULL,
  quiet = FALSE
)
```

## Arguments

- lat:

  (numeric) latitude coordinate for which to find day length

- lon:

  (numeric) longitude coordinate for which to find day length

- start_date:

  (character) starting date in 'YYYY-MM-DD' format

- end_date:

  (character) ending date in 'YYYY-MM-DD' format

- quiet:

  (logical) whether to suppress certain non-warning messages. Defaults
  to `TRUE`

## Value

(dataframe) table of 6 columns and a number of rows equal to the number
of days between the specified start and end dates (inclusive). Columns
contain: (1) date, (2) sunrise time, (3) sunset time, (4) solar noon,
(5) day length, and (6) time zone of columns 2 to 4.

## Examples

``` r
if (FALSE) { # \dontrun{
# Identify day information in Santa Barbara (California) for one week
solar_day_info(lat = 34.416857, lon = -119.712777, 
               start_date = "2022-02-07", end_date = "2022-02-12", 
               quiet = TRUE)
} # }
```
