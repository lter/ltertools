
# Get data into long format
site_long <- lter_sites %>%
  tidyr::pivot_longer(cols = ends_with("_year"), names_to = "cols", values_to = "year")


# Get vector of habitat colors
habitat_colors <- c("Admin" = "#fcbf49",
                    "Coastal" = "#34a0a4", 
                    "Freshwater" = "#ade8f4", 
                    "Marine" = "#023e8a", 
                    "Forest" = "#55a630",
                    "Grassland" = "#9ef01a", 
                    "Mixed" = "#9d4edd",
                    "Tundra" = "#bb9457", 
                    "Urban" = "#f77f00")

# Make timeline
ggplot(site_long, aes(x = year, y = factor(code, levels = lter_sites$code))) +
  geom_path(aes(group = code, color = habitat), lwd = 1.5, lineend = 'round') +
  geom_point(aes(fill = habitat), pch = 21, size = 3) +
  # Vertical line at current year
  geom_vline(xintercept = )
  # Custom color
  scale_fill_manual(values = habitat_colors) +
  scale_color_manual(values = habitat_colors) +
  # Customize theme elements
  theme(panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(color = "black"),
        axis.title = element_blank(),
        axis.text = element_text(size = 12),
        legend.title = element_blank())

# Export this graph
# ggsave(plot = timeline, filename = file.path("plots", "LTER_site_timeline.png"),
#        height = 5, width = 6, units = "in")



ggplot(site_long, aes(x = year, y = factor(code, levels = lter_sites$code))) +
  geom_path(aes(group = code, color = habitat), lwd = 1, lineend = 'round') +
  geom_point(aes(fill = habitat), pch = 21, size = 2)

