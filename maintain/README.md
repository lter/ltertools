# Welcome to the Maintenance Area of `ltertools`

This folder is meant to serve as a home for scripts needed for internal maintenance purposes that shouldn't be (or can't be) included in the package build itself. One common context for this is keeping embedded data files (.rda) up-to-date.

## Script Explanations

- Any R script beginning with `update-...` is dedicated to maintaining the dataset embedded in `ltertools` with the same name as the script (e.g., `update-lter-sites` updates the `lter_sites` data object included in the package)
