## ----------------------------------- ##
        # Update LTER Site Info
## ----------------------------------- ##

# Purpose:
## We need an easy way to update the LTER site information embedded in this package
## Assembling that dataframe here creates just such an update method
## while still keeping all package-relevant resources in a central location

## ----------------------------------- ##
# Housekeeping ----
## ----------------------------------- ##
# Load libraries
## install.packages("libarian")
librarian::shelf(tidyverse)

# Create the folder we'll need later
dir.create(path = file.path("data"), showWarnings = F)

# Clear environment
rm(list = ls())

## ----------------------------------- ##
          # Custom Function ----
## ----------------------------------- ##

# Very small / niche custom function that we'll want later
as_lter_site <- function(name, code, hab, start, end, lat, lon, url, status){
  
  # Assemble provided data into a dataframe with pre-defined column names
  ## Also lets us do repetitive formatting in a consistent way
  lter_df <- data.frame("name" = paste(stringr::str_to_title(name), "LTER"),
                        "code" = toupper(code),
                        "habitat" = stringr::str_to_title(hab),
                        "start_year" = as.numeric(start),
                        "end_year" = as.numeric(end),
                        "latitude" = as.numeric(lat),
                        "longitude" = as.numeric(lon),
                        "site_url" = url,
                        "site_status" = status)
  
  # Return dataframe
  return(lter_df) }

## ----------------------------------- ##
          # Per Site Info ----
## ----------------------------------- ##

# Begin by creating each site's relevant information as separate objects
# Order of information is as follows:
## c(full name, abbreviation, habitat, start_year, end_year, latit, longit, site_url, status)

# Andrews forest
and <- as_lter_site(name = "Andrews Forest", code = "AND", hab = "forest", 
                    start = 1980, end = 2026, lat = 44.21, lon = -122.26, 
                    url = "https://lternet.edu/sites/and", status = "active")

# Arctic
arc <- as_lter_site(name = "Arctic", code = "ARC", hab = "tundra", 
             start = 1987, end = 2023, lat = 68.62826, lon = -149.59598, 
             url = "https://lternet.edu/sites/arc", status = "active")


as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")

	ARC	Tundra	1987	2023			1637459		active
Baltimore Ecosystem Study LTER	BES	Urban	1997	2021	39.1	-76.3	1637661	https://lternet.edu/sites/bes	active
Beaufort Lagoon Ecosystem LTER	BLE	Marine	2017	2022	70.8	-149	1656026	https://lternet.edu/sites/ble	active
Bonanza Creek LTER	BNZ	Forest	1987	2023	64.86	-147.85	1636476	https://lternet.edu/sites/bnz	active
Central Arizona - Phoenix LTER	CAP	Urban	1997	2022	33.43	-111.93	1637590	https://lternet.edu/sites/cap	active

as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")


as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
as_lter_site(name = "", code = "", hab = "", 
             start = , end = , lat = , lon = , 
             url = "", status = "")
California Current Ecosystem LTER	CCE	Marine	2004	2022	32.87	-120.28	1637632	https://lternet.edu/sites/cce	active
Cedar Creek Ecosystem Science Reserve	CDR	Mixed Landscape	1982	2025	45.4	-93.2	1234162	https://lternet.edu/sites/cdr	active
Coweeta LTER	CWT	Forest	1980	2020	35	-83.5	1637522	https://lternet.edu/sites/cwt	active
Florida Coastal Everglades LTER	FCE	Coastal	2000	2025	25.47	-80.85	1237517	https://lternet.edu/sites/fce	active
Georgia Coastal Ecosystems LTER	GCE	Coastal	2000	2025	31.43	-81.37	1237140	https://lternet.edu/sites/gce	active
Hubbard Brook LTER	HBR	Forest	1988	2023	43.94	-71.75	1637685	https://lternet.edu/sites/hbr	active
Harvard Forest LTER	HFR	Forest	1988	2025	42.53	-72.19	1237491	https://lternet.edu/sites/hfr	active
Jornada Basin LTER	JRN	Mixed Landscape	1982	2024	32.62	-106.74	1235828	https://lternet.edu/sites/jrn	active
Kellogg Biological Station LTER	KBS	Grassland	1987	2023	42.4	-85.4	1637653	https://lternet.edu/sites/kbs	active
Konza Prairie LTER	KNZ	Grassland	1980	2026	39.09	-96.58	1440484	https://lternet.edu/sites/knz	active
Luquillo LTER	LUQ	Forest	1988	2025	18.3	-65.8	1546686	https://lternet.edu/sites/luq	active
McMurdo Dry Valleys LTER	MCM	Freshwater	1991	2023	-77	162.52	1637708	https://lternet.edu/sites/mcm	active
Moorea Coral Reef LTER	MCR	Coastal	2004	2022	-17.49	-149.83	1637396	https://lternet.edu/sites/mcr	active
Minneapolis-St. Paul	MSP	Urban	2021	2027					
Northeast U.S. Shelf LTER	NES	Marine	2017	2022	40.75	-70.65	1655686	https://lternet.edu/sites/nes	active
Northern Gulf of Alaska LTER	NGA	Marine	2017	2022	59.05	-148.7	1656070	https://lternet.edu/sites/nga	active
North Inlet LTER	NIN	Coastal	1980	1993					
North Temperate Lakes LTER	NTL	Freshwater	1980	2027	46.01	-89.67	1440297	https://lternet.edu/sites/ntl	active
Niwot Ridge LTER	NWT	Tundra	1980	2022	39.99	-105.38	1637686	https://lternet.edu/sites/nwt	active
Okefenokee LTER	OKE	Freshwater	1982	1989					
Palmer Antarctic LTER	PAL	Marine	1990	2022	-64.77	-64.05	1440435	https://lternet.edu/sites/pal	active
Plum Island Ecosystems LTER	PIE	Coastal	1998	2022	42.76	-70.89	1637630	https://lternet.edu/sites/pie	active
Santa Barbara Coastal LTER	SBC	Coastal	2000	2024	34.41	-119.84	1232779	https://lternet.edu/sites/sbc	active
Sevilleta LTER	SEV	Mixed Landscape	1988	2023	34.35	-106.88	1440478	https://lternet.edu/sites/sev	active
Shortgrass Steppe LTER	SGS	Grassland	1982	2014	40.83	-104.72		https://lternet.edu/sites/sgs	inactive
Virginia Coast Reserve LTER	VCR	Coastal	1987	2024	37.28	-75.91	1237733	https://lternet.edu/sites/vcr	active
Illinois Rivers LTER		Freshwater	1982	1989					

# End ----