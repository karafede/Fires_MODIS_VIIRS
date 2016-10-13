
library(rgdal)
library(leaflet)

setwd ("C:/Fires_MODIS_VIIRS") 

# shape file for Europe
dir_EU <- "C:/Fires_MODIS_VIIRS/EU_shp"
dir_MODIS <- "C:/Fires_MODIS_VIIRS/MODIS_shp"
dir_VIIRS <- "C:/Fires_MODIS_VIIRS/VIIRS_shp"

### read shapefiles shapefile
shp_EU <- readOGR(dsn = dir_EU, layer = "Europe_Countries")

# shapefiles for MODIS (MCD14DL) MODIS_C6_Europe_24h last 24h
MODIS_shp <- readOGR(dsn = dir_MODIS, layer = "MODIS_C6_Europe_24h")

# shapefiles for # and VIIRS 375 m (VNP14IMGTDL_NRT) for the last 24 hours
VIIRS_shp <- readOGR(dsn = dir_VIIRS, layer = "VNP14IMGTDL_NRT_Europe_24h")

# ----- Transform to EPSG 4326 - WGS84 (required)
shp_EU <- spTransform(shp_EU, CRS("+init=epsg:4326"))
# MODIS_shp <- spTransform(MODIS_shp, CRS("+init=epsg:4326"))
# VIIRS_shp <- spTransform(VIIRS_shp, CRS("+init=epsg:4326"))
# plot(shp_EU)
# plot(MODIS_shp)
# plot(VIIRS_shp)



##### MODIS leaflet map---------------------------------------------------




##### Leaflet maps---------------------------------------------------

# define a colorbar for MODIS data
MIN_MODIS = min(MODIS_shp$BRIGHTNESS)
MAX_MODIS = max(MODIS_shp$BRIGHTNESS)

# define a colorbar for VIIRS data
MIN_VIIRS = min(VIIRS_shp$BRIGHT_TI4)
MAX_VIIRS = max(VIIRS_shp$BRIGHT_TI4)

# define color palette for the variable
pal_BRIGHTNESS_MODIS <- colorNumeric(
  palette = c(
    "#0000ff", "#0000ff", "#ffa500", "#ffff00", "#7f0000", "#7f0000"
  ),
  c(MIN_MODIS, MAX_MODIS)
)

# define color palette for the variable
pal_BRIGHTNESS_VIIRS <- colorNumeric(
  palette = c(
    "#0000ff", "#0000ff", "#ffa500", "#ffff00", "#7f0000", "#7f0000"
  ),
  c(MIN_VIIRS, MAX_VIIRS)
)

# define popup for the iteractive map
popup_BRIGHTNESS_MODIS <- paste0(
  "Brightness Temperature",": <strong> ", MODIS_shp$BRIGHTNESS, " </strong> (K)"
)


# define popup for the iteractive map
popup_BRIGHTNESS_VIIRS <- paste0(
  "Brightness Temperature",": <strong> ", VIIRS_shp$BRIGHT_TI4, " </strong> (K)"
)




# plot data on a leaflet map
map <- leaflet() %>%
  addTiles() %>%
  #  setView(long, lat, zoom) %>%
  addTiles(group = "OSM (default)") %>%
  addProviderTiles("OpenStreetMap.Mapnik", group = "Road map") %>%
  addProviderTiles("Thunderforest.Transport", group = "Thunderforest") %>%
  addProviderTiles("Hydda.Full", group = "Hydda_Full") %>%
  addProviderTiles("Hydda.Base", group = "Hydda_Base") %>%
  addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
  addProviderTiles("Stamen.TonerLite", group = "Toner Lite") %>%
  
  addCircleMarkers(
    lng = VIIRS_shp$LONGITUDE, lat = VIIRS_shp$LATITUDE,
    popup = popup_BRIGHTNESS_VIIRS,
    weight = 3, radius = 2,
    color = pal_BRIGHTNESS_VIIRS(VIIRS_shp$BRIGHT_TI4), stroke = FALSE, fillOpacity = 1,
    group = "Temperature_VIIRS"
  ) %>%
  addCircleMarkers(
    lng = MODIS_shp$LONGITUDE, lat = MODIS_shp$LATITUDE,
    popup = popup_BRIGHTNESS_MODIS,
    weight = 3, radius = 2,
    color = pal_BRIGHTNESS_MODIS(MODIS_shp$BRIGHTNESS), stroke = FALSE, fillOpacity = 1,
    group = "Temperature_MODIS"
  ) %>%
  
  addLegend(
    "bottomright", pal = pal_BRIGHTNESS_VIIRS, values = c(MIN_VIIRS, MAX_VIIRS),
    title = paste(
      "Brightness Temperature","(K):"
    ),
    labFormat = labelFormat(prefix = ""), labels = "black",
    opacity = 1
  ) %>%
  addLayersControl(
    # baseGroups = background,
    baseGroups = c("Road map", "Thunderforest", "Hydda_Full", "Hydda_Base", "Satellite", "Toner Lite"),
    overlayGroups =  c("Temperature_VIIRS", "Temperature_MODIS"),
    options = layersControlOptions(collapsed = TRUE)) %>%
    hideGroup("Temperature_MODIS") 

map










