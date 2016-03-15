library (EBImage)
library (RNiftyReg)

get.mask.xy <- function (mask,value,label)
{
     mask <- as.array(mask)
     mask <- mask[,,1]
     xy <- which (mask==value, arr.ind = TRUE)
     xyl <- as.data.frame(cbind(xy,label))
     return(xyl)
}


get.msi.mask <- function (he.mask.file, trafo.matrix.file)
{
     #read ROI x,y,label table and trafo matrix from csv files
     t <- as.matrix(read.csv.uw(trafo.matrix.file))
     xyl.he <- read.csv.uw(he.mask.file)
     xy.he <- as.matrix(xyl.he[,1:2])
     
     #get ROI msi coordinates from he coordinates
     xy.msi <- xy.he
     for (i in 1:nrow(xy.he))
     {
          xy.msi[i,] <- round(get.msi(xy.he[i,],t))
     }
     xyl.msi <- as.data.frame(cbind(xy.msi,as.character(xyl.he[,3])))
     colnames(xyl.msi) <- c("x","y","label")
     return(xyl.msi)
}
