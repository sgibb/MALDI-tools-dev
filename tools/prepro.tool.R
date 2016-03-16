source ("lib/masking_functions.R")
source ("lib/trafo_functions.R")
source("lib/raw.msi.functions.R")

##libraries
library (MALDIquant)
library (MALDIquantForeign)
#library (MASS)

#input var
imzml <- "data/miniTMA.imzml"
tma.core.mask.jpg <- "data/tma.core.mask.jpg"

##open pdf
##pdf('$outfile_plots')

#read mask
tcm <- readImage(tma.core.mask.jpg)

#extract xy from tma.core.mask
value = 0
label = "tma.core.mask"
tcm.xyl <- get.mask.xy(tcm, value, label)
write.tab.uw(tcm.xyl, file = paste("data/",label,".he.txt",sep = ""))

#transform he mask to msi mask
he.mask.file="data/tma.core.mask.he.txt"
msi.mask.file="data/tma.core.mask.msi.txt"
trafo.matrix.file="data/trafomatrix_iso.txt"
xyl.msi <- get.msi.mask(he.mask.file,trafo.matrix.file)
write.tab.uw(xyl.msi,msi.mask.file)

#import core areas from imzml
msi.mask.file="data/tma.core.mask.msi.txt"
tcm.xyl <- read.tab.uw(msi.mask.file)
tcm.xy <- as.matrix(tcm.xyl[,1:2])

print('Reading')
#import imzml
s <- importImzMl(path = imzml,
                 coordinates = tcm.xy)

msi <- get.msi.matrix(s,center = 1000, tolerance = 10)
save.msi.jpeg(msi,file = "data/imported.msi.jpg")

print('transforming')
##transformation
st <- transformIntensity(s,
                         method="sqrt")


print('smooting')
##smoothing
st <- smoothIntensity(st,
                      halfWindowSize=10)


print('baseline removing')
##remove baseline
st <- removeBaseline(st,
                     method="SNIP",
                     iterations=100)


print('calibrate')
##calibrate
st <- calibrateIntensity(st, method="TIC")


print('align')
##align spectra
st <- alignSpectra(st, 
                   halfWindowSize=20,
                   SNR=2,
                   tolerance=0.002,
                   warpingMethod="lowess")


##average technical replicates: example
##samples <- factor(sapply(spectra, function(x)metaData(x)$sampleName))
##avgSpectra <- averageMassSpectra(spectra, labels=samples, method="mean")


##detect and bin peaks
peaks <- detectPeaks(st,
                     method="MAD",
                     halfWindowSize=20,
                     SNR=2)

bins <- binPeaks(peaks, 
                 tolerance=$binPeaks_tolerance)

#bins <- filterPeaks(bins, 
#                    minFrequency=0.25)


##save analysis results
exportImzMl(st, file="$outfile_imzml")
save(st, file="st.R")
save(peaks, file="peaks.R")
save(bins, file="bins.R")

#closing plot
dev.off()