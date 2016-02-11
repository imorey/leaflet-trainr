# This script is Nick's own work following along with the leaflet for R
# tutorial created by RStudio: https://rstudio.github.io/leaflet/

library(leaflet)

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

