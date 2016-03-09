library(shiny)
library(EBImage)
library(shinyjs)
library(abind)



imgSrc<<-NULL
imgRef<<-NULL
s<<-NULL
tr<<-NULL
alpha<<-NULL
n<<-NULL
refCoords<<-NULL
srcCoords<<-NULL
ZoomRef<<-NULL
ZoomSrc<<-NULL
hgt=300
fileTempSrc="TMAsrc.jpg"
fileTempRef="TMAref.jpg"



shinyServer(
  function(input, output, session) {
    values <- reactiveValues(coordsRef=list(x1=NULL, y1=NULL, x2=NULL, y2=NULL), 
                             coordsSrc=list(x1=NULL, y1=NULL, x2=NULL, y2=NULL), 
                            updateRef=0, 
                             updateSrc=0)
    
  observeEvent(input$refImage, {
    imgRef<<-readImage(input$filepathRef)
      
      values$coordsRef$x1=0
      values$coordsRef$y1=0
      values$coordsRef$y2=dim(imgRef)[2]
      values$coordsRef$x2=dim(imgRef)[1]
    })

    
    
    
    observeEvent(input$srcImage, {
      imgSrc<<-readImage(input$filepathSrc)
      values$coordsSrc$x1=0
      values$coordsSrc$y1=0
      values$coordsSrc$y2=dim(imgSrc)[2]
      values$coordsSrc$x2=dim(imgSrc)[1]
      
    })
    
    
    
    observeEvent(input$brushRef,{ 
      x1=round(input$brushRef$xmin*ZoomRef+refCoords[1])
      x2=round(input$brushRef$xmax*ZoomRef+refCoords[1])
      y1=round(input$brushRef$ymin*ZoomRef+refCoords[2])
      y2=round(input$brushRef$ymax*ZoomRef+refCoords[2])
      
      
      values$coordsRef$x1=x1
      values$coordsRef$x2=x2
      values$coordsRef$y1=y1
      values$coordsRef$y2=y2
    })
    observeEvent(input$brushSrc,{ 
      x1=round(input$brushSrc$xmin*ZoomSrc+srcCoords[1])
      x2=round(input$brushSrc$xmax*ZoomSrc+srcCoords[1])
      y1=round(input$brushSrc$ymin*ZoomSrc+srcCoords[2])
      y2=round(input$brushSrc$ymax*ZoomSrc+srcCoords[2])
      
      
      values$coordsSrc$x1=x1
      values$coordsSrc$x2=x2
      values$coordsSrc$y1=y1
      values$coordsSrc$y2=y2
    })
    
    observeEvent(input$refHover, {
      x=round(input$refHover$x*ZoomRef+refCoords[1])
      y=round(input$refHover$y*ZoomRef+refCoords[2])
       output$textRef=renderText(paste0("x=",x, "\n", "y=", y))
        
    })
    
    observeEvent(input$srcHover, {
      x=round(input$srcHover$x*ZoomSrc+srcCoords[1])
      y=round(input$srcHover$y*ZoomSrc+srcCoords[2])
      output$textSrc=renderText(paste0("x=",x, "\n", "y=", y ))
      
    })
    
    observeEvent(values$coordsRef,{
      
      if(is.null(values$coordsRef$x1)==FALSE) {
        refCoords<<-c(values$coordsRef$x1, values$coordsRef$y1)
        ZoomRef<<-abs((values$coordsRef$y2-values$coordsRef$y1))/hgt
        values$updateRef=!values$updateRef
        
        #writeImage(imgRef[isolate(values$coordsRef$x1):isolate(values$coordsRef$x2), isolate(values$coordsRef$y1):isolate(values$coordsRef$y2),], fileTempRef)
        #output$imageRef <- renderImage({
        #  list(src = fileTempRef, height=hgt)
        #},deleteFile= FALSE)
        
      }
      
      
    })
    
    
    observeEvent(values$coordsSrc,{
      
      if(is.null(values$coordsSrc$x1)==FALSE) {
        srcCoords<<-c(values$coordsSrc$x1, values$coordsSrc$y1)
        ZoomSrc<<-abs((values$coordsSrc$y2-values$coordsSrc$y1))/hgt
        values$updateSrc=!values$updateSrc
        #img=imgSrc
        #if (is.numeric(input$numSrcP1x)&is.numeric(input$numSrcP1y))
        #{img=drawCircle(imgSrc, input$numSrcP1x,input$numSrcP1y, radius = 1, col="red", fill=0 )}
        #if (is.numeric(input$numSrcP2x)&is.numeric(input$numSrcP2y))
        #{img=drawCircle(img, input$numSrcP2x,input$numSrcP2y, radius = 1, col="blue", fill=0 )}
        # writeImage(img[isolate(values$coordsSrc$x1):isolate(values$coordsSrc$x2), isolate(values$coordsSrc$y1):isolate(values$coordsSrc$y2),], fileTempSrc)
       # output$imageSrc <- renderImage({
       #   list(src = fileTempSrc, height=hgt)
       # },deleteFile= FALSE)
        
      }
      
      
    })
   
    observeEvent(input$numRefP1x,{
      values$updateRef=!values$updateRef
      
    } )
    observeEvent(input$numRefP2x,{
      values$updateRef=!values$updateRef
      
    } )
    observeEvent(input$numRefP1y,{
      values$updateRef=!values$updateRef
      
    } )
    observeEvent(input$numRefP2y,{
      values$updateRef=!values$updateRef
      
    } )
    
    
    
    
    observeEvent(values$updateRef, {
      if (is.Image(imgRef)){
      img=imgRef
     
      if (is.numeric(input$numRefP1x)&is.numeric(input$numRefP1y))
      {img=drawCircle(img, input$numRefP1x,input$numRefP1y, radius = 1, col="red", fill=0 )
      }
      if (is.numeric(input$numRefP2x)&is.numeric(input$numRefP2y))
      {img=drawCircle(img, input$numRefP2x,input$numRefP2y, radius = 1, col="blue", fill=0 )
      }
  
      writeImage(img[isolate(values$coordsRef$x1):isolate(values$coordsRef$x2), isolate(values$coordsRef$y1):isolate(values$coordsRef$y2),], fileTempRef)
      output$imageRef <- renderImage({
        list(src = fileTempRef, height=hgt)
      },deleteFile= FALSE)
    }
    })
    observeEvent(input$numSrcP1x,{
      values$updateSrc=!values$updateSrc
      
    } )
    observeEvent(input$numSrcP2x,{
      values$updateSrc=!values$updateSrc
      
    } )
    observeEvent(input$numSrcP1y,{
      values$updateSrc=!values$updateSrc
      
    } )
    observeEvent(input$numSrcP2y,{
      values$updateSrc=!values$updateSrc
      
    } )
    
    
    observeEvent(values$updateSrc, {
      if (is.Image(imgSrc)){
      img=imgSrc
           if (is.numeric(input$numSrcP1x)&is.numeric(input$numSrcP1y))
      {img=drawCircle(imgSrc, input$numSrcP1x,input$numSrcP1y, radius = 1, col="red", fill=0 )
      }
      if (is.numeric(input$numSrcP2x)&is.numeric(input$numSrcP2y))
      {img=drawCircle(img, input$numSrcP2x,input$numSrcP2y, radius = 1, col="blue", fill=0 )
      }
      
        writeImage(img[isolate(values$coordsSrc$x1):isolate(values$coordsSrc$x2), isolate(values$coordsSrc$y1):isolate(values$coordsSrc$y2),], fileTempSrc)
        output$imageSrc <- renderImage({
          list(src = fileTempSrc, height=hgt)
        },deleteFile= FALSE)
      }
    })
    
   
    
    observeEvent(input$imgSrc_dblClick,{
      
      x=round(input$imgSrc_dblClick$x*ZoomSrc+srcCoords[1])
      y=round(input$imgSrc_dblClick$y*ZoomSrc+srcCoords[2])
      
      if (input$choosePointSrc=="1")
      {
        updateNumericInput(session, "numSrcP1x", value=x )
        updateNumericInput(session, "numSrcP1y", value=y )
      }
      else
      {
        if (input$choosePointSrc=="2")
        {
          updateNumericInput(session, "numSrcP2x", value=x )
          updateNumericInput(session, "numSrcP2y", value=y )
        }
      }
      
    })
    
    observeEvent(input$imgRef_dblClick,{
      
      x=round(input$imgRef_dblClick$x*ZoomRef+refCoords[1])
      y=round(input$imgRef_dblClick$y*ZoomRef+refCoords[2])
      
      if (input$choosePointRef=="1")
      {
      updateNumericInput(session, "numRefP1x", value=x )
      updateNumericInput(session, "numRefP1y", value=y )
      }
      else
      {
        if (input$choosePointRef=="2")
        {
        updateNumericInput(session, "numRefP2x", value=x )
        updateNumericInput(session, "numRefP2y", value=y )
        }
      }
     
    })
    
    observeEvent(input$reg, {
      
      p1<<-c(input$numRefP1x, input$numRefP1y) 
      p2<<-c(input$numRefP2x, input$numRefP2y) 
      
     q1<<-c(input$numSrcP1x, input$numSrcP1y)
     q2<<-c(input$numSrcP2x, input$numSrcP2y)
      
     
  
      
     dot = sum((q2-q1)*(p2-p1))   # dot product
     d=det(matrix(c(q2-q1,p2-p1), ncol=2, byrow= TRUE)) # determinant
     alpha<<- atan2(d, dot) 
     
      
      R<<-matrix(c(cos(alpha), -sin(alpha), sin(alpha), cos(alpha)), nrow=2, byrow=TRUE) 
      
      
      tz<<-c((dim(imgSrc)[1])/2,(dim(imgSrc)[2])/2)
      s<<-abs((p2-p1)/(R%*%(q2-q1)))
      sm<<-matrix(c(s[1], 0, 0, s[2]), ncol=2, byrow=TRUE)
      n<<-rotate(imgSrc, alpha*(180/pi))
      tzN<<-c((dim(n)[1])/2,(dim(n)[2])/2)
     tr<<-p1-sm%*%(R%*%(q1-tz)+tzN)
     
 
  wh=(dim(n)[1:2])*s
  m<<-resize(n, wh[1], wh[2])
  n<<-translate(m, tr, output.dim=dim(imgRef)[1:2])  
  n<<-n+imgRef-n*imgRef
  writeImage(n, "Temp.jpg")

  output$imageRef <- renderImage({
    list(src = "Temp.jpg")
  },deleteFile= FALSE)
    
    })
    
  
    
    observeEvent(input$srcReset, {
      values$coordsSrc$x1=0
      values$coordsSrc$y1=0
      values$coordsSrc$y2=dim(imgSrc)[2]
      values$coordsSrc$x2=dim(imgSrc)[1]
      
      values$updateSrc=!values$updateSrc
     
    })
    observeEvent(input$refReset, {
      values$coordsRef$x1=0
      values$coordsRef$y1=0
      values$coordsRef$y2=dim(imgRef)[2]
      values$coordsRef$x2=dim(imgRef)[1]
      values$updateRef=!values$updateRef
    })
    
    
    
  

    
  } 
)