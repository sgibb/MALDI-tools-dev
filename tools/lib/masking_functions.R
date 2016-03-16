library (EBImage)
library (RNiftyReg)

get.mask.xy <- function (mask,value,label)
{
     mask <- as.array(mask)
     mask <- mask[,,1]
     xy <- which (mask==value, arr.ind = TRUE)
     xy <- data.frame (xy)
     xyl <- cbind(xy,label)
     colnames(xyl) <- c("x","y","label")
     return(xyl)
}


get.msi.mask <- function (xyl.he, trafo.matrix.file)
{
     xy.he <- as.matrix(xyl.he[,1:2])
     t <- as.matrix(read.tab.uw(trafo.matrix.file))
     
     #get ROI msi coordinates from he coordinates
     xy.msi <- xy.he
     for (i in 1:nrow(xy.he))
     {
          xy.msi[i,] <- round(get.msi(xy.he[i,],t))
     }
     xy.msi <- data.frame (xy.msi)
     xyl.msi <- cbind(xy.msi,as.character(xyl.he[,3]))
     colnames(xyl.msi) <- c("x","y","label")
     return(xyl.msi)
}
