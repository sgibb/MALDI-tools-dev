library(shiny)
library(EBImage)
library(shinyjs)
library(abind)
library(jpeg)

img <- readJPEG("TMApart1.jpg")
display(img)