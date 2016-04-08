#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#

library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  titlePanel("ACS Data Mapper"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       textInput("city",
                 label = "Enter location to zoom to:",
                 value = "Chicago, IL"
       ),
       numericInput("zoomLvl",label = "Set zoom level:", value = 11)
    ),
    # Show the map
    mainPanel(
      leafletOutput("mymap")
    )
  )
))
