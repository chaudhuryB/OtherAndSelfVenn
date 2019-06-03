#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


#install.packages('VennDiagram')
#install.packages("shinyjs")

library(shiny)
library(shinyjs)
library(VennDiagram)

# Global initial random variable for initialising overlap
rn <- sample(1:100, 1)

# Define UI for application that draws the slider
ui <- fluidPage(
   useShinyjs(),  # Set up shinyjs
   # Application title
   titlePanel("How much do you have in common"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("overlap",
                     "% overlap you & other:",
                     min = 0,
                     max = 100,
                     value = rn), # overlap range 0-100% with random initial value
         
         # Hidden input to submit initial value back to server
         hidden(
                textInput("initial_value",
                          "initial value",
                          value=rn)),
              
         actionButton("record_values", "Submit")
      ),
      
      # Show a Venn diagram of the overlap
      mainPanel(
         plotOutput("vennPlot"),
         width = 4
      )
   )
)

# Define server logic required to draw the venn diagram
server <- function(input, output) {
  
   # draw the venn diagram taking the slider value as the overlap
   output$vennPlot <- renderPlot({
                        draw.pairwise.venn(100, 100, # Both are 100 %
                                         cross.area=input$overlap,     # Overlap form slider
                                         category = c("You", "Other"), 
                                         lty = rep("blank", 2),
                                         fill = c("light blue", "green"), # Colours
                                         alpha = rep(0.5, 2),   # Transparency setting in the overlap drawing
                                         cat.pos = c(325, 45),  # Position of the category labels
                                         cat.dist = rep(0.025, 2)) # Distanace of the labels
   })
   
   # If submit button is clicked
   observeEvent(input$record_values, {
     # Return the overlap and initialising values and stop the app
     return_list <- list( "overlap_value" = input$overlap, 
                          "initial_value" = input$initial_value)
     stopApp(return_list)
     })
}

# Run the application 
shinyApp(ui = ui, server = server)

