
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `ltertools` - Tools Developed by the Long Term Ecological Research Community

<!-- badges: start -->

[![R-CMD-check](https://github.com/lter/ltertools/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/lter/ltertools/actions/workflows/R-CMD-check.yaml)
[![](https://cranlogs.r-pkg.org/badges/ltertools)](https://cran.r-project.org/package=ltertools)
![GitHub
issues](https://img.shields.io/github/issues-raw/lter/ltertools)
![GitHub pull
requests](https://img.shields.io/github/issues-pr/lter/ltertools)
<!-- badges: end -->

The goal of `ltertools` is to centralize the R functions created by
members of the Long Term Ecological Research (LTER) community. Many of
these functions likely have broad relevance that expands beyond the
context of their creation and this package is an attempt to share those
tools and limit the amount of “re-inventing the wheel” that we each do
in our own silos.

The conceptual theme of functions in `ltertools` is necessarily broad
given the scope of the community we aim to serve. That said, the
identity of this package will likely become more clear as we accrue
contributed functions. In the meantime, please do not hesitate to add or
request a function for fear that it doesn’t “fit” this package. That may
eventually become a concern but at this stage we are aiming to house
*all* extant functions regardless of their relatedness to one another.

## Installation

You can install the development version of `ltertools` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("lter/ltertools")
```

## Function Overview

As functions are added to the package they will be briefly summarized
below and attributed to their author(s)

### Reproducibility

- **`make_json`** – creates a JSON containing name/value pairs from a
  named vector. If desired, can also add the created JSON’s filename to
  the .gitignore (if one exists in the working directory)

### Harmonization

- **`begin_key`** – creates the first two columns of a ‘column key’
  and–if the optional `guess_tidy` argument is set to `TRUE`–“guesses”
  at what the tidy names ‘should be’

- **`harmonize`** – performs column key-based harmonization. We strongly
  recommend using the `begin_key` to start the creation of a column key
  to make sure the formatting requirements of this function are met

### Data Wrangling

- **`read`** – Reads in all files of specified types in a particular
  folder and stores them as elements in a list. List element names are
  the respective file names. Currently supports CSV, TXT, XLS, and XLSX
  file formats

- **`solar_day_info`** – Identify sunrise, sunset, solar noon, and day
  length for all dates within a user-specified range at particular
  coordinates. Function concept contributed by [Miguel C.
  Leon](https://luquillo.lter.network/)

- **`cv`** – Calculate coefficient of variation (CV) from a vector of
  numbers

- **`convert_temp`** – Convert temperature values from one set of units
  to another

### LTER Information

- **`site_timeline`** – Create a timeline of sites that meet
  user-specified site code and/or habitat criteria. Uses built in
  `lter_sites` data object that includes much useful site information

## Contributing

See `CONTRIBUTING.md` for specifics but at a glance:

- To contribute one of your functions in exchange for authorship credit:
  [open a GitHub issue](https://github.com/lter/ltertools/issues)

- To suggest minor fixes or point out bugs: [open a GitHub
  issue](https://github.com/lter/ltertools/issues)

- To implement major / structural changes: fork the repository, add your
  content to the `dev` folder, and open a pull request when you are
  finished

`ltertools` will maintain a consistent “feel” and style of functions but
we (the maintainers) are happy to perform these edits on your behalf. If
you’d like to take care of this yourself (completely optional!) you are
welcome to do so. Please see `CONTRIBUTING.md` for a specific style
guide.

## Synonymous Function Procedure

If you would like to contribute a function that is similar to a function
that already exists in `ltertools` please do not hesitate! In the event
that this happens, the following steps will be followed:

1.  The functions will be combined to preserve the earlier function’s
    elements while expanding to include the maximum number of novel
    features (i.e., arguments / options)

    - The older function’s name will be retained to avoid unnecessary
      deprecation flags

2.  Both function authors will be credited in the combined function’s
    description and in this README (see above)
