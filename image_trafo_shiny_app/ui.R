library(shiny)


shinyUI(fluidPage(
  titlePanel(h3("Image Registration")),
  sidebarLayout(
    sidebarPanel
    (
    
    wellPanel(textInput("filepathRef",label= "File reference", value="TMAref.jpg"),
              actionButton("refImage", "Load"),
              actionButton("refReset", "Reset"),
              actionButton("refMSI", "msi"),
            radioButtons("choosePointRef", label="", choices=list("p1"="1", "p2"="2")),  
            numericInput("numRefP1x", label="p1$x", width=80, value=NULL),numericInput("numRefP1y",label="p1$y", width=80, value=NULL),
              numericInput("numRefP2x", label="p2$x", width=80, value=NULL),numericInput("numRefP2y", label="p2$y", width=80, value=NULL)
               
               
    ),
                  br(), 
                 br(), 
                wellPanel(
                 textInput("filepathSrc",label= "File source", value="TMAsrc.jpg"),
                 actionButton("srcImage", "Load"),
                  actionButton("srcReset", "Reset"),
                 actionButton("srcMSI", "msi"),
                 radioButtons("choosePointSrc", label="", choices=list("p1"="1", "p2"="2")),  
                numericInput("numSrcP1x", label="p1$x", width=80, value=NULL),numericInput("numSrcP1y",label="p1$y", width=80, value=NULL),
                numericInput("numSrcP2x", label="p2$x", width=80, value=NULL),numericInput("numSrcP2y", label="p2$y", width=80, value=NULL)
                
                 
                ),
                 wellPanel(actionButton("reg", "Go")),
                 wellPanel(actionButton("saveMask", "Save"))
                           ),
    
    mainPanel( textOutput("textRef"),
      imageOutput("imageRef", dblclick="imgRef_dblClick", brush=brushOpts(id="brushRef", resetOnNew = TRUE, clip=TRUE, delay=800) , hover=hoverOpts(id = "refHover", delay = 10, delayType= "debounce", clip = TRUE, nullOutside = TRUE)),
               
               #br(),
               hr(),
      textOutput("textSrc"),
      imageOutput("imageSrc", dblclick="imgSrc_dblClick", brush=brushOpts(id="brushSrc", resetOnNew = TRUE, clip=TRUE, delay=800) , hover=hoverOpts(id = "srcHover", delay = 10, delayType= "debounce", clip = TRUE, nullOutside = TRUE)) 
              
               
    )
  )
)


)
  

