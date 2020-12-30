distInsert<-function(df, fnctn, varType){

  variableFnctn<-fnctn
  numVar <- length(rownames(df))
  vars<-as.list(NULL)
  vars[[1]]<-rownames(df)
  vars[[2]]<-rownames(df)
  
  compMatrix <- matrix(NA , nrow=numVar, ncol=numVar, dimnames = vars)

  prs <- combinations(numVar, 2, replace = TRUE)
  
  if(varType == "internalPairVec"){
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Computed comparison ", value = 0)
    
    for(i in 1:length(prs[,1])){
      var1<-as.numeric(df[rownames(compMatrix)[prs[i, 1]],])
      var2<-as.numeric(df[colnames(compMatrix)[prs[i, 2]],])
      compMatrix[rownames(compMatrix)[prs[i, 1]], colnames(compMatrix)[prs[i, 2]]] <- variableFnctn(var1, var2)
      comparison<-paste0(rownames(compMatrix)[prs[i, 1]], " and ",colnames(compMatrix)[prs[i, 2]], " = ",compMatrix[rownames(compMatrix)[prs[i, 1]], colnames(compMatrix)[prs[i, 2]]])
      progress$inc(1/length(prs[,1]), detail = comparison)
    } 
    
  }
  
  else if (varType == "internalMatrix"){
    intMatrix<- variableFnctn(df)
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Computed comparison ", value = 0)
    for(i in 1:length(prs[,1])){
      compMatrix[rownames(compMatrix)[prs[i, 1]], colnames(compMatrix)[prs[i, 2]]] <- intMatrix[rownames(compMatrix)[prs[i, 1]], colnames(compMatrix)[prs[i, 2]]]
      comparison<-paste0(rownames(compMatrix)[prs[i, 1]], " and ",colnames(compMatrix)[prs[i, 2]], " = ",compMatrix[rownames(compMatrix)[prs[i, 1]], colnames(compMatrix)[prs[i, 2]]])
      progress$inc(1/length(prs[,1]), detail = comparison)
    }
    
  }
  
  else if(varType == "externalPairIdComp"){
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Computed comparison ", value = 0)
    
    for(i in 1:length(prs[,1])){
      print(rownames(compMatrix)[prs[i, 1]])
      print(colnames(compMatrix)[prs[i, 2]])
      compMatrix[rownames(compMatrix)[prs[i, 1]], colnames(compMatrix)[prs[i, 2]]] <- variableFnctn(rownames(compMatrix)[prs[i, 1]], colnames(compMatrix)[prs[i, 2]])
      comparison<-paste0(rownames(compMatrix)[prs[i, 1]], " and ",colnames(compMatrix)[prs[i, 2]], " = ",compMatrix[rownames(compMatrix)[prs[i, 1]], colnames(compMatrix)[prs[i, 2]]])
      progress$inc(1/length(prs[,1]), detail = comparison)
    } 
  }
  
  else if (varType == "externalVecIdComp"){
    print("EXTERNAL VEC COMP")
  }
  
  else if(varType == "internalVecId"){
    print(rownames(df))
    compMatrix<-variableFnctn(rownames(df))
    return(compMatrix)
  }
  
  else if(varType == "internalMatrixV2"){
    return(variableFnctn(df))
  }
  
  else{
    print("else")
  }
  
  compMatrix[lower.tri(compMatrix)] = t(compMatrix)[lower.tri(compMatrix)]

  return(compMatrix)
}