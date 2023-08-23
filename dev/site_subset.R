

site_subset <- function(sites = NULL, habitats = NULL){
  
  # Make all habitats lowercase in the source data
  lter_sites$habitat <- tolower(lter_sites$habitat)
  
  # Subset to only supplied sites (if any are provided)
  if(is.null(sites) != TRUE){
    
    # Check for malformed site codes
    if(any(nchar(sites) != 3))
      stop("Malformed site codes detected. All sites must be specified by their three letter abbreviations.")
    
    # Coerce site codes to uppercase 
    sites <- toupper(x = sites)
    
    # If user wants the LNO, exchange the provided abbreviation for the expanded abbreviations
    if("LNO" %in% sites | "NCO" %in% sites){
      sites <- c(setdiff(x = sites, y = c("LNO", "NCO")), "LNO-UW", "LNO-UNM", "LNO-UCSB")
    }
    
    # Identify any user-provided sites not in the data
    missing_sites <- setdiff(x = sites, y = lter_sites$code)
    
    # If any user-provided codes aren't in the data
    if(length(missing_sites) > 0){
      
      # Warn the user about the mismatch(es) and drop it
      message("Site abbreviation(s) '", paste0(missing_sites, collapse = "', '"), "' not recognized. Excluding now.")
      
      # And drop them
      sites <- setdiff(x = sites, y = missing_sites) }
    
    # After all that processing, subset to only those sites
    sites_sub1 <- dplyr::filter(.data = lter_sites, code %in% sites)
    
    # If no sites are provided to which to subset, keep the full object
  } else { sites_sub1 <- lter_sites }
  
  # Now we need to handle user-provided habitats (if any)
  if(is.null(habitats) != TRUE){
    
    # Coerce habitats to all lowercase in user-provided vector
    habitats <- tolower(x = habitats)
    
    # Check for missing habitats (in full dataset rather than subset to avoid confusion)
    missing_habs <- setdiff(x = habitats, y = lter_sites$habitat)
    
    # If any are found
    if(length(missing_habs) > 0){
      
      # Warn the user
      message("Habitat(s) '", paste0(missing_habs, collapse = "', '"), "' not recognized. Excluding now.")
      
      # Drop them
      habitats <- setdiff(x = habitats, y = missing_habs) }
    
    # Now we can actually do the subsetting (if any needs to be done)
    sites_sub2 <- dplyr::filter(.data = sites_sub1, habitat %in% habitats)
    
    # If no subsetting was required, keep everything from preceding step
  } else { sites_sub2 <- sites_sub1 }
  
  # Produce a warning if that creates no rows
  if(nrow(sites_sub2) == 0)
    stop("No sites meet current site code / habitat criteria. Please revise and retry.")
  
  # Get habitats make into title case
  sites_actual <- dplyr::mutate(.data = sites_sub2, 
                                habitat = stringr::str_to_title(string = habitat))
  
  # Return that final object
  return(sites_actual) }


site_subset(sites = c("AND", "BNZ", "MCR", "xxx", "LNO", 'abc', "cwt"),
            habitats = c("forest", "taiga", "grassland"))

site_subset(sites = 'hello')


site_subset(sites = "AND", habitats = "marine")
