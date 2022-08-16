
library(shiny)
library(tidyverse)
library(bslib)

olympic_overall_medals <- read_csv("data/olympics_overall_medals.csv") %>% 
  mutate(medal = factor(medal, c("Gold", "Silver", "Bronze")))

all_teams <- unique(olympic_overall_medals$team)
all_seasons <- unique(olympic_overall_medals$season)

# User Interface
ui <- fluidPage(
  
  theme = bs_theme(bootswatch = "flatly"),
  #theme = "pathto/mystylesheet.css", <- including a CSS theme in R Shiny apps
  
  titlePanel(tags$h1("Olympic medals")),
  
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      p("Sidebar"),
      radioButtons(inputId = "season_input",
                   label = tags$i("Summer or Winter Olympics?"),
                   choices = all_seasons),
      selectInput(inputId = "team_input",
                  label = "Which team?",
                  choices = all_teams
      )
    ),
    mainPanel = mainPanel(
      "Main panel",
      HTML("<br/><br/>"),
      plotOutput("medal_plot"),
      tags$a("The Olympics website", href = "https://www.Olympic.org")
    )
  )
)



server <- function(input, output) {
  
  output$medal_plot <- renderPlot({
    olympic_overall_medals %>%
      filter(team == input$team_input,
             season == input$season_input) %>%
      ggplot(aes(x = medal, y = count, fill = medal)) +
      geom_col()
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
