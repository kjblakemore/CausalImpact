## Web Application

This subdirectory contains a R Shiny web application to run causal impact analyses of external events on Wikipedia page views.

To execute the app, you will need to:
1. Install R  
2. Install [R Wikipedia Pageviews Client](https://github.com/Ironholds/pageviews)  
3. From an R session, install causal impact and shiny, then run the shiny app, with:  
```R
  > install.packages("devtools")
  > library(devtools)
  > devtools::install_github("google/CausalImpact")
  > library(CausalImpact)
  > library(shiny)
  > runApp(shinyapp)
```
4. 

Here is an example, showing how an appearance on Saturday Night Live caused Wikipedia page views to increase for the performer, Sia.

![screenshot](shinyapp.png)
