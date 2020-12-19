#####################################

# Building a ML / Data-Driven       # 
#Web Application in R               #

# This will make use of the random  #
#forest algorithm. It aims to       #
#predict whether or not to play     #
#golf as a function of the input    #
#weather parameters.                #

# Check out uploaded pdf for more   #
#info:                              #


# Used this as reference: http://youtube.com/dataprofessor #

#####################################

library(shiny)
library(shinythemes)
library(data.table)
library(RCurl)
library(randomForest)


# Read the data
weather <- read.csv(text = getURL("https://raw.githubusercontent.com/dataprofessor/data/master/weather-weka.csv"))


# Build mordel to make a prediction
model <- randomForest(play ~ ., data = weather, ntree = 500, mtry = 4, importance = TRUE)

# Save model to RDS file
# saveRDS(model, "model.rds")

# Read in the RF model
# model <- readRDS("model.rds")


###########################
##### User Interfrace #####
###########################


# Define UI for app

ui <- fluidPage(theme = shinytheme("superhero"),

    # Page header
    headerPanel('Play Golf?'),

    # Input values
    sidebarPanel(
        HTML("<h3>Input Parameters</h3>"),
        
        selectInput("outlook", label = "Outlook:",
                    choices = list("Sunny" = "sunny", "Overcast" = "overcast", "Rainy" = "rainy"),
                    selected = "Rainy"),
        # recall: "selected" is the default value that appears on app
        # "Outlook" is one of the four variables, with 3 choices (sunny, overcast, rainy)
        # "selectInput" is a drop down menu
        # the "label" argument is not really needed
        sliderInput("temperature", "Temperature:",
                    min = 64, max = 86,
                    value = 70),
        # "Temp" is another variable
        sliderInput("humidity", "Humidity:",
                    min = 65, max = 96,
                    value = 90),
        # "Humidity" is another variable
        selectInput("windy", label = "Windy:",
                    choices = list("Yes" = "TRUE", "No" = "FALSE"),
                    selected = "TRUE"),
        # "Windy" is another variable
        
        # keep note of all 4 of these variables, as will be used in server fcn
        # respectively, each will be referred to as input$...
        #around lines 107-110
        
        actionButton("submitbutton", "Submit", class = "btn btn-primary")
    ), # when ready to make a prediction, click on "Submit" button
       # this submit button is added in order to overcome the reactive fcn
       #so, instead of a spontaneous result/ prediction, a prediction won't
       #be made until the user clicks on "Submit" button
    mainPanel(
        tags$label(h3('Status/Output')), # Status/Output Text Box
        verbatimTextOutput('contents'),
        tableOutput('tabledata') # Prediction results table
    )
 ) 


##################
##### Server #####
##################

# Define server the logic

server <- function(input, output, session) {
    
    # Input data
    datasetInput <- reactive({
        
        # outlook, temp, humidity, wind, play
        df <- data.frame(
            Name = c("outlook",
                     "temperature",
                     "humidity",
                     "windy"),
            Value = as.character(c(input$outlook,
                                   input$temperature,
                                   input$humidity,
                                   input$windy)),
            stringsAsFactors = FALSE)
        
        play <- "play"
        df <- rbind(df, play)
        input <- transpose(df)
        write.table(input, "input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
        
        test <- read.csv(paste("input", ".csv", sep = ""), header = TRUE)
        # to test & see, will apply model to input file
        # will put the data into this variable, "test"
        
        test$outlook <- factor(test$outlook, levels = c("overcast", "rainy", "sunny"))
        # will use above lines of code to test if it is working properly
        # will assign the factor/ variable "outlook"
        # the input file only has "sunny" as a choice, so add the three above
        
        Output <- data.frame(Prediction=predict(model, test), round(predict(model, test, type="prob"), 3))
        print(Output)
        
                             
    })
    
    # Status/Output Text Box
    output$contents <- renderPrint({
        if (input$submitbutton > 0) {
            isolate("Calculation complete.")
        } else {
            return("Server is ready for calculation.")
        }
    })
    
    # Prediction results table
    output$tabledata <- renderTable({
        if (input$submitbutton > 0) {
            isolate(datasetInput())
        }
    })
    
}


# Run the application 
shinyApp(ui = ui, server = server)
