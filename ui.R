require(rCharts)

shinyUI(
   pageWithSidebar(
      headerPanel("mtcars MPG~HP Linear Regression", windowTitle="mtcars MPG-HP Linear Regression"),
      
      sidebarPanel(
         
         p("This app is very simple to use. You can see the mtcars data already loaded. 
         The chart is plotting the miles per gallon of the cars against horsepower. 
         Adjust the two inputs to select a pair of coordinates, and then press 'Add Point'.
         Voila! You've just added a new point to the plot, and the linear regression line has been re-calculated.
           Way to go! You're so good at this!"),
         p(" "),
         numericInput("add_x", "Horsepower (X-value)", value=50, min=1, max=350, step=1),
         numericInput("add_y", "Miles/Gallon (Y-value)", value=25, min=1, max=350, step=1),
         actionButton("submit", "Add Point"),
         p("Equation of regression line:"),
         textOutput("equation")
      ),
      
      mainPanel(
         showOutput("kplot", "polycharts")
      )
   )
)