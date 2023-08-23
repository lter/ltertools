



sites <- c("AND", "BNZ", "MCR", "xxx", "LNO", 'abc', "cwt")
habitats <- c("forest", "taiga", "grassland")

# Coerce sites to all uppercase and habitats to all lowercase
sites <- toupper(x = sites)
habitats <- tolower(x = habitats)
lter_sites$habitat <- tolower(lter_sites$habitat)

# If user wants the LNO, exchange the provided abbreviation for the expanded abbreviations
if("LNO" %in% sites | "NCO" %in% sites){
  sites <- c(setdiff(x = sites, y = c("LNO", "NCO")), "LNO-UW", "LNO-UNM", "LNO-UCSB")
}

# Subset to only supplied sites (if any are provided)
if(is.null(sites) != TRUE){
  
  # Identify any user-provided sites not in the data
  missing_sites <- setdiff(x = sites, y = lter_sites$code)
  
  # If any user-provided codes aren't in the data
  if(length(missing_sites) > 0){
    
    # Warn the user about the mismatch(es) and drop it
    message("Site abbreviation(s) '", paste0(missing_sites, collapse = "', '"), "' not recognized. Excluding now")
    
    # And drop them
    sites <- setdiff(x = sites, y = missing_sites) }
  
  # After all that processing, subset to only those sites
  sites_sub1 <- dplyr::filter(.data = lter_sites, code %in% sites)
  
  # If no sites are provided to which to subset, keep the full object
} else { sites_sub1 <- lter_sites }

# Now we need to handle user-provided habitats (if any)
if(is.null(habitats) != TRUE){
  
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
  stop("No sites meet current site code / habitat criteria. Please revise and retry")
