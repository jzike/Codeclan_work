library(leaflet)
library(tidyverse)
library(shiny)
library(CodeClanData)

library(tidyverse)
library(shiny)

students_big 

ui <- fluidPage(
  sliderInput("sample_size", "Sample Size", value = 50, min = 1, max = 912),
  plotOutput("histogram")
)

server <- function(input, output) {
  
  sampled_data <- reactive({
    students_big %>%
      select(height) %>%
      sample_n(input$sample_size) 
    })
  
  output$histogram <- renderPlot({
    
    ggplot(sampled_data()) +
      aes(x = height) +
      geom_histogram()
    
  })
  }

  shinyApp(ui = ui, server = server)