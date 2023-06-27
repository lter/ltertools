
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `ltertools` - Tools Developed by the Long Term Ecological Research Community

<!-- badges: start -->

[![R-CMD-check](https://github.com/lter/ltertools/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/lter/ltertools/actions/workflows/R-CMD-check.yaml)
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

### Data Wrangling

- **`convert`** – Convert values from one set of units to another.
  Currently supports temperature units as well as kilometers versus
  miles. Function written by [Nick Lyon](https://njlyon0.github.io/)

## Contributing

See `CONTRIBUTING.md` for specifics but at a glance:

- To contribute one of your functions in exchange for authorship credit:
  [open a GitHub issue](https://github.com/lter/ltertools/issues)

- To suggest minor fixes or point out bugs: [open a GitHub
  issue](https://github.com/lter/ltertools/issues)

- To implement major / structural changes: fork the repository, add your
  content to the `dev` folder, and open a pull request when you are
  finished
