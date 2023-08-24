## ------------------------------ ##
# Site Map ----
## ------------------------------ ##

library(magrittr)

# Subset to desired sites
site_info <- site_subset()
dplyr::glimpse(site_info)

habitat_colors <- c("Admin" = "#fcbf49", "Urban" = "#f77f00",
                    "Marine" = "#0466c8", "Coastal" = "#34a0a4", "Freshwater" = "#8ecae6", 
                    "Forest" = "#007200", "Grassland" = "#70e000", 
                    "Mixed" = "#9d4edd", "Tundra" = "#bb9457")

# Identify min & max latitude / longitude
(min_lat <- min(site_info$lat, na.rm = T))
(max_lat <- max(site_info$lat, na.rm = T))
(min_lon <- min(site_info$lon, na.rm = T))
(max_lon <- max(site_info$lon, na.rm = T))

# Define latitude / longitude limits
(lat_lims <- c((min_lat - 0.1 * min_lat), (max_lat + 0.1 * max_lat)))
(lon_lims <- c((min_lon + 0.15 * min_lon), (max_lon - 0.15 * max_lon)))

# Get an object of world / US state borders
borders <- sf::st_as_sf(maps::map(database = "world", plot = F, fill = T)) %>%
  dplyr::bind_rows(sf::st_as_sf(maps::map(database = "state", plot = F, fill = T)))

# Make map
map <- borders %>%
  ggplot() +
  geom_sf(fill = "gray95") +
  # Set map extent
  coord_sf(xlim = lon_lims, ylim = lat_lims, expand = F) +
  # Add points & labels for LTER sites
  geom_point(data = site_info, aes(x = longitude, y = latitude, fill = habitat), 
             pch = 21, size = 4) +
  geom_label(data = site_info, aes(x = longitude, y = latitude),
             label = site_info$code, nudge_y = 0, nudge_x = 5, size = 3, fontface = "bold", 
             label.padding = unit(x = 0.15, units = "lines")) +
  # Customize color
  scale_fill_manual(values = habitat_colors) +
  # Customize axis labels
  labs(x = "Longitude", y = "Latitude") +
  # Tweak theme / formatting
  theme_bw() + 
  theme(panel.border = element_blank(),
        axis.title = element_blank(),
        axis.text = element_text(size = 12),
        legend.title = element_blank()); map

