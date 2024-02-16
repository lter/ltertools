# Welcome to the Maintenance Area of `ltertools`

This folder is meant to serve as a home for scripts needed for internal maintenance purposes that shouldn't be (or can't be) included in the package build itself. One common context for this is keeping embedded data files (.rda) up-to-date.

Note this folder _is_ tracked by Git but **_is not_** included in the package build.

## Script Explanations

- Any R script beginning with `update-...` is dedicated to maintaining the dataset embedded in `ltertools` with the same name as the script (e.g., `update-lter-sites` updates the `lter_sites` data object included in the package)

## Graphics

- **vignette-graphics.pptx** -- Graphics needed for this package (especially in the vignette) are produced in a Microsoft PowerPoint slide deck. From there they can be 'Save as Image'd to their proper places in the package build
