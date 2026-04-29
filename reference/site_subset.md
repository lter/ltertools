# Subsets the LTER Site Information Table by Site Codes and Habitats

Subsets the information on long term ecological research (LTER) sites
based on user-specified site codes (i.e., three letter abbreviations),
and/or desired habitats. See `lter_sites` for the full set of site
information

## Usage

``` r
site_subset(sites = NULL, habitats = NULL)
```

## Arguments

- sites:

  (character) three letter site code(s) identifying site(s) of interest

- habitats:

  (character) habitat(s) of interest. See `unique(lter_sites$habitat)`

## Value

(dataframe) complete site information (8 columns) for all sites that
meet the provided site code and/or habitat criteria
