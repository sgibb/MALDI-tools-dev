source("trafo_functions.R")

he<-readImage("he.jpg")
msi<-readImage("msi.jpg")

# visually check corresponding coordinates
display(he)
display(msi)

he1<-c(47,35)
he2<-c(180,45)
he3<-c(161,123)
msi1<-c(126,34)
msi2<-c(256,45)
msi3<-c(240,124)

#compute trafomatrix
t <- get.trafomatrix(he1,he2,he3,msi1,msi2,msi3) #he to msi matrix

#test coordinate conversion
pointer.he <- c(47,35)
pointer.msi <- get.msi(pointer.he,t)
pointer.he2 <- get.he(pointer.msi,t)

#test he image trafo to fit msi
test <- map.he.on.msi(he,msi,t)
display(test)

#test msi image trafo to fit he
test2 <- map.msi.on.he(he,msi,t)
display(test2)
