tabItem(
  tabName = "upload",
  fluidRow(
    column(width = 3,
           box(
             title=span(icon("cogs"), "Upload settings"), width = NULL, status = "primary", solidHeader = TRUE,
             
             
             tags$h3("Upload settings"),
             #UPLOAD one, other, both, none
             
             # Input: Select a file ----
             fileInput("file", "Choose a File",
                       multiple = FALSE,
                       accept = c("text/csv",
                                  "text/comma-separated-values,text/plain",
                                  ".csv")),
             
             hr(style="height:2px;border-width:0;color:gray;background-color:gray"),
             fluidRow(
               column(width = 12,
                      p(strong("Variables on:"), style="margin-left:5%")
               ),
               
               column(width = 6,
                      #p("Header"),
                      # Input: Checkbox if file has header ----
                      materialSwitch(inputId = "header",
                                     label = "Header",
                                     value = TRUE,
                                     #right = TRUE,
                                     status = "primary")
               ),
               column(width = 6,
                      #p("Lateral"),
                      materialSwitch(inputId = "lateral",
                                     label = "Lateral",
                                     value = TRUE,
                                     #right = TRUE,
                                     status = "primary")
               )
             ),
             hr(style="height:2px;border-width:0;color:gray;background-color:gray"),
             fluidRow(
               column(width = 6,
                      # Input: Select separator ----
                      prettyRadioButtons(inputId = "sep",
                                         label = "Separator:",
                                         choices = c(Comma = ",",
                                                     Semicolon = ";",
                                                     Tab = "\t"),
                                         selected = ",",
                                         status = "primary",
                                         fill = TRUE),
               ),
               
               column(width = 6,
                      # Input: Select quotes ----
                      prettyRadioButtons(inputId = "quote",
                                         label = "Quote:",
                                         choices = c(None = "",
                                                     "Double Quote" = '"',
                                                     "Single Quote" = "'"),
                                         selected = '"',
                                         status = "primary",
                                         fill = TRUE)
               )
             ),
             
             # Input: Select separator ----
             prettyRadioButtons(inputId = "axis",
                                label = "Correlation betwen variables of:",
                                choices = c(Header = "header", 
                                            Lateral = "lateral"),
                                selected = "lateral",
                                status = "primary",
                                fill = TRUE),
           ),
    ),
    
    column(width = 9,
           box(width = 9,
               title = span(icon("table"), "File content"),
               status = "primary",
               collapsible = TRUE, collapsed = FALSE,
               div(style = 'overflow-x: scroll', DT::dataTableOutput("file"))
           )
    )
  ),
)
