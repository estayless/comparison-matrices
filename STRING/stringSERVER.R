
#STRING SETTINGS
speciesString<-reactive({
  speciesDb<-c("9606")
  speciesNames<-c("Homo Sapiens")
  names(speciesDb)<-speciesNames
  speciesDb
})
observe({
  updateSelectInput(session=session, inputId="specieString", choices = speciesString())
})

channels<-reactive({
  channels<-c("combined_score", "neighborhood", "fusion", "cooccurence", "coexpression", "experimental", "database", "textmining")
  channelsNames<-c("Combined score", "Neighborhood", "Fusion", "Cooccurence", "Coexpression", "Experimental", "Database", "Textmining")
  names(channels)<-channelsNames
  channels
})
observe({
  updateSelectInput(session = session, inputId = "channel", choices = channels())
})


metaFunctionString<-reactiveValues()

set<-reactive({
  set<-specieConectionSettings(speciesString())
  set
})

infoCon<-reactive({
  infoCon<-collectionConection(set()[1], set()[2], set()[3], set()[4], set()[5])
})

linkCon<-reactive({
  linkCon<-collectionConection(set()[1], set()[2], set()[3], set()[4], set()[6])
})


#STRING FUNCTION CONVERTION
observe({
  req(input$channel)
  metaFunctions$getLink<-function(gene1, gene2){
    
    channel <- input$channel
    print(channel)
    
    fnctnRtrn<-getLink(gene1, gene2, infoCon(), linkCon())
    if(length(fnctnRtrn) == 0){
      score<-0
      return(score)
    }
    else{
      print(fnctnRtrn)
      access<-paste0("fnctnRtrn$",channel)
      return(eval(parse(text=access)))
    }
  }
})

observeEvent(input$computeString,{
  req(rawMatrix$rm)
  ini<-Sys.time()
  results$STRING<-distInsert(rawMatrix$rm, metaFunctions$getLink, "externalPairIdComp")
  print(results$STRING)
  print(Sys.time()-ini)
})

output$resultString <- DT::renderDataTable({
  results$STRING
})

output$downloadString <- downloadHandler(
  filename = function() {
    paste("stringMatrix-", Sys.Date(), ".txt", sep="")
  },
  content = function(file) {
    r<- as.data.frame(results$STRING)
    r<- rownames_to_column(r,"vars")
    write.table(r, file, sep = "\t", dec = ".",
                row.names = FALSE, col.names = TRUE)
  }
)