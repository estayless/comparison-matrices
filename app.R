library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(shinydashboardPlus)
library(DT)
library(tibble)
library(arrangements)
library(parallel)
library(mongolite)
library(GOSemSim)
library(org.Hs.eg.db)
library(moc.gapbk)
library(dplyr)
library(GGally)
library(hrbrthemes)
library(gridExtra)
library(ComplexHeatmap)
library(circlize)
library(RColorBrewer)
library(ggplotify)
library(ggpubr)

source("distInsert.R")
source("STRING/specieConectionSettings.R")
source("STRING/collectionConection.R")
source("STRING/getLink.R")
source("MOC-GaPBK/completePlot.R")
source("MOC-GaPBK/clusterProfilePlot.R")

header <- dashboardHeader(
  title = span(tagList(icon("ruler"),icon("th"), "Comparison Matrices")),
  titleWidth = 350
)

sidebar <- dashboardSidebar(
  width = 350,
  fluidRow(
    column(width = 10, offset = 1,
           #VARIABLES DROPDOWN
           sidebarMenu(
             hr(style="height:3px;border-width:0;color:#367fa9;background-color:#367fa9"),
             tags$h4("Upload a file"),
             #UPLOAD
             menuItem("Upload file", tabName = "upload",icon = icon("upload")),
             hr(style="height:3px;border-width:0;color:#367fa9;background-color:#367fa9"),
             tags$h4("Search by variable type"),
             #CUALITATIVE
             tags$h5("Cualitative"),
             menuItem("Nominal" , tabName = "nominal", icon = icon("align-center", lib = "glyphicon")
             ),
             menuItem("Ordinal" , tabName = "ordinal", icon = icon("sort-by-attributes", lib = "glyphicon"),
                      menuSubItem("Similarity by GO", tabName = "go"),
                      menuSubItem("Scores by STRING", tabName = "string")
             ),
             ##############
             
             #CUANTITATIVE
             tags$h5("Cuantitative"),
             
             menuItem("Continuous" , tabName = "continuous", icon = icon("area-chart", lib = "font-awesome"),
                      menuSubItem("Distances by AMAP", tabName = "distanceAMAP")
             ),
             menuItem("Discrete" , tabName = "discrete", icon = icon("bar-chart-o", lib = "font-awesome")
             ),
             ##############
             
             hr(style="height:3px;border-width:0;color:#367fa9;background-color:#367fa9"),
             
             #ALGORITHMS
             tags$h5("Clustering"),
             menuItem(tags$p(icon("circle-notch", lib = "font-awesome"),"Diffuse multi-objective gene algorithm" , tags$br(), "by MOC-GaPBK"), tabName = "mocgapbk"
             )
             
           )
    )
  )
)
body <- dashboardBody(
  tabItems(
    source(file.path("uploadFile", "uploadUI.R"),  local = TRUE)$value,
    #CUALITATIVE################
    #NOMINAL
    #GO
    source(file.path("GO", "goUI.R"),  local = TRUE)$value,
    #STRING
    ############################
    source(file.path("STRING", "stringUI.R"),  local = TRUE)$value,
    #ORDINAL####################
    
    #CUANTITATIVE###############
    #CONTINUOUS
    #DISTANCE AMAP
    source(file.path("distancesAMAP", "distancesUI.R"),  local = TRUE)$value,
    #DISCRETE
    ############################
    
    #CLUSTERING#################
    source(file.path("MOC-GaPBK", "MOC-GaPBK-UI.R"),  local = TRUE)$value
  )
)
ui <- dashboardPage(header, sidebar, body)

server <- function(input, output, session) {
  
  rawMatrix<-reactiveValues()
  results<-reactiveValues()
  
  #FILE
  source(file.path("uploadFile", "uploadSERVER.R"),  local = TRUE)$value

  #CUALITATIVE################
  ##NOMINAL
  ###GO
  source(file.path("GO", "goSERVER.R"),  local = TRUE)$value
  ####STRING
  source(file.path("STRING", "stringSERVER.R"),  local = TRUE)$value
  
  ##ORDINAL
  ############################
  
  #CUANTITATIVE###############
  #CONTINUOUS
  ##DISTANCE BY AMAP
  source(file.path("distancesAMAP", "distancesSERVER.R"),  local = TRUE)$value
  #DISCRETE
  ############################
  
  #CLUSTERING#################
  source(file.path("MOC-GaPBK", "MOC-GaPBK-SERVER.R"),  local = TRUE)$value
    
  observe({
    clusterSol()
    clusterSolObj()
    selectedSolObj()
  })
  
  resultsList<-reactive({
    resultsList <- reactiveValuesToList(results)
    return(names(resultsList))
    
  })
  
  observe({
    req(resultsList())
    updateSelectInput(session=session, inputId="matrix1", choices = resultsList())
    updateSelectInput(session=session, inputId="matrix2", choices = resultsList())
  })
  
}

shinyApp(ui, server)

