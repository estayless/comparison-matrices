tabItem(tabName = "mocgapbk",
        fluidRow(
          column(width = 3,
                 
                 box(
                   title=span(icon("table"), "Available data"), width = NULL, status = "primary", solidHeader = TRUE,

                   selectInput(
                     inputId = "matrix1",
                     label = "Select the first Matrix from the font.", 
                     choices = NULL
                   ),
                   
                   selectInput(
                     inputId = "matrix2",
                     label = "Select the second Matrix from the font.", 
                     choices = NULL
                   ),
                   
                   hr(),
                   actionButton(inputId = "computeMOCGAPBK", label = "Compute", class = "btn-block"),
                 ),
                 
                 box(
                   title=span(icon("chart"), "MOC-GaPBK Solutions"), width = NULL, status = "primary", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
                   plotOutput("solutions", click = "solutions_click",  brush = brushOpts(id = "solutions_brush")),
                   verbatimTextOutput("click_info"),
                 ),
                 
                 box(
                   title=span(icon("cogs"), "MOC-GaPBK settings"), width = NULL, status = "primary", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
                   sliderInput(inputId = "num_k", label = "Number of groups", min = 1, max = 100, value = 5, step = 1),
                   sliderInput(inputId = "generation", label = "Number of generations", min = 1, max = 1000, value = 50, step = 1),
                   sliderInput(inputId = "pop_size", label = "Size of population", min = 1, max = 1000, value = 10, step = 1),
                   sliderInput(inputId = "rat_crossover", label = "Probability of crossover", min = 0, max = 1, value = 0.80, step = 0.01),
                   sliderInput(inputId = "rat_mutation", label = "Probability of mutation", min = 0, max = 1, value = 0.01, step = 0.01),
                   sliderInput(inputId = "tour_size", label = "Size of tournaments", min = 1, max = 10, value = 2, step = 1),
                   sliderInput(inputId = "neighborhood", label = "Percentage of neighborhood", min = 0, max = 1, value = 0.10, step = 0.01),
                   hr(),
                   materialSwitch(inputId = "local_search",
                                  label = tags$b("Compute local searches procedures"),
                                  value = FALSE,
                                  status = "primary"),
                   hr(),
                   materialSwitch(inputId = "relatedVariable",
                                  label = tags$b("Are the variables continuously related?"),
                                  value = FALSE,
                                  status = "primary"),
                   
                 )
  
          ),
          column(width = 9,
                 box(height = 1200,
                   title=span(icon("cogs"), "Eisen plot and Cluster profile plot"), width = NULL, status = "primary", solidHeader = TRUE,
                   plotOutput("completePlot")
                 )
            
          )
        )
)
