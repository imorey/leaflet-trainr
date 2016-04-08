# This script is Nick's own work following along with the leaflet for R
# tutorial created by RStudio: https://rstudio.github.io/leaflet/

library(leaflet)
try(setwd("~/GitHub/leaflet-trainr/"))

### Hello, Chicago -------------------------------------------------------------
m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=-87.5947675, lat=41.7858686, popup="Chape")
m  # Print the map

### Map Widget -----------------------------------------------------------------

# attempting use of setView(), fitBounds(), and clearBounds()
# I used geojson.io to get bounding box coordinates
leaflet() %>% addTiles() %>% setView(lng=-87.5947675, lat=41.7858686, zoom = 11)
leaflet() %>% addTiles() %>% setView(lng=-87.5947675, lat=41.7858686, zoom = 14)
leaflet() %>% addTiles() %>% fitBounds(lng1 = -87.61648178100586,
                                       lat1 = 41.78628905590487,
                                       lng2 = -87.60635375976562,
                                       lat2 = 41.80203073088394)

# add some circles to a map
df = data.frame(Lat = 1:10, Long = rnorm(10))
leaflet(df) %>% addCircles()
# leaflet() smartly identifies the right fields based on their names

# equivalent map generation, with more explicit reference to the field names
leaflet(df) %>% addCircles(lng = ~Long, lat = ~Lat)

# still another, where data can be specified in the layer itself (to override
# the specification of a different data set specified in leaflet())
leaflet() %>% addCircles(data = df)

# Generating maps using objects created by the sp package
library(sp)
Sr1 = Polygon(cbind(c(2, 4, 4, 1, 2), c(2, 3, 5, 4, 2)))
Sr2 = Polygon(cbind(c(5, 4, 2, 5), c(2, 3, 2, 2)))
Sr3 = Polygon(cbind(c(4, 4, 5, 10, 4), c(5, 3, 2, 5, 5)))
Sr4 = Polygon(cbind(c(5, 6, 6, 5, 5), c(4, 4, 3, 3, 4)), hole = TRUE)
str(Sr1)
Sr1
Srs1 = Polygons(list(Sr1), "s1")
str(Srs1)
Srs1
Srs2 = Polygons(list(Sr2), "s2")
Srs3 = Polygons(list(Sr4, Sr3), "s3/4")
SpP = SpatialPolygons(list(Srs1, Srs2, Srs3), 1:3)
str(SpP)
SpP
leaflet(height = "300px") %>% addPolygons(data = SpP)

# Generating a map using an object created with the maps package
library(maps)
mapStates <- map("state", fill = TRUE, plot = FALSE)
str(mapStates)
topo.colors(10, alpha = NULL)
leaflet(data = mapStates) %>% addTiles() %>%
  addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)

# using the formula interface
# Anything to the right of the tilde is a formula that is evaluated based on the
# data argument, which could be variables, or even expressions, e.g. ~sqrt(x+1)
m = leaflet() %>% addTiles()
df = data.frame(
  lat = rnorm(100),
  lng = rnorm(100),
  size = runif(100, 5, 20),
  color = sample(colors(), 100)
)
m = leaflet(df) %>% addTiles()
m %>% addCircleMarkers(radius = ~size, color = ~color, fill = FALSE)
m %>% addCircleMarkers(radius = runif(100, 4, 10), color = c('red'))

### Using Basemaps -------------------------------------------------------------

# In the above examples, addTiles() uses OSM maps by default
# Others (such as these - http://leaflet-extras.github.io/leaflet-providers/preview/index.html)
# can be registered for with this plugin - https://github.com/leaflet-extras/leaflet-providers

# /!\ go through the process to get at least some of these. The CartoDB.Positrom
# one is pretty nice
# THunderforest landscape is really artistically attractive.
# Mapbox is nice and clean
# Esri.WorldStreetMap is also nice and clean as a street map


### Using Markers --------------------------------------------------------------
data(quakes)

# Basic marker use
leaflet(data = quakes[1:20,]) %>% addTiles() %>%
  addMarkers(~long, ~lat, popup = ~as.character(mag))

