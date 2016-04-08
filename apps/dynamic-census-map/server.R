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
  
  output$mymap <- renderLeaflet({
    
    leaflet() %>%
      addTiles() %>%
      setView(lng = ll()$lon, lat = ll()$lat, zoom = input$zoomLvl)
    
  })
  
})
