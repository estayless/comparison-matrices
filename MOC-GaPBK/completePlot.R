completePlot<-function(x, cluster, nClusters, discrete){
  clusterMatrix<-cbind(cluster,x)
  clusterNumbers<-c(1:nClusters)
  listOfClusters<-vector("list", length = nClusters)
  clusterTibble<-as_tibble(clusterMatrix, rownames = NA, colnames = NA)
  
  for (nCluster in (1:nClusters)){
    aCluster <- filter(clusterTibble, cluster == nCluster)
    listOfClusters[[nCluster]]<-aCluster
  }
  
  margin = theme(plot.margin = unit(c(0.3,1,0,1), "cm"))
  pl<-mapply(clusterProfilePlot,aCluster=listOfClusters, nCluster=clusterNumbers, discrete=discrete, SIMPLIFY = FALSE)
  grid.arrange( grobs = lapply(pl, "+", margin), ncol=1)
  
  redBlackGreen <- c("green", "black", "red") 
  pal <- colorRampPalette(redBlackGreen)(100)
  
  eisenPlot<- as.ggplot(
    Heatmap(as.matrix(clusterTibble[,-1]),
            col = pal,
            name = "Expresion  \nlevel \n",
            split = clusterTibble$cluster,
            column_order = NULL,
            column_names_rot = 90,
            column_names_max_height = unit(8,"cm"),
            row_dend_width = unit(3, "cm"),
            row_dend_side = "right",
            
            
    )
  )
  
  ggarrange(eisenPlot, grid.arrange( grobs = lapply(pl, "+", margin), ncol=1),
            ncol=2,nrow=1)
  
}

