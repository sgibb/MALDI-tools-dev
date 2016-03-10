library(jpeg)
library(EBImage)

#load images-------------------------------------------------------------

msi <- readJPEG("msi.jpg")    #msi image
he <- readJPEG("he.jpg")      #he image

msi<-flip(msi)
msi<-rotate(msi,angle = 90)

he<-flip(he)
he<-rotate(he,angle = 90)

display(msi)
display(he)
#!now chose ref coordinates from display in browser 



#trafo-------------------------------------------------------------------

p1<-c(126,34); p2<-c(240,123)  #two ref points(x,y) in msi image
q1<-c(47,34); q2<-c(161,123)  #two ref points(x,y) in he image

#rotation
dot = sum((q2-q1)*(p2-p1))                         #dot product
d=det(matrix(c(q2-q1,p2-p1), ncol=2, byrow= TRUE)) #determinant
alpha<- atan2(d, dot)                              #rotation angle
rot<-rotate(he, alpha*(180/pi))                      #rotate he image
writeJPEG(rot,target = "rot.jpg")                    #save


#generate resizing + translation parameters
R<-matrix(c(cos(alpha), -sin(alpha),
            sin(alpha), cos(alpha)),
          nrow=2, byrow=TRUE)
tz<-c((dim(he)[1])/2,(dim(he)[2])/2)
s<-abs((p2-p1)/(R%*%(q2-q1)))           
sm<-matrix(c(s[1], 0, 0, s[2]), ncol=2, byrow=TRUE)
tzN<-c((dim(rot)[1])/2,(dim(rot)[2])/2)
tr<-p1-sm%*%(R%*%(q1-tz)+tzN)
wh=(dim(rot)[1:2])*s

#resize+save
rez<-resize(rot, wh[1], wh[2])
writeJPEG(rez,target = "rez.jpg")

#translate+save
#he(tra) now has same coordinates as msi
tra<-translate(rez, tr, output.dim=dim(msi)[1:2]) 
writeJPEG(tra,target = "tra.jpg")

#generate overlay img for visual control
ovl<-tra+msi-tra*msi
writeJPEG(ovl, "ovl.jpg")

#get back-flipped/rotated img for further analysis
tra<-rotate(tra,-90)
tra<-flip(tra)
writeJPEG(tra,target = "tra2.jpg")
