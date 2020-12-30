clusterProfilePlot<-function(aCluster, nCluster, discrete ){
  if(discrete == TRUE){
    alphaLine = 0
    showPoint = TRUE
  }
  else{
    alphaLine = 0.5
    showPoint = FALSE
  }
  nVars<-length(aCluster[1,])
  clusterProfile<-ggparcoord(data = aCluster,
                             columns = c(2:nVars),
                             mapping=aes(color=as.factor(cluster)),
                             groupColumn = "cluster",
                             alphaLines = alphaLine,
                             showPoints = showPoint)+
    scale_color_manual(values=c('gray43'))+
    labs(title=paste0("Cluster N°",nCluster),x ="Condition", y = "Expresion level")+
    scale_size(guide = "none")+
    geom_boxplot(aes_string(group = "variable"),
                 width = 0.3,
                 outlier.color = "black",
                 alpha = 0.5,
                 color='black')+
    theme_ipsum()+
    theme(
      plot.title = element_text(size=10),
      legend.position = "none",
      axis.text.x = element_text(angle = 90, size = 4)
      
    )
  
  
  return(clusterProfile)
}