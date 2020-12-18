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


# Build mordel
model <- randomForest(play ~ ., data = weather, ntree = 500, mtry = 4, importance = TRUE)

# Save model to RDS file
# saveRDS(model, "model.rds")

# Read in the RF model
# model <- readRDS("model.rds")


###########################
##### User Interfrace #####
###########################


# Define UI for app

ui <- fluidPage(theme = shinytheme("united"),

    # Page header
    headerPanel('Play Golf?'),

    # Input values
    sidebarPanel(
        HTML("<h3>Input Parameters</h3>"),
        
        selectInput("outlook", label = "Outlook:",
                    choices = list("Sunny" = "sunny", "Overcast" = "overcast", "Rainy" = "rainy"),
                    selected = "Rainy"),
        sliderInput("temperature", "Temperature:",
                    min = 64, max = 86,
                    value = 70),
        sliderInput("humidity", "Humidity:",
                    min = 65, max = 96,
                    value = 90),
        selectInput("windy", label = "Windy:",
                    choices = list("Yes" = "TRUE", "No" = "FALSE"),
                    selected = "TRUE"),
        
        actionButton("submitbutton", "Submit", class = "btn btn-primary")
    ),

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
    datasetInput < reactive({
        
        # outlook, temp, humidity, wind, play
        df <- data.frame(
            Name = c("outlook",
                     "temperature",
                     "humidity",
                     "wind"),
            Value = as.character(c(input$outlook,
                                   input$temperature,
                                   input$humidity,
                                   input$wind)),
            stringsAsFactors = FALSE)
        
        play <- "play"
        df <- rbind(df, play)
        input <- transpose(df)
        write.table(input, "input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
        
        test <- read.csv(paste("input", ".csv", sep = ""), header = TRUE)
        
        test$outlook <- factor(test$outlook, levels = c("overcast", "rainy", "sunny"))
        
        
        Output <- data.frame(Prediction=predict(model, test), round(predict(model, test, type="prob"), 3))
        print(Output)
        
                             
    })
    
    # Status/Output Text Box
    output$contents <- renderPrint({
        if (input$submitbutton>0) {
            isolate("Calculation complete.")
        } else {
            return("Server is ready for calculation.")
        }
    })
    
    # Prediction results table
    output$tabledata <- renderTable({
        if (input$submitbutton>0) {
            isolate(datasetInput())
        }
    })
    
}


# Run the application 
shinyApp(ui = ui, server = server)
