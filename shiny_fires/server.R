
library(shiny)
library(dplyr)
library(leaflet)

###############################################################

shinyServer(function(input, output) {
  
  Map_fires <- reactive({
    map_rain <- leaflet() %>%
      addTiles() %>%
      addTiles(group = "OSM (default)") %>%
      addProviderTiles("OpenStreetMap.BlackAndWhite", group = "Road map") %>%
      #  addProviderTiles("OpenStreetMap.Mapnik", group = "Road map") %>%
      addProviderTiles("Thunderforest.Landscape", group = "Topographical") %>%
      addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
      addProviderTiles("Stamen.TonerLite", group = "Toner Lite") %>%
      setView(18, 50, 4) %>%
      addProviderTiles("OpenWeatherMap.Rain", options = providerTileOptions(opacity = 0.35)) %>%
      
    addWMSTiles(
      "https://firms.modaps.eosdis.nasa.gov/wms/viirs/?SERVICE=WMS&VERSION=1.1.1&REQUEST=GETCAPABILITIES",
      layers = "fires48", # fires hotspts every 48 hours
      options = WMSTileOptions(format = "image/png", transparent = TRUE, opacity = 1),
      group = "VIIRS_fires_48h", attribution = "FIRMS copyright NASA") %>%
    
    addWMSTiles(
      "https://firms.modaps.eosdis.nasa.gov/wms/c6/?SERVICE=WMS&VERSION=1.1.1&REQUEST=GETCAPABILITIES",
      layers = "fires48", # fires hotspts every 48 hours
      options = WMSTileOptions(format = "image/png", transparent = TRUE, opacity = 1),
      group = "MODIS_fires_48h", attribution = "FIRMS copyright NASA") %>%
      
      addLayersControl(
        baseGroups = c("Road map", "Topographical", "Satellite", "Toner Lite", "OpenWeatherMap.Rain"),
        overlayGroups = c("MODIS_fires_48h","VIIRS_fires_48h"), 
        options = layersControlOptions(collapsed = TRUE))
    #%>%
    #  hideGroup("MODIS_fires_24")
  })
  
  

  finalMap_rain <- reactive({
    map_rain <- leaflet() %>%
      addTiles() %>% 
      addTiles(group = "OSM (default)") %>%
      addProviderTiles("OpenStreetMap.Mapnik", group = "Road map") %>%
      addProviderTiles("Thunderforest.Landscape", group = "Topographical") %>%
      addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
      addProviderTiles("Stamen.TonerLite", group = "Toner Lite") %>%
      setView(18, 38, 4) %>%
      addProviderTiles("OpenWeatherMap.Rain", options = providerTileOptions(opacity = 0.35)) %>%
      
      addWMSTiles(
        "https://firms.modaps.eosdis.nasa.gov/wms/c6/?SERVICE=WMS&VERSION=1.1.1&REQUEST=GETCAPABILITIES",
        layers = "fires24", #this is the year
        options = WMSTileOptions(format = "image/png", transparent = TRUE, opacity = 1),
        group = "MODIS_fires_24", attribution = "FIRMS copyright NASA") %>%
      
      addLayersControl(
        baseGroups = c("Road map", "Topographical", "Satellite", "Toner Lite", "OpenWeatherMap.Rain"),
        overlayGroups = c("WMS", "MODIS_fires_24") ,
        options = layersControlOptions(collapsed = TRUE))
    #%>%
    #  hideGroup("MODIS_fires_24") 
  })
  
  
  
  finalMap_temperature <- reactive({
    map_temperature <- leaflet() %>%
      addTiles() %>% 
      setView(18, 38, 4) %>%
      addProviderTiles("OpenWeatherMap.Temperature", options = providerTileOptions(opacity = 0.35))
  })
  
  
  finalMap_clouds <- reactive({
    map_clouds <- leaflet() %>%
    #  addTiles() %>% 
      setView(18, 38, 4) %>%
      addProviderTiles("Thunderforest.TransportDark", options = providerTileOptions(opacity = 1)) %>%
      addProviderTiles("OpenWeatherMap.Clouds", options = providerTileOptions(opacity = 0.35))
  })
  
  
  finalMap_wind <- reactive({
    map_wind <- leaflet() %>%
      addTiles() %>% 
      setView(18, 38, 4) %>%
      addProviderTiles("OpenWeatherMap.Wind", options = providerTileOptions(opacity = 0.35))
  })
  
  finalMap_pressure <- reactive({
    map_pressure <- leaflet() %>%
      addTiles() %>% 
      setView(18, 38, 4) %>%
      addProviderTiles("OpenWeatherMap.PressureContour", options = providerTileOptions(opacity = 0.35))
  })
  
  finalMap_AOD <- reactive({
    map_AOD <- leaflet() %>%
      addTiles() %>% 
      setView(18, 38, 4) %>%
      addProviderTiles("NASAGIBS.ModisTerraAOD", options = providerTileOptions(opacity = 0.35))
  })
  
  finalMap_Chlorophyll <- reactive({
    map_Chlorophyll <- leaflet() %>%
      addTiles() %>% 
      setView(18, 38, 4) %>%
      addProviderTiles("NASAGIBS.ModisTerraChlorophyll", options = providerTileOptions(opacity = 0.35))
  })
  
  # Return to client
  output$myMap_fires = renderLeaflet(Map_fires())
  output$myMap_rain = renderLeaflet(finalMap_rain())
  output$myMap_temperature = renderLeaflet(finalMap_temperature())
  output$myMap_clouds = renderLeaflet(finalMap_clouds())
  output$myMap_wind = renderLeaflet(finalMap_wind())
  output$myMap_pressure = renderLeaflet(finalMap_pressure())
  output$myMap_AOD = renderLeaflet(finalMap_AOD())
  output$myMap_Chlorophyll = renderLeaflet(finalMap_Chlorophyll())
  

  
  

})
