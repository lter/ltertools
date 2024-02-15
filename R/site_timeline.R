#' @title Create a Timeline of Site(s) that Meet Criteria
#' 
#' @description Creates a ggplot2 plot of all sites that meet the user-specified site code (i.e., three letter abbreviation) and/or habitat criteria. See `lter_sites` for the full set of site information including accepted site codes and habitat designations (unrecognized entries will trigger a warning and be ignored). Lines are grouped and colored by habitat to better emphasize possible similarities among sites. This function was built by the following authors: Nicholas Lyon
#' 
#' @param sites (character) three letter site code(s) identifying site(s) of interest
#' @param habitats (character) habitat(s) of interest. See `unique(lter_sites$habitat)`
#' @param colors (character) colors to assign to the timelines expressed as a hexadecimal (e.g, #00FF00). Note there must be as many colors as habitats included in the graph
#' 
#' @return (ggplot2) plot object of timeline of site(s) that meet user-specified criteria
#' 
#' @export
#' 
#' @importFrom magrittr %>%
#' 
#' @examples
#' # Make the full timeline of all sites with default colors by supplying no arguments
#' site_timeline()
#' 
#' # Or make a timeline of only sites that meet certain criteria
#' site_timeline(habitats = c("gassland", "forest"))
#' 
site_timeline <- function(sites = NULL, habitats = NULL, colors = NULL){
  # Squelch visible bindings NOTE
  year <- code <- habitat <- NULL
  
  # Subset to just those sites / habitats
  sites_sub <- site_subset(sites = sites, habitats = habitats)
  
  # Define default colors
  habitat_colors <- c("Admin" = "#6F6F6F", "Urban" = "#2C2B2C",
                      "Marine" = "#35658B", "Coastal" = "#67CDAA", "Freshwater" = "#77EDC6", 
                      "Forest" = "#227923", "Grassland" = "#9ACE32", 
                      "Mixed" = "#CD950B", "Tundra" = "#D2B48C")
  
  # Pivot to long format
  sites_long <- tidyr::pivot_longer(data = sites_sub, cols = dplyr::ends_with("_year"), 
                                    names_to = "cols", values_to = "year") %>%
    # And factor habitats into a more intuitive order
    dplyr::mutate(habitat = factor(habitat, levels = names(habitat_colors))) %>%
    # Arrange by habitat (needed to get codes grouped by habitat in timeline)
    dplyr::arrange(habitat)
  
  # Make initial timeline graph
  times_v1 <- ggplot2::ggplot(sites_long, ggplot2::aes(x = year, 
                                                       y = factor(code, levels = unique(code)))) +
    # Lines for timeline
    ggplot2::geom_path(ggplot2::aes(group = code, color = habitat), 
                       lwd = 1.5, lineend = 'round') +
    # Start / end points of timeline
    ggplot2::geom_point(ggplot2::aes(fill = habitat), pch = 21, size = 3) +
    # Customize theme elements
    ggplot2::theme(panel.border = ggplot2::element_blank(),
          panel.background = ggplot2::element_blank(),
          axis.line = ggplot2::element_line(color = "black"),
          axis.title = ggplot2::element_blank(),
          axis.text = ggplot2::element_text(size = 12),
          legend.key = ggplot2::element_blank(),
          legend.background = ggplot2::element_blank(),
          legend.box.background = ggplot2::element_blank(),
          legend.title = ggplot2::element_blank())
  
  # If the user provided colors that are the correct length
  if(is.null(colors) != TRUE & length(colors) >= length(unique(sites_long$habitat))){
    
    # Use those custom colors
    times_v2 <- times_v1 +
      ggplot2::scale_fill_manual(values = colors) +
      ggplot2::scale_color_manual(values = colors) }
  
  # If palette is provided but isn't long enough for habitats in the data object
  if(is.null(colors) != TRUE & length(colors) < length(unique(sites_long$habitat))){
    
    # Print a warning
    message("Insufficient colors provided. There are ", length(unique(sites_long$habitat)), " but only ", length(colors), " colors provided. Using default colors")
    
    # Use the default colors
    times_v2 <- times_v1 +
      ggplot2::scale_fill_manual(values = habitat_colors, 
                                 breaks = rev(names(habitat_colors))) +
      ggplot2::scale_color_manual(values = habitat_colors, 
                                  breaks = rev(names(habitat_colors))) }
  
  # If no palette is provided, just use the default colors (no error message)
  if(is.null(colors) == TRUE){
    
    times_v2 <- times_v1 +
      ggplot2::scale_fill_manual(values = habitat_colors, 
                                 breaks = rev(names(habitat_colors))) +
      ggplot2::scale_color_manual(values = habitat_colors, 
                                  breaks = rev(names(habitat_colors))) }
  
  # Return that object
  return(times_v2) }
