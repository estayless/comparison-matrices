collectionConnection <- function(user, password, ip, port, db, collection){
  #generate the ultimate url.
  urlPath <- sprintf("mongodb://%s:%s@%s:%s/?authMechanism=SCRAM-SHA-256&authSource=%s",
                     user,
                     password,
                     ip,
                     port,
                     db)
  #connect to the collection. 
  collConn <- mongo(db = db,
                    collection = collection,
                    url = urlPath,
                    verbose = TRUE)
  #return the connection environment.
  return(collConn)
}