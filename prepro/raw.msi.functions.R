library (devtools)
library (MALDIquant)
library (MALDIquantForeign)
library (EBImage)

save.msi.seq <- function(s, mzseq, tolerance)
{
     for (center in mzseq)
     {
          msi <- get.msi.matrix(s, center, tolerance)
          save.msi.jpeg(msi, 
                        file=paste("msi-",center,".jpg",sep = ""))
     }
}


#generate matrix from msi
get.msi.matrix <- function (roi, center, tolerance)
{
  slices <- msiSlices(roi,
                      center,tolerance,
                      method="median",
                      adjust = FALSE)   #!include empty spectra/pixel

  #REM: slices contain only pixels within maximum of x,y in s
  
  #coerction to matrix
  msi <- as.data.frame(slices)
  msi <- as.matrix(msi)

  #expand matrix to full size of maldi scan
  m <- metaData(roi[[1]])
  xysize <- m$imaging$size
  x <- xysize[1]
  y <- xysize[2]
  msi.all <- matrix (nrow=x, ncol=y)        #REM: x=rows, y=col
  msi.all [1:nrow(msi),1:ncol(msi)] <- msi
  
  return(msi.all)
}


save.msi.jpeg <- function (msimatrix, file)
{
  writeImage(msimatrix,type = "jpeg", file=file)
}



get.roi.rectangle.spectra <- function (s, ROIcoord)
  #function extracts spectra from s within rectangle 
  #with coordinates of ROIcoord (x1,y1,x2,y2)
{
  #extract metadata from first pixel
  m <- metaData(s[[1]])
  xysize <- m$imaging$size
  xsize <- xysize[1]
  ysize <- xysize[2]
  xypos <- m$imaging$pos
  xpos <- xypos[1]
  ypos <- xypos[2]
  nspectra <- length(s)
  
  #extract list indices of all pixels in ROI from s
  ROIindexlist <- NULL
  i=1; while (i<nspectra+1)
    {
    
    m <- metaData(s[[i]])
    xypos <- m[[1]]$pos
    xpos <- xypos[1]
    ypos <- xypos[2]
    
    if (xpos>=ROIcoord[1])
      {if (xpos<=ROIcoord[3])
        {if (ypos>=ROIcoord[2])
          {if (ypos<=ROIcoord[4])
            {ROIindexlist <- c(ROIindexlist,i)
      }}}}
    i<-i+1
    }
  
  #extract ROI spectra from s by list of indices
  ROI<-NULL
  i=1; while (i<length(ROIindexlist)+1)
  {
    ROI<-c(ROI,s[[ROIindexlist[i]]]);i<-i+1
  }
  return(ROI)
}
