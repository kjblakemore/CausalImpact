library(shiny)
library(CausalImpact)
library(pageviews)

shinyServer(function(input, output) {
  impact <- eventReactive(input$submit, {
    # Convert date strings to R objects
    pre_start <- as.Date(input$pre_period[1])
    pre_end <- as.Date(input$pre_period[2])
    post_start <- as.Date(input$post_period[1])
    post_end <- as.Date(input$post_period[2])

    # Load Pageview Counts.  
    start_timestamp <- pageview_timestamps(pre_start) # convert to 'yymmddhh'
    end_timestamp <- pageview_timestamps(post_end)    # convert to 'yymmddhh'
    y_pageviews <- article_pageviews(article = input$y_article, 
      start = start_timestamp, end = end_timestamp)
    x1_pageviews <- article_pageviews(article = input$x1_article,
      start = start_timestamp, end = end_timestamp)
    x2_pageviews <- article_pageviews(article = input$x2_article,
      start = start_timestamp, end = end_timestamp)
    x3_pageviews <- article_pageviews(article = input$x3_article,
      start = start_timestamp, end = end_timestamp)
          
    # Create Data Set
    #   From the dataframes above, create data sets of time series consisting 
    #   of the response variable y and predictors x[i].
    count <- nrow(y_pageviews)  # The number of days in data set
    time.points <- seq.Date(pre_start, by = 1, length.out = count)
    data <- zoo(cbind(y_pageviews["views"], x1_pageviews["views"], 
      x2_pageviews["views"], x3_pageviews["views"]), time.points)
    colnames(data) <- c("y", "x1", "x2", "x3")

    # Construct Time Series Model
    pre.period <- c(pre_start, pre_end)
    post.period <- c(post_start, post_end)
    CausalImpact(data, pre.period, post.period)
  })

  output$plots <- renderPlot({
    plot(impact())
  })

  output$report <- renderPrint({
    summary(impact(), 'report')
  })
})