clusterSol<-eventReactive(input$computeMOCGAPBK,{
  req(input$matrix1, input$matrix2)
  dm1<-paste0("results$",input$matrix1)
  dm2<-paste0("results$",input$matrix2)
  showModal(modalDialog("Computing MOCKGAPBK", footer=NULL))
  cs<-moc.gabk(dmatrix1 = eval(parse(text=dm1)), dmatrix2 = eval(parse(text=dm2)), num_k = input$num_k,
               generation = input$generation, pop_size = input$pop_size,
               rat_cross = input$rat_crossover, rat_muta = input$rat_mutation,
               tour_size = input$tour_size, neighborhood = ,
               local_search = input$local_search)
  removeModal()
  cs
})

clusterSolObj<-reactive({
  req(clusterSol())
  showModal(modalDialog("Generating objective solutions", footer=NULL))
  solution<-1:length(clusterSol()[["population"]][["obj1"]])
  objective1<-clusterSol()[["population"]][["obj1"]]
  objective2<-clusterSol()[["population"]][["obj2"]]
  solObjs<-as.data.frame(cbind(solution, objective1, objective2))
  removeModal()
  solObjs
})

plotSolObj<-observe({
  req(clusterSolObj())
  showModal(modalDialog("Ploting objective solutions", footer=NULL))
  auxSolObj<-clusterSolObj()
  auxSolObj$solution<-as.factor(auxSolObj$solution)
  
  output$solutions<-renderPlot({
    ggplot(auxSolObj, aes(x=objective1, y=objective2, color= solution, shape=solution)) + 
      geom_point(size=3, alpha = 0.9) +
      scale_shape_manual(values = rep(1:18, 6))+
      theme_ipsum()+
      theme(plot.margin = unit(c(0,0,0,0), "cm"))
  })
  removeModal()
})

selectedSolObj<-reactive({
  req(clusterSolObj())
  selectedSolution<-nearPoints(clusterSolObj(), input$solutions_click, addDist = TRUE)$solution
  selectedSolution
})

observe({
  req(selectedSolObj())
  if(length(selectedSolObj()) != 0){
    showModal(modalDialog("Ploting selected solution", footer=NULL))
    cluster<-clusterSol()$matrix.solutions[[selectedSolObj()]]
    
    output$completePlot<-renderPlot({
      isolate(completePlot(rawMatrix$rm, cluster, input$num_k, input$relatedVariable))
    }, height = 1000)
    removeModal()
  }
  else{
    print("NOT POSSIBLE PLOT SELECTED SOL LENGTH == 0")
  }
})