specieConectionSettings<-function(taxon){
  settings<-c()
  if(taxon == "9606"){
    user<-"user"
    password<-"HumanString"
    db<-"test"
    cluster<-"string.echpp.mongodb.net/test"
    CollectionInfoName<-"proteinInfo9606"
    CollectionLinksName<-"proteinLinks9606"
    
    settings<-c(user, password, cluster, db, CollectionInfoName, CollectionLinksName)
  }
  
  return(settings)
}
