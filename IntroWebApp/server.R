# Server code.

# This is where the computations and statistical analyses
#will be.

# This will generate the histogram.

library(shiny)


shinyServer(
    function(input, output, session){
        
        output$myPlot <- renderPlot({
            
            distType <- input$Distribution
            size <- input$sampleSize
            
            if(distType == 'Normal'){# If the distribution is Normal, the random vector will include the normal values.
                
                randomVec <- rnorm(size, mean = as.numeric(input$mean),
                                   # But the mean just gets the text file, so we need to cast this text in numerical values.
                                   # So the 'as.numeric', takes care of this casting.
                                   # IOW the mean will be the numerical value of 'input$mean'.
                                   sd = as.numeric(input$sd))
                # Same thing applied to mean above.
            } # 'rnorm' generates random numbers out of the normal distribution.
            
            
            else {# Else, the case is that the distribution type is Exponential.
                
                randomVec <- rexp(size, rate = 1 / as.numeric(input$Lambda))
                # 'rexp' generates random numbers out of the exponential distribution.
            }
            
            hist(randomVec, col = 'grey')
        })
    }
)

#deployApp()