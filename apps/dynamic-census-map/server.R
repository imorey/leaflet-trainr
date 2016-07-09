#
# This is the server code for receiving a city, and pulling and mapping
# Census data for it
#

library(shiny)
library(leaflet)
library(ggmap) # has the geocode() function

# Define server logic required to map census data for the input area
shinyServer(function(input, output) {
   
  # Geocode city corresponding to input$city
  ll <- reactive(geocode(input$city))
  
  # Pull census data for that city
  # XXX Would need some way to look up the county for each city to form the
  # geography required by the ACS package.
  #   looks like this can be output from the geocode() step. E.g.
  #   geocode("Chicago, IL", output = "more") returns "Cook County" in element
  #   titled "administrative_area_level_2".
  #   And, if geocoding an address, e.g. geocode("1313 E 60th St, Chicago, IL", output = "more"),
  #   the "locality" is Chicago, "administrative_area_level_2" is county, and 
  #   "administrative_area_level_1 is "Illinois",
  #   We can look up the appropriate abbreviation by using the built-in data
  #   sets state.abb and state.name.
  
  # Pull census tract polygon data for that city
  # XXX We might download and just subset from everything, or perhaps do on-the-fly
  # downloads from the Census FTP site ftp://ftp2.census.gov/geo/tiger/TIGER2015/TRACT/
  # State tract files are ~10mb which would take a bit of time to download,
  # unpack and subset. However we could use a progress bar while that's
  # happening. And this would only have to happen once for each city that
  # the user jumped to. It'd be likely that they'd just go to a single one.
  
  output$mymap <- renderLeaflet({
    
    leaflet() %>%
      addTiles() %>%
      setView(lng = ll()$lon, lat = ll()$lat, zoom = input$zoomLvl)
    
  })
  
})
