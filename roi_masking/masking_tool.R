#the tool
#reads a jpeg b/w mask
#extracts x,y of pixels with value==x
#writes he (x,y,label) csv-table
#uses trafo-matrix.csv to transform
#he (x,y,label) csv-table to msi (x,y,label) csv-table
#writes msi (x,y,label) csv-table

source("masking_functions.R")
source("trafo_functions.R")

label = "ROI1"
value = 0
he.mask.jpg   = "he_mask1.jpg"
he.mask.file  = "ROI1.he.csv"
msi.mask.file = "ROI1.msi.csv"
trafo.matrix.file = "trafomatrix.csv"

#generate he coordinate lists from ROI masks
#as (x,y,label) table
he.mask<-readImage(he.mask.jpg)
xyl.he <- get.mask.xy(he.mask, value, label)
write.csv.uw(xyl.he, he.mask.file)

#get msi coordinate list from he coordinate list and trafo matrix
xyl.msi <- get.msi.mask(he.mask.file,trafo.matrix.file)
write.csv.uw(xyl.msi,msi.mask.file)
