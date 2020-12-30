rawMatrix<-reactiveValues()

rawFile <- reactive({
  req(input$file)
  tryCatch(
    {
      df <- read.delim(input$file$datapath,
                       header = input$header,
                       sep = input$sep,
                       quote = input$quote,
                       fill = TRUE)
    },
    error = function(e) {
      stop(safeError(e))
    }
  )
  
  if(input$lateral==TRUE){
    rownames(df)<-df[,1]
    df[,1]<-NULL
  }else{
    rownames(df)<-c(1:length(rownames(df)))
  }
  
  if(input$header==FALSE){
    colnames(df)<-c(1:length(colnames(df)))
  }
  df
})

dfToMatrix<-observe({
  rawMatrix$rm <- rawFile()
})

rowOrColumn<-observeEvent(input$axis,{
  req(input$axis, rawMatrix$rm)
  rawMatrix$rm <- t(rawMatrix$rm)
})

output$file <- DT::renderDataTable({
  rawMatrix$rm
})