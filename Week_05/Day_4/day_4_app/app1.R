library(shiny)
library(tidyverse)
library(DT)


# read in and prep data ---------------------------------------------------

students_big <- read_csv("data/students_big.csv")

handed_choices <- students_big %>% 
  distinct(handed) %>% 
  pull()

region_choices <- students_big %>% 
  distinct(region) %>% 
  pull()

gender_choices <- students_big %>% 
  distinct(gender) %>% 
  pull()

#Radio button for handedness
#Table to display the data, filtered by handedness
#add two plots to the UI, underneith the buttons, above the table
#add in code to server to make these plots appear



# ui ----------------------------------------------------------------------


ui <- fluidPage(
  fluidRow(
    column(3, (radioButtons("handed_input",
                 "Handedness",
                 choices = handed_choices,
                 inline = TRUE))),
    column(3, (selectInput("region_input",
                "Region",
                choices = region_choices))),
    column(3, (selectInput("gender_input",
                "Gender",
                choices = gender_choices))),
    column(3, (radioButtons("colour_input",
                        "Graph colour?",
                        choices = c("Gold", "Forest green"))))
  ),
  
  #add in action button
  
  actionButton("update",
               "Update dashboard"),
  
  fluidRow(
    column(6, 
           plotOutput("travel_barplot")),
    column(6,
           plotOutput("spoken_barplot"))
  ),

  
  DT::dataTableOutput("table_output")
  
)


# server ------------------------------------------------------------------

server <- function(input, output){
  
  filtered_data <- eventReactive(input$update, {
    students_big %>% 
      filter(handed == input$handed_input,
             region == input$region_input,
             gender == input$gender_input)
  })
   
  
  
  output$table_output <- DT::renderDataTable({
    filtered_data()
  })
  
  output$travel_barplot <- renderPlot({
    filtered_data() %>% 
      ggplot(aes(x = travel_to_school)) +
      geom_bar(fill = input$colour_input)
  })
  
  
  output$spoken_barplot <- renderPlot({
    filtered_data() %>% 
      ggplot(aes(x = languages_spoken)) +
      geom_bar(fill = input$colour_input)
  })
  
  
  
}



# run app -----------------------------------------------------------------

shinyApp(ui = ui, 
         server = server)
