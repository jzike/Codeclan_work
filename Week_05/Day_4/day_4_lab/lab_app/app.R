#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)


# data --------------------------------------------------------------------

students_big <- read_csv("data/students_big.csv")

age_select <- students_big %>% 
  distinct(ageyears) %>% 
 arrange(ageyears) %>% 
  pull(ageyears)



# ui ----------------------------------------------------------------------

ui <- fluidPage(
  radioButtons("age_input",
               "Age",
               choices = age_select,
               inline = TRUE),
  fluidRow(
    column(6, 
           plotOutput("height_histo")),
    column(6, 
           plotOutput("arm_span_histo"))
    
  )
)



# server ------------------------------------------------------------------

server <- function(input, output){
  
  filtered_age_data <- reactive({
    students_big %>% 
      filter(ageyears == input$age_input)
  })
  
  output$height_histo <- renderPlot({
    filtered_age_data() %>% 
      ggplot(aes(x = height)) +
      geom_histogram()
  })
  
  output$arm_span_histo <- renderPlot({
    filtered_age_data() %>% 
      ggplot(aes(x = arm_span)) +
      geom_histogram()
  })
}


shinyApp(ui = ui, server = server)