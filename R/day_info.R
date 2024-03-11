#' @title Identify Solar Day Information
#' 
#' @description
#' 
#' @param lat
#' @param lon
#' @param start_date
#' @param end_date
#' @param quiet (logical) whether to suppress certain non-warning messages. Defaults to `TRUE`
#' 
#' @return 
#' 
#' @importFrom magrittr %>%
#' 
#' @export
#' 
#' @examples
#' # Identify day information in Santa Barbara (California) for one week
#' solar_day(lat = 34.416857, lon = -119.712777, 
#'           start_date = "2022-02-07", end_date = "2022-02-12", 
#'           quiet = F)
#' 
solar_day <- function(lat = NULL, lon = NULL, 
                      start_date = NULL, end_date = NULL, 
                      quiet = FALSE){
  
  # Error out for inappropriate coordinates
  if(abs(lat) > 90 | abs(lon) > 180)
    stop("Inappropriate latitude/longitude coordinates detected. Please revise")
  
  # Combine dates into one object to make error checks simpler
  dates <- c(start_date, end_date)
  
  # Split by hyphens for another streamlining step of the error checks
  dates_split <- stringr::str_split(string = dates, pattern = "-", simplify = TRUE)
  
  # Error out for malformed dates
  if(all(is.character(dates)) != TRUE |
     all(nchar(dates) == 10) != TRUE |
     all(stringr::str_count(string = dates, pattern = "-") == 2) != TRUE |
     all(nchar(dates_split[,1]) == 4) != TRUE |
     all(nchar(dates_split[,2]) == 2) != TRUE |
     all(nchar(dates_split[,3]) == 2) != TRUE)
    stop("Dates must be provided as characters in 'YYYY-MM-DD' format")
  
  # If `quiet` isn't a logical, warn the user and reset to default
  if(is.logical(quiet) != TRUE){
    warning("`quiet` must be a logical. Defaulting to FALSE")
    quiet <- FALSE }
  
  # Identify all dates between the start and end
  date_range <- seq(from = as.Date(start_date), to = as.Date(end_date), by = "days")
  
  # Make an empty list
  date_list <- list()
  
  # Loop across these days
  for(k in 1:length(date_range)){
    
    # Identify focal date
    focal_date <- date_range[k]
    
    # Message which date is being processed
    if(quiet != TRUE){ message("Retrieving data for ", focal_date) }
    
    # Assemble query
    day_query <- paste0("https://api.sunrise-sunset.org/json?lat=",
                        lat, "&lng=", lon, "&date=", focal_date)
    
    # Test query
    day_info <- suppressWarnings(utils::read.csv(file = url(description = day_query), header = F))
    
    # Extract to data frame
    single_df <- data.frame("date" = focal_date,
                            "v1" = day_info$V1,
                            "v2" = day_info$V2,
                            "v3" = day_info$V3,
                            "v4" = day_info$V4,
                            "v5" = day_info$V12)
    
    # Add to list
    date_list[[as.character(focal_date)]] <- single_df
    
  } # Close loop
  
  # Unlist to dataframe
  day_df <- purrr::list_rbind(x = date_list) %>% 
    # Fix some formatting issues in retrieved information
    dplyr::mutate(sunrise = gsub(pattern = "[{]results:[{]sunrise:", replacement = "", x = v1),
                  sunset = gsub(pattern = "sunset:", replacement = "", x = v2),
                  solar_noon = gsub(pattern = "solar_noon:", replacement = "", x = v3),
                  day_length = gsub(pattern = "day_length:", replacement = "", x = v4),
                  time_zone = gsub(pattern = "tzid:|[}]", replacement = "", x = v5)) %>% 
    # Drop earlier variant of those columns
    dplyr::select(-dplyr::starts_with("v"))
  
  # Return that output
  return(day_df) }
