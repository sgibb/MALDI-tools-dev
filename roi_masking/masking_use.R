source("masking_functions.R")
source("trafo_functions.R")

he<-readImage("he.jpg")
msi<-readImage("msi.jpg")
he.mask1<-readImage("he_mask1.jpg")
he.mask2<-readImage("he_mask2.jpg")

display(he)
display(msi)
display(he.mask1)
display(he.mask2)

#generate he coordinate lists from ROI masks
#as (x,y,label) table

value = 0
label = "ROI1"
xyl1 <- get.mask.xy(he.mask1, value, label)
write.csv.uw(xyl1, file = paste(label,".he.csv",sep = ""))

value = 0
label = "ROI2"
xyl2 <- get.mask.xy(he.mask2, value, label)
write.csv.uw(xyl2, file = paste(label,".he.csv",sep = ""))

#get msi coordinate list from he coordinate list and trafo matrix

trafo.matrix.file="trafomatrix.csv"
he.mask.file="ROI1.he.csv"
msi.mask.file="ROI1.msi.csv"
xyl.msi <- get.msi.mask(he.mask.file,trafo.matrix.file)
write.csv.uw(xyl.msi,msi.mask.file)
