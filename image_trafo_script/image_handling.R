library(jpeg)
library(EBImage)

img <- readJPEG("TMA1.jpg")
#image(img[,,1])

ny=5 #number of sections y(rows)
nx=7 #number of sections x(cols)

#generate coordinates
grx <- integer(nx)
for (i in 1:nx){
grx[i] <- as.integer(ncol(img)/nx*i)
}
grx <- c(1,grx)

gry <- integer(ny)
for (i in 1:ny){
  gry[i] <- as.integer(nrow(img)/ny*i)
}
gry<-c(1,gry)


#get image part
img1 <- img[gry[1]:gry[2], grx[7]:grx[8],]
img2 <- img[gry[2]:(gry[2]-100), grx[8]:(grx[8]-100), ]
display(img2)

writeJPEG(img2, target = "TMApart2.jpg")
