library(shiny)
library(EBImage)
library(shinyjs)

source("drawLine.R")

shinyServer(
  function(input, output, session) {

fileTemp="tempFile.jpg"
    
wdt=600
objMask<<-NULL
imgTemp<<-NULL   
labelList=list("Label"=c("tumor", "stroma", "insel"), "Color"=c("red", "blue", "green"), "Code"=c(1,2,3), "Mask"=list(0), "Contour"=list(0) )
ZoomF<<-NULL
objPoly<<-NULL
img<<-NULL
lblSel<<-NULL
rectSel<<-NULL
values <- reactiveValues(coords=list(x1=NULL, y1=NULL, x2=NULL, y2=NULL), updateScene=0, updateSel=0)

#render imageOutput

output$ui <- renderUI(
  if (input$mode==1) {
   
       imageOutput("image", width=600, height=600, click = NULL,
              brush=brushOpts(id = "zoom_brush", resetOnNew = "TRUE", clip="TRUE"), dblclick = "image_dblclick", hover=hoverOpts(id = "imgHover", delay = 300, delayType= "debounce", clip = TRUE, nullOutside = TRUE))
    }
  else
  {
    if (input$mode==2){
  switch(input$draw_choice,
"1"= imageOutput("image", width=600, height=600,dblclick = "image_dblclick", brush=brushOpts(id = "rect_draw", resetOnNew = "TRUE", clip="TRUE"), hover=hoverOpts(id = "imgHover", delay = 10, delayType= "debounce", clip = TRUE, nullOutside = TRUE)), 
"2"=  imageOutput("image", width=600, height=600, click = "image_click",brush=NULL, dblclick = "image_dblclick", hover=hoverOpts(id = "imgHover", delay = 10, delayType= "debounce", clip = TRUE, nullOutside = TRUE)),  
"3"= imageOutput("image", width=600, height=600, click = "image_click",brush=NULL, hover=hoverOpts(id = "imgHover", delay = 10, delayType= "debounce", clip = TRUE, nullOutside = TRUE))
)
          }
    else
    {
      imageOutput("image", width=600, height=600, click = NULL, dblclick="sel_dblClick" ,brush=brushOpts(id="brush_sel", resetOnNew = "TRUE", clip="TRUE"))
                 
    }
  }
    
   )


updateSelectInput(session, "labelsList", choices=labelList[["Label"]])



observeEvent(input$mode, {
  if (input$mode==1){
    disable("draw_choice")
    disable("selAll")
    disable("delAll")
    disable("del_selected")
    disable("fillObj")
    disable("selLabel")
    disable("asignLabel")
    disable("selMult")
    
  }
 else 
 {
   if (input$mode==2){
     enable("draw_choice")
     enable("fillObj")
     disable("selAll")
     disable("delAll")
     disable("del_selected")
     disable("selLabel")
     disable("asignLabel")
     disable("selMult")
   }
   else
   {
     disable("draw_choice")
     enable("fillObj")
     enable("selAll")
     enable("delAll")
     enable("selLabel")

     enable("selMult")
   }
     
   }
 
})


#Load new image
observeEvent(input$newimage, {
  filepath=input$filepath
  img<<-readImage(filepath)
  imgTemp<<-img
  objMask<<-array(0, c(dim(img)[1], dim(img)[2]))
  
  for (i in 1:length(labelList$Code))
  {labelList$Mask[[i]]<<-objMask
  labelList$Contour[[i]]<<-objMask}
  
  
  values$coords$x1=0
  values$coords$y1=0
  values$coords$y2=dim(img)[2]
  values$coords$x2=dim(img)[1]
  
})


#display mouse position over the image
observeEvent(input$imgHover, {
  x=round(input$imgHover$x*ZoomF+roiCoords[1])
  y=round(input$imgHover$y*ZoomF+roiCoords[2])
  output$coordsHover<-renderText({
    
    paste0("x=", x, "\n", "y=", y)
    
  })
  })

#Zooming
observeEvent(input$zoom_brush,{ 
  x1=round(input$zoom_brush$xmin*ZoomF+roiCoords[1])
  x2=round(input$zoom_brush$xmax*ZoomF+roiCoords[1])
  y1=round(input$zoom_brush$ymin*ZoomF+roiCoords[2])
  y2=round(input$zoom_brush$ymax*ZoomF+roiCoords[2])
  
  
  values$coords$x1=x1
  values$coords$x2=x2
  values$coords$y1=y1
  values$coords$y2=y2
  
})

#update coordinates of a subimage
observeEvent(values$coords,{
  
  if(is.null(values$coords$x1)==FALSE) {
    roiCoords<<-c(values$coords$x1, values$coords$y1)
    ZoomF<<-abs((values$coords$x2-values$coords$x1))/wdt
    
    writeImage(imgTemp[isolate(values$coords$x1):isolate(values$coords$x2), isolate(values$coords$y1):isolate(values$coords$y2),], fileTemp)
    output$image <- renderImage({
      list(src = fileTemp, width=wdt)
    },deleteFile= FALSE)
    
  }
  
})




#update image 

observeEvent(values$updateScene, {
  if (is.Image(img)) {
    imgTemp<<-img
    l=length(labelList$Code)
    if (l>1)
    {
      for (i in 1:l)
      {
        aCol=col2rgb(labelList$Color[i])
        for (j in 1:3)
        {
          if (input$fillObj){
          imgTemp[,,j]<<-abs(imgTemp[,,j]-labelList$Mask[[i]]*aCol[j])
          
          }
          imgTemp[,,j]<<-imgTemp[,,j]*(labelList$Contour[[i]]==0)+labelList$Contour[[i]]*aCol[j]
          
        }
        
      }
    }

 writeImage(imgTemp[isolate(values$coords$x1):isolate(values$coords$x2), isolate(values$coords$y1):isolate(values$coords$y2),], fileTemp)
  output$image <- renderImage({
    list(src = fileTemp, width=wdt)
  },deleteFile= FALSE)
  
}
})



#Option filled objects
observeEvent(input$fillObj, {
  
  values$updateScene=!values$updateScene
})


#Draw a rectangle
observeEvent (input$rect_draw, {
  x1=round(input$rect_draw$xmin*ZoomF+roiCoords[1])
  y1=round(input$rect_draw$ymin*ZoomF+roiCoords[2])
  x2=round(input$rect_draw$xmax*ZoomF+roiCoords[1])
  y2=round(input$rect_draw$ymax*ZoomF+roiCoords[2])
  
  
  objVec=append(append (drawLine(x1, y1, x2, y1), drawLine (x2, y1, x2, y2)),append(drawLine(x2, y2, x1,y2), drawLine(x1, y2, x1,y1))) 
  objm=matrix(objVec, ncol=2, byrow=TRUE)
 
#update Mask
  
  i=which(labelList$Label==input$labelsList)
 
  labelList$Mask[[i]][x1:x2, y1:y2]<<-1
  labelList$Contour[[i]][objm]<<-1
  

values$updateScene=!values$updateScene
  
  
})  


#click on the image

observeEvent(input$image_click, {
  
  x=round(input$image_click$x*ZoomF+roiCoords[1])
  y=round(input$image_click$y*ZoomF+roiCoords[2])
  l=length(objList$Code)
  if (is.null(objPoly))
  {
    objPoly<<-rbind(c(x,y), objPoly)
  }
  else {
  
  if (input$draw_choice=="1"){
objPoly<<-NULL
       }   
  else 
  {
  if (input$draw_choice=="3")
 {
   objVec<-c(x,y)
  
  }
    
    else
    
    {
     
      objVec<-drawLine(objPoly[1,1], objPoly[1,2], x,y)
      objPoly<<-rbind(c(x,y),objPoly)
      
    }
objm=matrix(objVec, ncol=2, byrow = TRUE)

i=which(labelList$Label==input$labelsList)
labelList$Mask[[i]][objm]<<-1
labelList$Contour[[i]][objm]<<-1



aCol=col2rgb(labelList$Color[i])
for (j in 1:3)
{
   imgTemp[,,j][objm]<<-aCol[j]
  
}

 

writeImage(imgTemp[isolate(values$coords$x1):isolate(values$coords$x2), isolate(values$coords$y1):isolate(values$coords$y2),], fileTemp)
output$image <- renderImage({
  list(src = fileTemp, width=wdt)
},deleteFile= FALSE) 
  }
  }
  
  
  })

#double click

observeEvent(input$image_dblclick, {
  if (is.null(objPoly)){
    values$coords$x1=0
    values$coords$y1=0
    values$coords$y2=dim(img)[2]
    values$coords$x2=dim(img)[1]
  }
  else{
    x=round(input$image_dblclick$x*ZoomF+roiCoords[1])
    y=round(input$image_dblclick$y*ZoomF+roiCoords[2])
    
    # connect first and last point of the polygon
    
    if (input$draw_choice==2)   { 
      objVec=append(drawLine(objPoly[dim(objPoly)[1],1], objPoly[dim(objPoly)[1],2], x,y), drawLine(x,y, objPoly[1,1],objPoly[1, 2]))
      objPoly<<-rbind(c(x,y), objPoly)
      objm=matrix(objVec, ncol=2, byrow = TRUE)
      lbl=which(labelList$Label==input$labelsList)
      labelList$Contour[[lbl]][objm]<<-1
      
        #compute the area of the polygon    
      xmin=min(objPoly[,1])
      ymin=min(objPoly[,2])
      xmax=max(objPoly[,1])
      ymax=max(objPoly[,2])
      
      h=rbind(objPoly, objPoly[1:2,])
     
     

     Edges=NULL
     actEdges=list()
     
     
      for (j in 2:(dim(objPoly)[1]+1))
      {
        if (h[j,2]<h[j+1,2])
        {
          Edges=rbind(Edges, append(h[j,], h[j+1,]))
         if (h[j-1,2]<=h[j,2])
          {
            Edges=rbind(Edges, append(h[j,], h[j,]))
          }
        }
        else 
        {
          if (h[j,2]>h[j+1,2])
          {
          Edges=rbind(Edges, append(h[j+1,], h[j,]))
          if (h[j-1,2]>=h[j,2])
          {
           Edges=rbind(Edges, append(h[j,], h[j,]))
          }
          }
          else
          {
            objm=drawLine(h[j+1,1],h[j+1,2], h[j,1], h[j,2])
            objMask[objm]<<-1
          }
        }
        
      }
        
        
      for (j in ymin:ymax)
        
        
      {
       ver=which(Edges[,2]==j)
       
       
       l=length(actEdges)
        
      if (length(ver)>0)
      {
          for (i in ver)
        {
         l=l+1
         actEdges[[l]]<-matrix(drawLine(Edges[i,1],Edges[i,2],Edges[i,3],Edges[i,4]), ncol=2, byrow=TRUE)
         
        }
        }
        k=NULL
        n=NULL
        i=NULL
        if (l>0){
          
         for (edge in actEdges)
       {
           i=i+1
        g=edge[,1][edge[,2]==j]
        if (length(g)>0) {n=rbind(n, c(min(g), max(g)))}
         
   if ((edge[dim(edge)[1],2])==j)
    {
     k=append(k, i)
    }
    }
  
      if (length(k)>0) {actEdges[[k]]=NULL}
        
                 
        if (length(n)>0) { 
          n[,1]=n[,1][sort.list(n[,2])]
          n[,2]=sort(n[,2]) 
          k=(dim(n)[1]%/%2)
       for (i in 1:k) 
          {
         
         objMask[n[2*i-1,1]:n[2*i,2], j]<<-1
         }
      }
     }
      }
  
 #update Mask  
    
     labelList$Mask[[lbl]][objMask>0]<<-1
 
     
     objMask[,]<<-0
     
     
     values$updateScene=!values$updateScene
     
    objPoly<<-NULL
  
       
    }
  }

}) 

##Manage Labels

#Add label
observeEvent(input$addLabel, {
  l=length(labelList[["Code"]])+1
  
  
  labelList$Label<<-append(labelList$Label, input$newLabel, after=0)
  labelList$Color<<-append(labelList$Color, input$labelCol, after = 0)
  labelList$Code<<-append(labelList$Code, l, after=0)
  if (!is.null(objMask))
    {
  labelList$Mask[[l]]<<-objMask
  labelList$Contour[[l]]<<-objMask
  }
  else
  {
    labelList$Mask[[l]]<<-0
    labelList$Contour[[l]]<<-0
  }
  
  updateTextInput(session, "newLabel", label=NULL, value="")
  
  updateSelectInput(session, "labelsList", choices=labelList[["Label"]])
  
  
})

#update color according to current label
observeEvent(input$labelsList, {
  
  updateColourInput(session, "labelCol", value = labelList$Color[which(labelList[["Label"]]==input$labelsList)])
})



#remove label

observeEvent (input$removeLabel, 
              
              {
              i=-which(labelList$Label==input$labelsList)
              labelList$Color<<- labelList$Color[i] 
              labelList$Code<<-labelList$Code[i]
             labelList$Label<<-labelList$Label[i]
             labelList$Mask<<-labelList$Mask[i]
             labelList$Contour<<-labelList$Contour[i]
             updateSelectInput(session, "labelsList", choices=labelList[["Label"]])
             
             })


##Manage objects
#delete all objects
observeEvent(input$delAll, {
  
 objMask<<-0
 l=length(labelList$Code)
 for (i in 1:l)
 {
   labelList$Mask[[i]]<<-objMask
   labelList$Contour[[i]]<<-objMask
   
 }

  values$updateScene=!values$updateScene
})

#select objects by brushing
observeEvent (input$brush_sel, {
  
  x1=round(input$brush_sel$xmin*ZoomF+roiCoords[1])
  x2=round(input$brush_sel$xmax*ZoomF+roiCoords[1])
  y1=round(input$brush_sel$ymin*ZoomF+roiCoords[2])
  y2=round(input$brush_sel$ymax*ZoomF+roiCoords[2])
  rectSel<<-c(x1,x2,y1,y2)
  n=imgTemp
  n[x1:x2,y1:y2,]= 0.8*n[x1:x2,y1:y2,]
  
  writeImage(n[isolate(values$coords$x1):isolate(values$coords$x2), isolate(values$coords$y1):isolate(values$coords$y2),], fileTemp)
  output$image <- renderImage({
    list(src = fileTemp, width=wdt)
  },deleteFile= FALSE)
  
  lblSel<<-NULL
  enable("del_selected")
  enable("asignLabel")
  

})

#select all objects of the current label 
observeEvent(input$selLabel, {
  lblSel<<-which(labelList$Label==input$labelsList) 
  n=imgTemp
  m=labelList$Mask[[lblSel]]>0
  n[,,][m]= 0.8*n[,,][m]
  
  writeImage(n[isolate(values$coords$x1):isolate(values$coords$x2), isolate(values$coords$y1):isolate(values$coords$y2),], fileTemp)
  output$image <- renderImage({
    list(src = fileTemp, width=wdt)
  },deleteFile= FALSE)
  
  enable("del_selected")
  enable("asignLabel")
  
  
  })

#disselect area by double click on the image
observeEvent(input$sel_dblClick, {
  
  lblSel<<-NULL
  rectSel<<-NULL
  disable("del_selected")
  disable("asignLabel")
  values$updateScene=!values$updateScene
})


#delete selected objects 
observeEvent(input$del_selected, {
  if (!is.null(rectSel))
  {
    l=length(labelList$Code)
    for (i in 1:l)
    {
      labelList$Mask[[i]][rectSel[1]:rectSel[2], rectSel[3]:rectSel[4]]<<-0
      labelList$Contour[[i]][rectSel[1]:rectSel[2], rectSel[3]:rectSel[4]]<<-0
    }
    
  }
  
  if (!is.null(lblSel))
  {
    labelList$Mask[[lblSel]]<<-objMask
    labelList$Contour[[lblSel]]<<-objMask
  }
   
  
  disable("del_selected")
  disable("asignLabel")
  
    values$updateScene=!values$updateScene
  
})


#asign new label 

observeEvent(input$asignLabel, {
 
  i=which(labelList$Label==input$labelsList)
   if (!is.null(lblSel))
  {
labelList$Mask[[i]][labelList$Mask[[lblSel]]>0]<<-1
labelList$Contour[[i]][labelList$Contour[[lblSel]]>0]<<-1
labelList$Mask[[lblSel]]<<-objMask
labelList$Contour[[lblSel]]<<-objMask
  }
if (!is.null(rectSel))
{
  l=length(labelList$Code)
  for (j in 1:l)
  {
    if (j!=i)
    {
    labelList$Mask[[i]][rectSel[1]:rectSel[2], rectSel[3]:rectSel[4]][labelList$Mask[[j]][rectSel[1]:rectSel[2], rectSel[3]:rectSel[4]]>0]<<-1
    labelList$Mask[[j]][rectSel[1]:rectSel[2], rectSel[3]:rectSel[4]]<<-0
    labelList$Contour[[i]][rectSel[1]:rectSel[2], rectSel[3]:rectSel[4]][labelList$Contour[[j]][rectSel[1]:rectSel[2], rectSel[3]:rectSel[4]]>0]<<-1
    labelList$Contour[[j]][rectSel[1]:rectSel[2], rectSel[3]:rectSel[4]]<<-0
    }
    }
  
}
  
  values$updateScene=!values$updateScene
  disable("del_selected")
  disable("asignLabel")
  lblSel<<-NULL
})  
 



observeEvent(input$saveMask, {
  objPoly<<-NULL
  disable("del_selected")
  disable("asignLabel")
  lblSel<<-NULL
  rectSel<<-NULL
  values$updateScene=!values$updateScene
  fileMask<<-"segmentation.R"
  data=labelList
  save(data, file=fileMask)})

}
)

