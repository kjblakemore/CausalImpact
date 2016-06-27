library(shiny)

shinyUI(fluidPage(
  titlePanel('Causal Impact of External Events on Wikipedia Page Views'),
  sidebarLayout(
    sidebarPanel(
      textInput('y_article', 'Article:', 'Sia'),
      textInput('x1_article', 'Control Article 1:', 'Dragonette'),
      textInput('x2_article', 'Control Article 2:', 'PJ Harvey'),
      textInput('x3_article', 'Control Article 3:', 'Serena Ryder'),
      dateRangeInput('pre_period', 'Pre-period:', start = '2015=10-01',
        end = '2015-11-06'),
      dateRangeInput('post_period', 'Post-period:', start = '2015-11-07',
        end = '2015-11-14'),
      actionButton("submit", "Submit")
    ),
    mainPanel(
      plotOutput('plots'),
      verbatimTextOutput('summary')
    )
  )
))