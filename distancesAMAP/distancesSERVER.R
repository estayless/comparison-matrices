distanceAMAP<-reactive({
  distanceMeasure<-c("euclidean", "maximum", "manhattan", "canberra", "binary", "pearson", "abspearson", "correlation", "abscorrelation", "spearman","kendall")
  distanceName<-c("Euclidean", "Maximum", "Manhattan", "Canberra", "Binary", "Pearson", "Abspearson", "Correlation", "Abscorrelation", "Spearman","Kendall")
  names(distanceMeasure)<-distanceName
  distanceMeasure
})
observe({
  updateSelectInput(session=session, inputId="distanceAMAP", choices = distanceAMAP())
})

metaFunctions<-reactiveValues()

#DISTANCE AMAP CONVERSION
observe({
  
  metaFunctions$distAMAP<-function(df){
    
    distanceMethod<- input$distanceAMAP
    
    
    fnctnRtrn<-as.matrix(amap::Dist(df, method = distanceMethod))
    if(is.na(fnctnRtrn[1])){
      maxDist<-1
      return(maxDist)
    }
    else{
      return(fnctnRtrn)
    }
  }
  
})


observeEvent(input$computeAMAP,{
  req(rawMatrix$rm)
  ini<-Sys.time()
  results$AMAP<-distInsert(rawMatrix$rm, metaFunctions$distAMAP, "internalMatrixV2")
  print(Sys.time()-ini)
})

output$resultAMAP <- DT::renderDataTable({
  results$AMAP
})

output$downloadAMAP <- downloadHandler(
  filename = function() {
    paste("matrix-", Sys.Date(), ".txt", sep="")
  },
  content = function(file) {
    r<- as.data.frame(results$AMAP)
    r<- rownames_to_column(r,"vars")
    write.table(r, file, sep = "\t", dec = ".",
                row.names = FALSE, col.names = TRUE)
  }
)
