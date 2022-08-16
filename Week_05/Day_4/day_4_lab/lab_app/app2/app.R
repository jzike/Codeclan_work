library(shiny)
library(tidyverse)



# data --------------------------------------------------------------------

students_big <- read_csv(here::here("data/students_big.csv"))



# ui ----------------------------------------------------------------------

ui <- fluidPage(
  titlePanel("Reaction Time vs. Memory Game"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("colour_input",
                   "Colour of Points",
                   choices = c(Blue = "#3891A6",
                               Yellow = "#FDE74C",
                               Red = "#E3655B")),
      sliderInput("alpha_input",
                  "Transparency of points",
                  min = 0,
                  max = 1, 
                  value = 0.5),
      selectInput("shape_input",
                  "Shape of Points",
                  choices = c(Square = "15",
                              Circle = "16",
                              Triangle = "17")),
      textInput("title_input",
                "Title of Graph",
                value = "Reaction Time vs. Memory Game")
    ),
    
    mainPanel(
      plotOutput("reaction_plot")
    )
    
  )
  
  
  
)


# server ------------------------------------------------------------------

server <- function(input, output){
  
  output$reaction_plot <- renderPlot({
    
    students_big %>% 
      ggplot(aes(x = reaction_time,
                 y = score_in_memory_game)) + 
      geom_point(
        alpha = input$alpha_input,
        colour = input$colour_input,
        shape = as.numeric(input$shape_input)
      ) +
      ggtitle(input$title_input)
    
  })
  
}

shinyApp(ui = ui, server = server)