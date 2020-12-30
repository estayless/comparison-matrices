tabItem(
  tabName = "go",
  fluidRow(
    column(width = 3,
           box(
             title=span(icon("cogs"), "Gene Ontology settings"), width = NULL, status = "primary", solidHeader = TRUE,
             #Selec input for specie
             selectInput(inputId = "specie", label = "Select a specie: ", choices = NULL),
             
             #select input for ontology
             selectInput(inputId = "ontology", label = "Select an ontology: ", choices = NULL),
             
             #select input for type of semantic similarity
             selectInput(inputId = "similarity", label = "Select a similarity method:", choices = NULL),
             
             #select input for type of combine methods
             selectInput(inputId = "combine", label = "Select a combine method:", choices = NULL),
             
             materialSwitch(inputId = "as_distancy",
                            label = tags$b("Transform values to a distancy?"),
                            value = FALSE,
                            status = "primary"),
             
             actionButton("compute","Compute", class = "btn-block primary"),
             tags$br(),
             downloadButton("download", label = "Download", class = "btn-block"),
             tags$br(),
             
           ),
    ),
    column(width = 9,
           box(width = 12,
               title = span(icon("table"), "Similarity Matrix"),
               status = "primary",
               collapsible = TRUE, collapsed = FALSE,
               div(style = 'overflow-x: scroll', DT::dataTableOutput("result"))
           )
    )
  ),
  
)
