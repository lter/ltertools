## ltertools Version 1.0.0.900

Development version of `ltertools`. There are no ERRORs, WARNINGs, or NOTEs returned by `devtools::check()`. Changes from latest release will be listed here as they are made.

- No changes (yet) from previous version

## ltertools Version 1.0.0

There are no ERRORs, WARNINGs, or NOTEs returned by `devtools::check()`.

- New function: `read` -- reads in all data files in a particular folder and stores them in a list
- New function: `begin_key` -- creates the start of a "column key" for data harmonization
- New function: `harmonize` -- performs column key-based harmonization of raw data
- New function: `cv` -- calculates coefficient of variation for a vector of numbers
- New function: `convert_temp` -- converts temperature values from one specified unit to another
- New dataset: `lter_sites` -- includes primary habitat, latitude/longitude coordinates, and funding start/end years for every site currently in the network
- New function: `site_timeline` -- creates a `ggplot2`-style timeline of all sites that meet the user-specified criteria (for site code and/or habitat)
