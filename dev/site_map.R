## ------------------------------ ##
# Site Map ----
## ------------------------------ ##
# Load libraries
library(tidyverse); devtools::load_all()

# Clear environment
rm(list = ls())

# Subset to desired sites
site_info <- site_subset()
dplyr::glimpse(site_info)

# Custom color palette (by habitat)
habitat_colors <- c("Admin" = "#fcbf49", "Urban" = "#f77f00",
                    "Marine" = "#0466c8", "Coastal" = "#34a0a4", "Freshwater" = "#8ecae6", 
                    "Forest" = "#007200", "Grassland" = "#70e000", 
                    "Mixed" = "#9d4edd", "Tundra" = "#bb9457")

# Custom point shape (also by habitat)
habitat_shapes <- c("Admin" = 21, "Urban" = 21, # "Test" = 15,
                    "Marine" = 23, "Coastal" = 23, "Freshwater" = 23, 
                    "Forest" = 22, "Grassland" = 22, 
                    "Mixed" = 24, "Tundra" = 25)

# Get an object of world / US state borders
borders <- sf::st_as_sf(maps::map(database = "world", plot = F, fill = T)) %>%
  dplyr::bind_rows(sf::st_as_sf(maps::map(database = "state", plot = F, fill = T)))

# Consolidate some ggplot formatting elements
lter_map_theme <-  theme_bw() + 
  theme(axis.title = element_blank(),
        axis.text = element_text(size = 12),
        legend.title = element_blank())

## ------------------------------ ##
# Moorea Map (MCR) ----
## ------------------------------ ##
# Check coordinates
dplyr::filter(site_info, code == "MCR")

# Make map
mcr_map <- borders %>%
  ggplot() +
  geom_sf(fill = "gray95") +
  # Set map extent
  coord_sf(xlim = c(-160, -100), ylim = c(-25, 40), expand = F) +
  # Add points & labels for LTER sites
  geom_point(data = site_info, aes(x = longitude, y = latitude, 
                                   fill = habitat, shape = habitat), 
             size = 10) +
  # Customize color
  scale_fill_manual(values = habitat_colors) +
  scale_shape_manual(values = habitat_shapes) +
  # Customize axis labels
  labs(x = "Longitude", y = "Latitude") +
  # Tweak theme / formatting
  lter_map_theme +
  theme(legend.position = "none"); mcr_map

## ------------------------------ ##
  # Antarctica Map (MCM + PAL) ----
## ------------------------------ ##
# Check coordinates
dplyr::filter(site_info, code %in% c("MCM", "PAL"))

# Make map
south_map <- borders %>%
  ggplot() +
  geom_sf(fill = "gray95") +
  # Set map extent
  coord_sf(xlim = c(-80, 170), ylim = c(-80, -60), expand = F) +
  geom_point(data = site_info, aes(x = longitude, y = latitude, 
                                   fill = habitat, shape = habitat), 
             size = 10) +
  # Customize color
  scale_fill_manual(values = habitat_colors) +
  scale_shape_manual(values = habitat_shapes) +
  # Customize axis labels
  labs(x = "Longitude", y = "Latitude") +
  # Tweak theme / formatting
  lter_map_theme +
  theme(legend.position = "none"); south_map

## ------------------------------ ##
          # Alaska Map ----
## ------------------------------ ##
# Check coordinates
dplyr::filter(site_info, code %in% c("BLE", "ARC", "BNZ", "NGA"))

# Make map
ak_map <- borders %>%
  ggplot() +
  geom_sf(fill = "gray95") +
  # Set map extent
  coord_sf(xlim = c(-170, -130), ylim = c(58, 72), expand = F) +
  geom_point(data = site_info, aes(x = longitude, y = latitude, 
                                   fill = habitat, shape = habitat), 
             size = 10) +
  # Customize color
  scale_fill_manual(values = habitat_colors) +
  scale_shape_manual(values = habitat_shapes) +
  # Customize axis labels
  labs(x = "Longitude", y = "Latitude") +
  # Tweak theme / formatting
  lter_map_theme +
  theme(legend.position = "none"); ak_map

## ------------------------------ ##
# Puerto Rico Map (LUQ) ----
## ------------------------------ ##
# Check coordinates
dplyr::filter(site_info, code == "LUQ")

# Make map
luq_map <- borders %>%
  ggplot() +
  geom_sf(fill = "gray95") +
  # Set map extent
  coord_sf(xlim = c(-90, -60), ylim = c(10, 35), expand = F) +
  geom_point(data = site_info, aes(x = longitude, y = latitude, 
                                   fill = habitat, shape = habitat), 
             size = 10) +
  # Customize color
  scale_fill_manual(values = habitat_colors) +
  scale_shape_manual(values = habitat_shapes) +
  # Customize axis labels
  labs(x = "Longitude", y = "Latitude") +
  # Tweak theme / formatting
  lter_map_theme +
  theme(legend.position = "none"); luq_map

## ------------------------------ ##
# CONUS Map ----
## ------------------------------ ##
# CONUS == Continental US

# Check coordinates
dplyr::filter(site_info, !code %in% c("MCR", "MCM", "PAL", "LUQ",
                                      "BLE", "ARC", "BNZ", "NGA"))

# Make map
usa_map <- borders %>%
  ggplot() +
  geom_sf(fill = "gray95") +
  # Set map extent
  coord_sf(xlim = c(-125, -68), ylim = c(25, 48), expand = F) +
  geom_point(data = site_info, aes(x = longitude, y = latitude, 
                                   fill = habitat, shape = habitat), size = 6) +
  # Customize color
  scale_fill_manual(values = habitat_colors) +
  scale_shape_manual(values = habitat_shapes) +
  # Customize axis labels
  labs(x = "Longitude", y = "Latitude") +
  # Tweak theme / formatting
  lter_map_theme +
  theme(legend.position = "none"); usa_map


# End ----

