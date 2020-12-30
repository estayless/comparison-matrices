STRINGRead<-function(geneName1, geneName2, CollectionInfoName, CollectionLinksName, dbName){
  #open conecction for protein info database
  ProteinInfoConnection<-mongo(collection = CollectionInfoName, db = dbName)
  
  #query for first Gene
  query1<-paste0('{"preferred_name":"', geneName1, '"}')
  gene1<-ProteinInfoConnection$find(query1)
  
  #query for second Gene
  query2<-paste0('{"preferred_name":"', geneName2, '"}')
  gene2<-ProteinInfoConnection$find(query2)
  
  #query for find the similarity betwen pair of genes
  query3<-sprintf('{"$or":[{"$and":[{"protein1":"%s"},{"protein2":"%s"}]},{"$and":[{"protein2":"%s"},{"protein1":"%s"}]}]}',gene1$protein_external_id,gene2$protein_external_id,gene1$protein_external_id,gene2$protein_external_id)
  #open coneection for protein links database
  ProteinLinksConnection<-mongo(collection = CollectionLinksName, db =dbName)
  sim<-ProteinLinksConnection$find(query3)
  
  #convert similarity into distance
  sim$neighborhood<-(1000-sim$neighborhood)/1000
  sim$fusion<-(1000-sim$fusion)/1000
  sim$cooccurence<-(1000-sim$cooccurence)/1000
  sim$coexpression<-(1000-sim$coexpression)/1000
  sim$experimental<-(1000-sim$experimental)/1000
  sim$database<-(1000-sim$database)/1000
  sim$textmining<-(1000-sim$textmining)/1000
  sim$combined_score<-(1000-sim$combined_score)/1000
  
  #close conecctions
  rm(ProteinInfoConnection,ProteinLinksConnection)
  #______________END MAIN___________________
  
  #return distances
  return(sim)
}

