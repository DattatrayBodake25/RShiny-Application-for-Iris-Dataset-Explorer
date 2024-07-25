# Install necessary packages if not already installed
if (!require(shiny)) install.packages("shiny", dependencies=TRUE)
if (!require(ggplot2)) install.packages("ggplot2", dependencies=TRUE)
if (!require(DT)) install.packages("DT", dependencies=TRUE)
if (!require(dplyr)) install.packages("dplyr", dependencies=TRUE)
if (!require(GGally)) install.packages("GGally", dependencies=TRUE)
if (!require(plotly)) install.packages("plotly", dependencies=TRUE)
if (!require(shinythemes)) install.packages("shinythemes", dependencies=TRUE)

# Load necessary libraries
library(shiny)
library(ggplot2)
library(DT)
library(dplyr)
library(GGally)
library(plotly)
library(shinythemes)

# Load the iris dataset
data("iris")

# Define UI for application
ui <- fluidPage(
  theme = shinytheme("cerulean"),  # Apply a theme to the UI
  titlePanel("Iris Dataset Explorer"),  # Application title
  sidebarLayout(
    sidebarPanel(
      h4("Filters"),  # Sidebar title
      p("Use the filters and selections below to explore the Iris dataset."),  # Sidebar description
      
      # Species filter
      checkboxGroupInput("species", "Species:", 
                         choices = unique(iris$Species),
                         selected = unique(iris$Species)),
      
      # X-axis selection for plots
      selectInput("xvar", "X-axis variable:", 
                  choices = names(iris)[1:4], 
                  selected = "Sepal.Length"),
      
      # Y-axis selection for plots
      selectInput("yvar", "Y-axis variable:", 
                  choices = names(iris)[1:4], 
                  selected = "Sepal.Width"),
      
      # Z-axis selection for 3D plot
      selectInput("zvar", "Z-axis variable (for 3D Plot):", 
                  choices = names(iris)[1:4], 
                  selected = "Petal.Length"),
      
      # Slider for Sepal Length
      sliderInput("sepal_length", "Sepal Length:",
                  min = min(iris$Sepal.Length), max = max(iris$Sepal.Length), 
                  value = c(min(iris$Sepal.Length), max(iris$Sepal.Length))),
      
      # Slider for Sepal Width
      sliderInput("sepal_width", "Sepal Width:",
                  min = min(iris$Sepal.Width), max = max(iris$Sepal.Width), 
                  value = c(min(iris$Sepal.Width), max(iris$Sepal.Width))),
      
      # Slider for Petal Length
      sliderInput("petal_length", "Petal Length:",
                  min = min(iris$Petal.Length), max = max(iris$Petal.Length), 
                  value = c(min(iris$Petal.Length), max(iris$Petal.Length))),
      
      # Slider for Petal Width
      sliderInput("petal_width", "Petal Width:",
                  min = min(iris$Petal.Width), max = max(iris$Petal.Width), 
                  value = c(min(iris$Petal.Width), max(iris$Petal.Width)))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Instructions", 
                 h4("How to use the Iris Dataset Explorer"),
                 p("This application allows you to explore the famous Iris dataset. Use the filters on the left panel to subset the data by species, sepal length, sepal width, petal length, and petal width."),
                 p("You can choose different variables for the x-axis and y-axis of the scatter plot and box plot using the dropdown menus."),
                 p("The filtered data is displayed in a table, and various visualizations are generated based on your selections.")),
        
        # Tab for displaying the filtered dataset
        tabPanel("Table", DT::dataTableOutput("irisTable")),
        
        # Tab for scatter plot
        tabPanel("Scatter Plot", plotOutput("scatterPlot", height = "600px")),
        
        # Tab for histogram
        tabPanel("Histogram", plotOutput("histPlot", height = "600px")),
        
        # Tab for box plot
        tabPanel("Box Plot", plotOutput("boxPlot", height = "600px")),
        
        # Tab for pair plot
        tabPanel("Pair Plot", plotOutput("pairPlot", height = "800px")),
        
        # Tab for summary statistics
        tabPanel("Summary Statistics", tableOutput("summaryStats")),
        
        # Tab for 3D scatter plot
        tabPanel("3D Scatter Plot", plotlyOutput("scatter3dPlot", height = "600px"))
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  # Reactive expression to filter the dataset based on user inputs
  filteredData <- reactive({
    iris %>%
      filter(Species %in% input$species,
             Sepal.Length >= input$sepal_length[1], Sepal.Length <= input$sepal_length[2],
             Sepal.Width >= input$sepal_width[1], Sepal.Width <= input$sepal_width[2],
             Petal.Length >= input$petal_length[1], Petal.Length <= input$petal_length[2],
             Petal.Width >= input$petal_width[1], Petal.Width <= input$petal_width[2])
  })
  
  # Output the filtered dataset as a table
  output$irisTable <- DT::renderDataTable({
    DT::datatable(filteredData())
  })
  
  # Output scatter plot
  output$scatterPlot <- renderPlot({
    ggplot(filteredData(), aes_string(x = input$xvar, y = input$yvar, color = "Species")) +
      geom_point(size = 3) +
      labs(title = paste("Scatter Plot of", input$yvar, "vs", input$xvar),
           x = input$xvar, y = input$yvar, color = "Species") +
      theme_minimal()
  })
  
  # Output histogram
  output$histPlot <- renderPlot({
    ggplot(filteredData(), aes_string(x = input$xvar, fill = "Species")) +
      geom_histogram(binwidth = 0.5, position = "dodge") +
      labs(title = paste("Histogram of", input$xvar),
           x = input$xvar, fill = "Species") +
      theme_minimal()
  })
  
  # Output box plot
  output$boxPlot <- renderPlot({
    ggplot(filteredData(), aes_string(x = "Species", y = input$yvar, fill = "Species")) +
      geom_boxplot() +
      labs(title = paste("Box Plot of", input$yvar, "by Species"),
           y = input$yvar, fill = "Species") +
      theme_minimal()
  })
  
  # Output pair plot
  output$pairPlot <- renderPlot({
    ggpairs(filteredData(), aes(color = Species)) +
      labs(title = "Pair Plot of Iris Dataset") +
      theme_minimal()
  })
  
  # Output summary statistics
  output$summaryStats <- renderTable({
    summary(filteredData())
  })
  
  # Output 3D scatter plot
  output$scatter3dPlot <- renderPlotly({
    plot_ly(filteredData(), x = ~get(input$xvar), y = ~get(input$yvar), z = ~get(input$zvar), 
            color = ~Species, colors = c("#FF4136", "#2ECC40", "#0074D9")) %>%
      add_markers() %>%
      layout(scene = list(xaxis = list(title = input$xvar),
                          yaxis = list(title = input$yvar),
                          zaxis = list(title = input$zvar),
                          title = paste("3D Scatter Plot of", input$yvar, "vs", input$xvar, "vs", input$zvar)))
  })
}

# Run the application
shinyApp(ui = ui, server = server)
