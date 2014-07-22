require(rCharts)

# Load the data upon starting the app.
data(mtcars)
assign("dataset", mtcars[,c(4,1)], envir=.GlobalEnv)
assign("fit", lm(dataset$mpg ~ dataset$hp), envir=.GlobalEnv)
assign("dataset", cbind(dataset, fit=fit$fitted.values), envir=.GlobalEnv)

shinyServer(     
   function(input, output, session) {
      
      # Add point when submit button is clicked.
      data = reactive({
         if(input$submit > 0) {
            # Create dependency on submit button.
            input$submit
            
            # Add point to dataset.
            assign("dataset", rbind(dataset[,1:2], isolate(c(input$add_x, input$add_y))), envir=.GlobalEnv)
            
            # Re-fit data.
            assign("fit", lm(dataset$mpg ~ dataset$hp), envir=.GlobalEnv)
            assign("dataset", cbind(dataset, fit=fit$fitted.values), envir=.GlobalEnv)
            
            return(dataset)
         }
         else { return(dataset) }
      })     
      
      output$kplot = renderChart({    
         dataset = data()
         
         # Calculate graph minimums and maximums
         xmin = max(min(dataset$hp) - 10, 0) # Cut threshold at zero.
         xmax = (max(dataset$hp) + 11) + (50 - ((max(dataset$hp) + 10) %% 50))
         ymin = 0
         ymax = (max(dataset$mpg) + 1) + (5 - ((max(dataset$mpg) + 5) %% 5))
         
         p = rPlot(mpg ~ hp, data=dataset, type="point")
         p$addParams(dom="kplot")
         p$layer(y="fit", copy_layer=T, type="line", color=list(const="red"), data=dataset)
         p$guides(
            x = list(
               min = xmin,
               max = xmax,
               numticks = xmax / 50 + 1,
               title = "HP"
            ),
            y = list(
               min = ymin,
               max = ymax,
               numticks = ymax / 5 + 1,
               title = "MPG"
            )
         )
         return(p)
      })
      
      output$equation = renderText({
         input$submit
         paste(sprintf("y = %fx + %f", fit$coefficients[2], fit$coefficients[1]))
      })
})