tabItem(
  tabName = "distanceAMAP",
  fluidRow(
    column(width = 3,
           box(
             title=span(icon("cogs"), "Distances settings"), width = NULL, status = "primary", solidHeader = TRUE,
             #Selec input for distances
             selectInput(inputId = "distanceAMAP", label = "Select a distance measure: ", choices = NULL),
             actionButton("computeAMAP","Compute", class = "btn-block primary"),
             tags$br(),
             downloadButton("downloadAMAP", label = "Download", class = "btn-block"),
             tags$br(),
                
           ),
           
    ),
    column(width = 9,
           box(width = 12,
               title = span(icon("table"), "Distance Matrix"),
               status = "primary",
               collapsible = TRUE, collapsed = FALSE,
               div(style = 'overflow-x: scroll', DT::dataTableOutput("resultAMAP"))
           )
    )
  ),
)
