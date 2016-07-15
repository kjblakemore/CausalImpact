library(shiny)
library(CausalImpact)
library(pageviews)

shinyServer(function(input, output) {
  impact <- eventReactive(input$submit, {

    # Log query to a csv file.
    #   Create csv file if it does not exist, writing header line.
    #   Entries consist of "current_time, pre_start, pre_end, post_start, post_end,
    #     y_article, x1_article, x2_article, x3_article"
    LOGFILE <- "causalimpact.csv"
    if(!file.exists(LOGFILE)) {
      file.create(LOGFILE)
      write("current_time, pre_start, pre_end, post_start, post_end, y, x1, x2, x3",
        file=LOGFILE, append=TRUE)
    }
    line <- sprintf("%s, %s, %s, %s, %s, %s, %s, %s, %s", Sys.time(), input$pre_period[1],
      input$pre_period[2], input$post_period[1], input$post_period[2],
      input$y_article, input$x1_article, input$x2_article, input$x3_article)
    write(line, file=LOGFILE, append=TRUE)

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

  output$summary <- renderPrint({
    summary(impact())
  })
})