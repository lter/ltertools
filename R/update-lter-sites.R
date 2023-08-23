#' @title Long Term Ecological Research Site Information
#' 
#' @description There are currently 28 field sites involved with the Long Term Ecological Research (LTER) network. These sites occupy a range of habitats and were started / are renewed on site-specific timelines. To make this information more readily available to interested parties, this data object summarizes the key components of each site in an easy-to-use data format.
#' 
#' @format Dataframe with 8 columns and 32 rows
#' \describe{
#'     \item{name}{Full name of the LTER site}
#'     \item{code}{Abbreviation (typically three letters) of the site name}
#'     \item{habitat}{Simplified habitat designation of the site (or "mixed" for more complex habitat contexts)}
#'     \item{start_year}{Year of initial funding by NSF as an official LTER site}
#'     \item{end_year}{End of current funding cycle grant}
#'     \item{latitude}{Degrees latitude of site}
#'     \item{longitude}{Degrees longitude of site}
#'     \item{site_url}{Website URL for the site}
#' }
#' 
#' @source { Long Term Ecological Research Network Office. https://lternet.edu/site/}
#' 
"lter_sites"