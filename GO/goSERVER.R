
#GENE ONTOLOGY SETTINGS
species<-reactive({
  speciesDb<-c("org.Hs.eg.db")
  speciesNames<-c("Human")
  names(speciesDb)<-speciesNames
  speciesDb
})
observe({
  updateSelectInput(session=session, inputId="specie", choices = species())
})

#selec an ontology server functions
ontologys<-reactive({
  ontology<-c("CC","BP","MF")
  ontologyNames<-c("Cellular component", "Biological process", "Molecular function")
  names(ontology)<-ontologyNames
  ontology
})
observe({
  updateSelectInput(session = session, inputId = "ontology", choices = ontologys())
})

#Database connection
dbCon<-reactive({
  showModal(modalDialog("Generating data", footer=NULL))
  semData<-godata(input$specie, keytype = "SYMBOL", ont = input$ontology)
  removeModal()
  semData
})

similarities<-reactive({
  sim <- c("Resnik", "Lin", "Rel", "Jiang", "Wang")
  names(sim)<-sim
})
observe({
  updateSelectInput(session = session, inputId = "similarity", choices = similarities())
})

combineM<-reactive({
  com <- c("max", "avg", "rcmax", "BMA")
  names(com)<-com
})
observe({
  updateSelectInput(session = session, inputId = "combine", choices = combineM())
})

metaFunctions<-reactiveValues()

#GENE ONTOLOGY FUNCTION CONVERTION
observe({
  
  metaFunctions$parMgeneSim<-function(genes){

    semData=dbCon()
    measure=input$similarity
    combine=input$combine
    drop = "IEA"
    
    gene2GO <- function(gene, godata, dropCodes) {
      goAnno <- godata@geneAnno
      if (! "EVIDENCE" %in% colnames(goAnno)) {
        warning("Evidence codes not found, 'drop' parameter will be ignored...")
      } else {
        goAnno <- goAnno[!goAnno$EVIDENCE %in% dropCodes,]
      }
      go <- as.character(unique(goAnno[goAnno[,1] == gene, "GO"]))
      go[!is.na(go)]
    }
    
    combineScoresWrapper<-function(id){
      i<-combis[id,1]
      j<-combis[id,2]
      s<-combineScores(go_matrix[gos[[i]], gos[[j]]], combine = combine)
      return(c(i,j,s))
    }
    
    combineScoresLapply<-function(id){
      lapply(id,combineScoresWrapper)
    }
    #parMgeneSim
    parMgeneSim<-function(cl, genes, semData, measure = "Wang", drop = "IEA", combine = "BMA"){
      genes <- unique(as.character(genes))
      n <- length(genes)
      showModal(modalDialog("Generating combinations", footer=NULL))
      combis<-combinations(n,2,replace=TRUE)
      removeModal()
      showModal(modalDialog("Obtaining GO data", footer=NULL))
      gos <- lapply(genes, gene2GO, godata = semData, dropCodes = drop)
      uniqueGO <- unique(unlist(gos))
      go_matrix <- mgoSim(uniqueGO, uniqueGO, semData, measure = measure, combine = NULL)
      removeModal()
      showModal(modalDialog("Exporting objects to cluster", footer=NULL))
      clusterExport(cl = cl, varlist = c("go_matrix", "gos", "combine","combis"), envir = environment())
      chunks<-splitIndices(nrow(combis),4)
      removeModal()
      showModal(modalDialog("Calculating", footer=NULL))
      ca<-clusterApply(cl, chunks, combineScoresLapply)
      removeModal()
      showModal(modalDialog("Formating", footer=NULL))
      mat<-t(matrix(unlist(ca), nrow= 3))
      scores<<-matrix(data=NA, ncol = n, nrow = n)
      rownames(scores) <- genes
      colnames(scores) <- genes
      mapply(function(i,j,s,scores){scores[i,j]<<-s}, i=mat[,1],j=mat[,2],s=mat[,3], MoreArgs = list(scores))
      scores[lower.tri(scores)] <- t(scores)[lower.tri(scores)]
      insert0<-function(scores){
        scores[is.na(scores)]<<-0
      }
      insert0(scores)
      removeModal()
      return(scores)
    }
    showModal(modalDialog("Configurating cluster", footer=NULL))
    caCl<-makeCluster(4)
    clusterEvalQ(cl = caCl, expr = library(GOSemSim))
    clusterExport(cl = caCl, varlist = c("combineScoresWrapper","combineScoresLapply"), envir = environment())
    removeModal()
    
    fnctnRtrn<-parMgeneSim(caCl, genes, semData, measure, drop, combine)
    stopCluster(caCl)
    gc()
    return(fnctnRtrn)
    
  }
  
})

observeEvent(input$compute,{
  req(rawMatrix$rm)
  ini<-Sys.time()
  if(input$as_distancy){
    results$GO<-1-(distInsert(rawMatrix$rm, metaFunctions$parMgeneSim, "internalVecId"))
  }
  else{
    results$GO<-distInsert(rawMatrix$rm, metaFunctions$parMgeneSim, "internalVecId")
  }
  results$GO
  print(Sys.time()-ini)
})

output$result <- DT::renderDataTable({
  results$GO
})

output$download <- downloadHandler(
  filename = function() {
    paste("goMatrix-", Sys.Date(), ".txt", sep="")
  },
  content = function(file) {
    r<- as.data.frame(results$GO)
    r<- rownames_to_column(r,"vars")
    write.table(r, file, sep = "\t", dec = ".",
                row.names = FALSE, col.names = TRUE)
  }
)