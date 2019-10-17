library(leaflet)
library(magrittr)
library(sf)

# basic mapping ----
leaflet() %>%
  addTiles()

## change basemaps
leaflet() %>% 
  addProviderTiles(leaflet::providers$Stamen.Terrain)

leaflet() %>% 
  addProviderTiles(leaflet::providers$Esri.WorldTopoMap)

# get some data ----
dat <- read_sf('Fast_Food_Chain_Restaurants/Fast_Food_Chain_Restaurants.shp')

leaflet(dat[1:10, ]) %>% 
  addTiles() %>% 
  addMarkers()

## add popups
leaflet(dat[1:10, ]) %>% 
  addTiles() %>% 
  addMarkers(popup = ~htmltools::htmlEscape(Name))

## add tooltips on hover (labels)
leaflet(dat[1:10, ]) %>% 
  addTiles() %>% 
  addMarkers(label = ~htmltools::htmlEscape(Name))

# circle markers ----
leaflet(dat) %>% 
  addTiles() %>% 
  addCircleMarkers(
    radius = 7, stroke = F, fillOpacity = .5,
    popup = ~htmltools::htmlEscape(Name)
  )

# color palettes ----
## filter data for simplicity
filtered_dat <- dat[dat$Name %in% c('Burger King', 'McDonald\'s', 'Taco Bell'), ]

## create color palette
pal <- colorFactor(c('Red', 'Yellow', 'Purple'), domain = c('Burger King', 'McDonald\'s', 'Taco Bell'))

## map it
leaflet(filtered_dat) %>% 
  addTiles() %>% 
  addCircleMarkers(
    radius = 7, stroke = F, fillOpacity = .5,
    color = ~pal(Name),
    popup = ~htmltools::htmlEscape(Name)
  )

# final map ----
leaflet(filtered_dat) %>% 
  addProviderTiles(providers$CartoDB.DarkMatterNoLabels, group = 'Dark Mode') %>% 
  addProviderTiles(providers$CartoDB.PositronNoLabels, group = 'Light Mode') %>% 
  addCircleMarkers(
    radius = 4, stroke = F, fillOpacity = .75,
    color = ~pal(Name),
    popup = ~htmltools::htmlEscape(Name)
  ) %>% 
  addLegend(pal = pal, values = ~Name, position = 'bottomright') %>% 
  addLayersControl(
    baseGroups = c('Dark Mode', 'Light Mode')
  )
  

