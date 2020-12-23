#####################################

# Building an Interactive Histogram #
# for Air Quality Data Set          #

# Particularly the Ozone Levels     #


# Used this as reference: http://youtube.com/dataprofessor #

#####################################

library(shiny)
# will be using the air quality data set
data(airquality)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Ozone level"),

    # Sidebar with input and output definitions
    
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            # Input: Slider for the number of bins ----
            sliderInput(inputId = "bins",
                        # "bins" is what the server output will recognize
                        label = "Number of bins:",
                        min = 0,
                        max = 50,
                        value = 30,
                        step = 1)
            # the default value is 30
            # notice: the step size is 1
                # to modify it, use "step"
            
        ),

        # Show a plot of the generated distribution;
        # Main panel for displaying outputs ----
        mainPanel(
            
            
            # output: Histogram ----
           plotOutput(outputId = "distPlot")
           
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    
    
    
    output$distPlot <- renderPlot({
        # this will generate an output called "distPlot"
        # notice b/c on line #48 outputId is "distPlot"
        # So, the server will output this obj called "distPlot"
        #and send it to the UI component for display on the main panel
        
        
        
        x <- airquality$Ozone
        # from airquality dataset and use "$" to specify the column
        # call it "Ozone"
        x <- na.omit(x)
        # this code above, omits the missing values within the col
        #"Ozone"
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        # the "bins" variable determines what is the min value of 
        #the bin and what is the max value of the bin

        
        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = "#75AADB", border = 'black',
             xlab = "Ozone level",
             main = "Histogram of Ozone level")
        
        # the "hist" (histogram fcn) has "x" which is the input data
        #which is the airqulity dataset; specifically data in the 
        # "Ozone" column, omitting the NA vals
        # the colour of the hist is blue
        
        
    })
    
    
}

# Create Shiny App
shinyApp(ui = ui, server = server)
# So, this "shinyApp" function will fuse together the
#UI component and server component
# So, the code communicates between the UI and the Server
# UI = accepts input, which is the # of bins and it will send
#the # of bins to the server component and
#server = will generate the histogram plot and the histogram plot
#will be contained within this output; this plot and it will
#be sent to the plot output fcn in the main panel of the UI 
#thus, the generation of the histogram
# On the app, we can see that adjusting the sidepanel bar corresponds
#to histogram changing in terms of the # of bins that appear
