# Welcome to `ltertools`' Development Area

This folder is meant to serve as a home for any functions you'd like to contribute to `ltertools`. Why put functions here rather than in the "real" package? To protect the development version of the package from any possible errors during the submission process! This lets you contribute functions more simply and makes it unnecessary for you to follow the strict `roxygen2` format requirements of functions included in R packages. If that is of interest, see [here](https://cran.r-project.org/web/packages/roxygen2/vignettes/roxygen2.html) for more information on `roxygen2` guidelines.

If you are visiting this space to contribute a function, please add a script containing your function and (ideally) a working example of the function's use. If your function requires any data files (either internally or to make the example work), please add those data files to this folder as well.

## Script Explanations

- Any R script beginning with `update-...` is dedicated to maintaining the dataset embedded in `ltertools` with the same name as the script (e.g., `update-lter-sites` updates the `lter_sites` data object included in the package)
