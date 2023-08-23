## ------------------------------ ##
# Site Map ----
## ------------------------------ ##

# Identify min & max latitude / longitude
(min_lat <- min(site_actual$lat, na.rm = T))
(max_lat <- max(site_actual$lat, na.rm = T))
(min_lon <- min(site_actual$lon, na.rm = T))
(max_lon <- max(site_actual$lon, na.rm = T))

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
  geom_point(data = site_actual, aes(x = lon, y = lat, fill = habitat), pch = 21, size = 4) +
  geom_label(data = site_actual, aes(x = lon, y = lat),
             label = site_actual$code, nudge_y = 0, nudge_x = 5, size = 3, fontface = "bold", 
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

