collectionConection<-function(user, password, cluster, db, collection){
  #generate the ultimate url.
  urlPath<-sprintf("mongodb+srv://%s:%s@%s",
                   user,
                   password,
                   cluster)
  #connect to the collection. 
  collCon<-mongo(db=db,
                 collection=collection,
                 url=urlPath,
                 verbose=TRUE)
  #return the connection environment.
  return(collCon)
}