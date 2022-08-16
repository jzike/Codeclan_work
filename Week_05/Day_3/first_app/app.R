library(shiny)
library(tidyverse)
library(bslib)

olympic_overall_medals <- read_csv("data/olympics_overall_medals.csv") %>% 
  mutate(medal = factor(medal, c("Gold", "Silver", "Bronze")))

all_teams <- unique(olympic_overall_medals$team)
all_seasons <- unique(olympic_overall_medals$season)

# User Interface
ui <- fluidPage(
  
  # theme = bs_theme(bootswatch = 'flatly'),
  # theme = 'path_to/my_stylesheet.css',
  
  titlePanel(tags$h1("Olympic Medals")),
  
  
  
  tabsetPanel(
    tabPanel("Plot",
             plotOutput('medal_plot')
    ),
    
    
    
    tabPanel("Which season?",
             selectInput(inputId = 'team_input',
                         label = 'Which team?',
                         choices = all_teams
             )
    ),
    
    
    
    tabPanel("Which team?",
             radioButtons(inputId = 'season_input',
                          label = tags$i('Summer or Winter Olympics?'),
                          choices = all_seasons
             )
             
    )
    
    
  ),
  
  
  # HTML: HyperText Markup Language
  tags$a('The Olympics website', href = 'https://www.Olympic.org') 
  
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
