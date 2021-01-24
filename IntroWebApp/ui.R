# User Interface code.

library(shiny)
#library(devtools)
#library(shinyapps)
library(rsconnect)



#setwd("C:\Users\maullonv\Documents\001FirstApp\anotherIntroApp")

shinyServer(
    pageWithSidebar(
        headerPanel("An Intro Shiny App"),
        
        sidebarPanel(
            selectInput("Distribution", "Please Select Distribution Type", 
                        # The text I want to show to the user.
                        choices = c("Normal", "Exponential")),
            sliderInput ("sampleSize", "Please Select Sample Size: ",
                         min = 100, max = 5000, value = 1000, step = 100),
            
            # Will use conditional panels below to add / change the number of parameters
            #for Normal distribution and Exponential distribution.
            # We aim for the normal distribution to have two parameters (1. mean, 2. SD).
            # We aim for the exponential distribution to have one parameter (1. lambda).
            # IOW we want the user to have different options for Normal and Exponential distribution.
            # This will be handled using the conditional panels below.
            conditionalPanel(condition = "input.Distribution == 'Normal'",
                             textInput("mean", "Please Select the mean",  10),
                             # If my input.Distribution is Normal, the name of the textInput would be '... Mean'
                             textInput("sd", "Please Select the Standard Deviation", 3)),
            # "..." and '... Standard Deviation'.
            # Also note the default values that should appear (10, 3).
            
            conditionalPanel(condition = "input.Distribution == 'Exponential'",
                             textInput("Lambda", "Please Select the Exponential Lambda", 1))
            # If my input.Distribution is Exponential, the name of the textInput would be '... Exponential Lambda'.
            # IOW if this condition is true the textInput specified above should appear.
        ),
        
        # IOW if this condition is true the textInput specified above should appear.
        
        mainPanel(
            plotOutput("myPlot")
        )
    ))



