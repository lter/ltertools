







# Actually generate timeline graph


lter_timeline <- function(sites = NULL, habitats = NULL, colors = NULL){
  
  # Subset to just those sites / habitats
  sites_sub <- ltertools:::site_subset(sites = sites, habitats = habitats)
  
  # Pivot to long format
  sites_long <- tidyr::pivot_longer(data = sites_sub, cols = ends_with("_year"), 
                                    names_to = "cols", values_to = "year")
  
  # Define default colors
  habitat_colors <- c("Admin" = "#fcbf49", "Urban" = "#f77f00",
                      "Marine" = "#0466c8", "Coastal" = "#34a0a4", "Freshwater" = "#8ecae6", 
                      "Forest" = "#007200", "Grassland" = "#70e000", 
                      "Mixed" = "#9d4edd", "Tundra" = "#bb9457")
  
  # Make initial timeline graph
  times_v1 <- ggplot(sites_long, aes(x = year, y = factor(code, levels = sites_sub$code))) +
    # Lines for timeline
    geom_path(aes(group = code, color = habitat), lwd = 1.5, lineend = 'round') +
    # Start / end points of timeline
    geom_point(aes(fill = habitat), pch = 21, size = 3) +
    # Customize theme elements
    theme(panel.border = element_blank(),
          panel.background = element_blank(),
          axis.line = element_line(color = "black"),
          axis.title = element_blank(),
          axis.text = element_text(size = 12),
          legend.title = element_blank())
  
  # If the user provided colors that are the correct length
  if(is.null(colors) != TRUE & length(colors) >= length(unique(sites_long$habitat))){
    
    # Use those custom colors
    times_v2 <- times_v1 +
      scale_fill_manual(values = colors) +
      scale_color_manual(values = colors) }
  
  # If palette is provided but isn't long enough for habitats in the data object
  if(is.null(colors) != TRUE & length(colors) < length(unique(sites_long$habitat))){
    
    # Print a warning
    message("Insufficient colors provided. There are ", length(unique(sites_long$habitat)), " but only ", length(colors), " colors provided. Using default colors")
    
    # Use the default colors
    times_v2 <- times_v1 +
      scale_fill_manual(values = habitat_colors) +
      scale_color_manual(values = habitat_colors) }
  
  # If no palette is provided, just use the default colors (no error message)
  if(is.null(colors) == TRUE){
    
    times_v2 <- times_v1 +
      scale_fill_manual(values = habitat_colors) +
      scale_color_manual(values = habitat_colors) }
  
  # Return that object
  return(times_v2) }


lter_timeline()

lter_timeline(habitats = c("marine", "ocean", "coastal"))


