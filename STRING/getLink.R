getLink<-function(genName1, genName2, infoCon, linkCon){
  print("----------------")
  query1<-paste0('{"preferred_name":"', genName1, '"}')
  gen1<-infoCon$find(query1)
  print(gen1$protein_external_id)
  
  query2<-paste0('{"preferred_name":"', genName2, '"}')
  gen2<-infoCon$find(query2)
  print(gen2$protein_external_id)
  
  if(is.null(gen1$protein_external_id) || is.null(gen2$protein_external_id)){
    score<-NULL
    print(score)
    return(score)
  }
  
  else{
    query3<-sprintf('{"$or":[{"$and":[{"protein1":"%s"},{"protein2":"%s"}]},{"$and":[{"protein2":"%s"},{"protein1":"%s"}]}]}',gen1$protein_external_id,gen2$protein_external_id,gen1$protein_external_id,gen2$protein_external_id)
    score<-linkCon$find(query3)
    print(score)
    return(score[1,])
  }
  
}