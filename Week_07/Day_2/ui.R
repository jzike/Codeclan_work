library(dplyr)
library(magrittr)
library(leaflet)

whisky_data <- CodeClanData::whisky

regions <- sort(unique(whisky_data$Region))

ui <- fluidPage(
  #input
  selectInput(
    "region",
    "Which region?",
    choices = regions
  ),
  
  
  #output
  
  leafletOutput("whisky_map")
)

server <- function(input, output){
  output$whisky_map <- renderLeaflet(
    whisky_data %>% 
      filter(Region == input$region) %>% 
      leaflet() %>% 
      addTiles() %>% 
      addCircleMarkers(lat = ~Latitude, lng = ~Longitude,
                       popup = ~Distillery,
                       clusterOptions = markerClusterOptions())
  )
}

shinyApp(ui = ui, server = server)

