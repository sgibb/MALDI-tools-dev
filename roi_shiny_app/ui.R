library(shiny)
library(shinyjs)

shinyUI(fluidPage(
  titlePanel(h3("MALDI Imaging")),

  sidebarLayout(
    sidebarPanel (
      useShinyjs(),
     
textInput("filepath", "File", value="histo.jpg"), actionButton("newimage", "Load Image"),
     br(), 
br(), 
         

	
	wellPanel(radioButtons("mode", label = "Mode",
             choices = list("Zoom" = 1, "Draw" = 2,
                            "Select" = 3), selected =1),
	       
	         
	          actionButton("selLabel", "Label", width=70),
	          actionButton("asignLabel", "Asign Label", width=90), 
	          br(),
	          br(),
	          
	          actionButton("del_selected", "Delete"), 
	          actionButton("delAll", "Delete All")
	          
	          
	          ), 

wellPanel(radioButtons("draw_choice", label = "Draw Options",
                       choices = list("Rectangle" = 1, "Polygon" = 2,
                                      "Pixel" = 3), selected =1), 
          
          checkboxInput("fillObj", label = "Fill out", value = FALSE),
          uiOutput("labels"),
          
          selectInput("labelsList", "Labels", choices=NULL),
          textInput("newLabel","New Label:" , value=NULL),
          colourInput("labelCol", "Color", value=NULL, showColour = "background", palette =  "limited", 
                      allowTransparent = FALSE),
         
          
          actionButton("addLabel", "Add"), 
          actionButton("removeLabel", "Remove")
          
          
          )	
,

wellPanel(actionButton("saveMask", "Save"))           

),

    mainPanel(
    textOutput("coordsHover"), 

uiOutput("ui")

    
         )#mainpanel


)#sidebar


  ))
  
 