# Can generate custom markers
greenLeafIcon <- makeIcon(
  iconUrl = "http://leafletjs.com/docs/images/leaf-green.png",
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = "http://leafletjs.com/docs/images/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)

leaflet(data = quakes[1:4,]) %>% addTiles() %>%
  addMarkers(~long, ~lat, icon = greenLeafIcon)

# Can create custom markers with simple conditionals
quakes1 <- quakes[1:10,]

leafIcons <- icons(
  iconUrl = ifelse(quakes1$mag < 4.6,
                   "http://leafletjs.com/docs/images/leaf-green.png",
                   "http://leafletjs.com/docs/images/leaf-red.png"
  ),
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = "http://leafletjs.com/docs/images/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)
str(leafIcons)

leaflet(data = quakes1) %>% addTiles() %>%
  addMarkers(~long, ~lat, icon = leafIcons)


# Can create custom markers with greater differentiation
oceanIcons <- iconList(
  ship = makeIcon("ferry-18.png", "ferry-18@2x.png", 18, 18), # Arguments are: Url RetinaUrl, Width, Height
  pirate = makeIcon("danger-24.png", "danger-24@2x.png", 24, 24)
)
# /!\ Not sure where these come from
oceanIcons

# Some fake data
df <- sp::SpatialPointsDataFrame(
  cbind(
    (runif(20) - .5) * 10 - 90.620130,  # lng
    (runif(20) - .5) * 3.8 + 25.638077  # lat
  ),
  data.frame(type = factor(
    ifelse(runif(20) > 0.75, "pirate", "ship"),
    c("ship", "pirate")
  ))
)
df

leaflet(df) %>% addTiles() %>%
  # Select from oceanIcons based on df$type
  addMarkers(icon = ~oceanIcons[type])

# Marker clusters
leaflet(quakes) %>% addTiles() %>% addMarkers(
  clusterOptions = markerClusterOptions()
) # One can click to successively zoom in to inspect clusters
# Zooming out reaggregates the markers into clusters

# Circle markers
leaflet(df) %>% addTiles() %>% addCircleMarkers()

# Customize circle markers with size, color, and opacity
pal <- colorFactor(c("navy", "red"), domain = c("ship", "pirate"))

leaflet(df) %>% addTiles() %>%
  addCircleMarkers(
    radius = ~ifelse(type == "ship", 6, 10),
    color = ~pal(type),
    stroke = FALSE, fillOpacity = 0.5
  ) # Stroke is the extra ring near the outside


### Pop-ups --------------------------------------------------------------------

# Pop-ups can be stylized with html
content <- paste(sep = "<br/>",
                 "<b><a href='http://www.samurainoodle.com'>Samurai Noodle</a></b>",
                 "606 5th Ave. S",
                 "Seattle, WA 98138"
)

leaflet() %>% addTiles() %>%
  addPopups(-122.327298, 47.597131, content,
            options = popupOptions(closeButton = FALSE)
  )

# There are ways to have names with inadvertent HTML escapes to display properly
library(htmltools)

df <- read.csv(textConnection(
  "Name,Lat,Long
  Samurai<b>Noodle</b>,47.597131,-122.327298
  Kukai Ramen,47.6154,-122.327157
  Tsukushinbo,47.59987,-122.326726"
))

leaflet(df) %>% addTiles() %>%
  addMarkers(~Long, ~Lat, popup = ~Name)
leaflet(df) %>% addTiles() %>%
  addMarkers(~Long, ~Lat, popup = ~htmlEscape(Name))


### Lines and Shapes -----------------------------------------------------------

# Reading shape file to display polygons with indicated color, opacity, smoothness
library(rgdal)

# From https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html
# /!\ Need to download this file...
states <- readOGR("data/tutorial-data/cb_2014_us_state_20m.shp",
                  layer = "cb_2014_us_state_20m", verbose = FALSE)

neStates <- subset(states, states$STUSPS %in% c(
  "CT","ME","MA","NH","RI","VT","NY","NJ","PA"
))

leaflet(neStates) %>%
  addPolygons(
    stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5,
    color = ~colorQuantile("YlOrRd", states$AWATER)(AWATER)
  )

# Circles -- these differ from the circle markers in that they scale with the map
cities <- read.csv(textConnection("
                                  City,Lat,Long,Pop
                                  Boston,42.3601,-71.0589,645966
                                  Hartford,41.7627,-72.6743,125017
                                  New York City,40.7127,-74.0059,8406000
                                  Philadelphia,39.9500,-75.1667,1553000
                                  Pittsburgh,40.4397,-79.9764,305841
                                  Providence,41.8236,-71.4222,177994
                                  "))

leaflet(cities) %>% addTiles() %>%
  addCircles(lng = ~Long, lat = ~Lat, weight = 1,
             radius = ~sqrt(Pop) * 30, popup = ~City
  )

# Rectangles -- ad hoc bounding boxes, as desired
# Remember that it's possible to get coordinates from tools like this: http://boundingbox.klokantech.com/ 
leaflet() %>% addTiles() %>%
  addRectangles(
    lng1=-118.456554, lat1=34.078039,
    lng2=-118.436383, lat2=34.062717,
    fillColor = "transparent"
  )

### Working with GeoJSON and TopoJSON ------------------------------------------
# Read about these formats and see examples here: https://en.wikipedia.org/wiki/GeoJSON

library(jsonlite)
geojson <- readLines("data/tutorial-data/countries.geojson", warn = FALSE) %>%
  paste(collapse = "\n") %>%
  fromJSON(simplifyVector = FALSE)
str(geojson)

# Default styles for all features
geojson$style = list(
  weight = 1,
  color = "#555555",
  opacity = 1,
  fillOpacity = 0.8
)

# Gather GDP estimate from all countries
gdp_md_est <- sapply(geojson$features, function(feat) {
  feat$properties$gdp_md_est
})
# Gather population estimate from all countries
pop_est <- sapply(geojson$features, function(feat) {
  max(1, feat$properties$pop_est)
})

# Color by per-capita GDP using quantiles
pal <- colorQuantile("Greens", gdp_md_est / pop_est)
# Add a properties$style list to each feature
geojson$features <- lapply(geojson$features, function(feat) {
  feat$properties$style <- list(
    fillColor = pal(
      feat$properties$gdp_md_est / max(1, feat$properties$pop_est)
    )
  )
  feat
})

# Add the now-styled GeoJSON object to the map
leaflet() %>% addGeoJSON(geojson)

# Resulting map has styling but no apparent pop-ups or labels. Would have to
# search for ways to embed/display that within the geojson format.


### Raster Images --------------------------------------------------------------

### Using Leaflet with Shiny ---------------------------------------------------

### Colors ---------------------------------------------------------------------

### Legends --------------------------------------------------------------------

### Show/Hide Layers -----------------------------------------------------------


