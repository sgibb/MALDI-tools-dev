library(jpeg)
library(EBImage)

imgSrc<-NULL
imgRef<-NULL
refCoords<-NULL
srcCoords<-NULL
ZoomRef<-NULL
ZoomSrc<-NULL

s<-NULL
tr<-NULL
alpha<-NULL
n<-NULL
input <- list()

hgt=300

imgRef <- readJPEG("MSI.jpg")    #MSI=ref image
imgSrc <- readJPEG("HE.jpg")     #HE=src image


p1<-c(17,96) 
p2<-c(122,255) 

q1<-c(16,19)
q2<-c(122,178)




dot = sum((q2-q1)*(p2-p1))   # dot product
d=det(matrix(c(q2-q1,p2-p1), ncol=2, byrow= TRUE)) # determinant
alpha<- atan2(d, dot) 


R<-matrix(c(cos(alpha), -sin(alpha), sin(alpha), cos(alpha)), nrow=2, byrow=TRUE) 


tz<-c((dim(imgSrc)[1])/2,(dim(imgSrc)[2])/2)
s<-abs((p2-p1)/(R%*%(q2-q1)))
sm<-matrix(c(s[1], 0, 0, s[2]), ncol=2, byrow=TRUE)

#rotation
n<-rotate(imgSrc, alpha*(180/pi))
writeJPEG(n,target = "rot.jpg")

tzN<-c((dim(n)[1])/2,(dim(n)[2])/2)
tr<-p1-sm%*%(R%*%(q1-tz)+tzN)
wh=(dim(n)[1:2])*s

#resize
m<-resize(n, wh[1], wh[2])
writeJPEG(m,target = "rez.jpg")

#translate
t<-translate(m, tr, output.dim=dim(imgRef)[1:2]) 
writeJPEG(t,target = "tra.jpg")
#src pic now has same coordinates as ref pic

#generate overlay
n<-translate(m, tr, output.dim=dim(imgRef)[1:2]) 
n<-n+imgRef-n*imgRef
writeJPEG(n, "overlay.jpg")





