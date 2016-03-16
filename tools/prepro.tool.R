source ("lib/masking_functions.R")
source ("lib/trafo_functions.R")
source("lib/raw.msi.functions.R")

##libraries
library (MALDIquant)
library (MALDIquantForeign)
#library (MASS)

#input var
imzml             <- "data/miniTMA.imzml"
tma.core.mask.jpg <- "data/tma.core.mask.jpg"
trafo.matrix.file <- "data/trafomatrix_iso.txt"

##open pdf
##pdf('$outfile_plots')

#read mask
tcm <- readImage(tma.core.mask.jpg)

#extract xy from tma.core.mask
value = 0
label = "tma.core.mask"
xyl.he <- get.mask.xy(tcm, value, label)
xyl.msi <- get.msi.mask(xyl.he,trafo.matrix.file)

#import core areas from imzml
print('reading masked pixels from imzml')
xy.msi <- as.matrix(xyl.msi[,1:2])
s <- importImzMl(path = imzml,
                 coordinates = xy.msi)

#check imported areas
#msi <- get.msi.matrix(s,center = 1000, tolerance = 10)
#save.msi.jpeg(msi,file = "data/imported.msi.jpg")

print('transforming spectra')
##transformation
st <- transformIntensity(s,
                         method="sqrt")

print('smooting spectra')
##smoothing
st <- smoothIntensity(st,
                      halfWindowSize=10)

print('removing baseline from spectra')
##remove baseline
st <- removeBaseline(st,
                     method="SNIP",
                     iterations=100)

print('calibrating spectra')
##calibrate
st <- calibrateIntensity(st, method="TIC")

print('aligning spectra')
##align spectra
st <- alignSpectra(st, 
                   halfWindowSize=20,
                   SNR=2,
                   tolerance=0.002,
                   warpingMethod="lowess")

##average technical replicates: example
##samples <- factor(sapply(spectra, function(x)metaData(x)$sampleName))
##avgSpectra <- averageMassSpectra(spectra, labels=samples, method="mean")

##save analysis results
#save(st, file="st.R")
exportImzMl(st, file="$outfile_imzml")



#---------------------to be next tool---------------------------
##detect and bin peaks
#peaks <- detectPeaks(st,
#                     method="MAD",
#                     halfWindowSize=20,
#                     SNR=2)
#bins <- binPeaks(peaks, 
#                 tolerance=binPeaks_tolerance)
#bins <- filterPeaks(bins, 
#                    minFrequency=0.25)
#save(peaks, file="peaks.R")
#save(bins, file="bins.R")


#closing plot
#dev.off()