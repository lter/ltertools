
# Get data into long format
site_long <- lter_sites %>%
  tidyr::pivot_longer(cols = ends_with("_year"), names_to = "cols", values_to = "year")


# Get vector of habitat colors
habitat_colors <- c("Coastal" = "#34a0a4", 
                    "Freshwater" = "#48cae4", 
                    "Marine" = "#1e6091", 
                    "Forest" = "#007200",
                    "Grassland" = "#9ef01a", 
                    "Mixed Landscape" = "#7f5539",
                    "Tundra" = "#bb9457", 
                    "Urban" = "#9d4edd")

# Make timeline
timeline <- ggplot(site_long, aes(x = year, y = code)) +
  geom_path(aes(group = code, color = habitat), lwd = 1, lineend = 'round') +
  geom_point(aes(fill = habitat), pch = 21, size = 2) +
  # Custom color
  scale_fill_manual(values = habitat_colors) +
  scale_color_manual(values = habitat_colors) +
  # Customize theme elements
  theme_bw() +
  theme(panel.border = element_blank(),
        axis.title = element_blank(),
        axis.text = element_text(size = 12),
        legend.title = element_blank()); timeline

# Export this graph
# ggsave(plot = timeline, filename = file.path("plots", "LTER_site_timeline.png"),
#        height = 5, width = 6, units = "in")



ggplot(site_long, aes(x = year, y = factor(code, levels = lter_sites$code))) +
  geom_path(aes(group = code, color = habitat), lwd = 1, lineend = 'round') +
  geom_point(aes(fill = habitat), pch = 21, size = 2)

