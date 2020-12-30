tabItem(
  tabName = "string",
  fluidRow(
    column(width = 3,
           box(
             title=span(icon("cogs"), "STRING settings"), width = NULL, status = "primary", solidHeader = TRUE,
             selectInput(inputId = "specieString", label = "Select a specie: ", choices = NULL),
             selectInput(inputId = "channel", label = "Select a channel: ", choices = NULL),
             actionButton("computeString","Compute", class = "btn-block primary"),
             tags$br(),
             downloadButton("downloadString", label = "Download", class = "btn-block"),
             tags$br(),
           ),
    ),
    
    column(width = 9,
           box(width = 9,
               title = span(icon("table"), "Score Matrix"),
               status = "primary",
               collapsible = TRUE, collapsed = FALSE,
               div(style = 'overflow-x: scroll', DT::dataTableOutput("resultString"))
           )
    )
  ),
  
)
