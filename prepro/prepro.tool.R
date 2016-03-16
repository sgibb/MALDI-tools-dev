source ("masking_functions.R")
source ("trafo_functions.R")
source("raw.msi.functions.R")

##libraries
library (MALDIquant)
library (MALDIquantForeign)
#library (MASS)

#input var
imzml <- "miniTMA.imzml"
tma.core.mask.jpg <- "tma.core.mask.jpg"

##open pdf
pdf('$outfile_plots')

#read mask
tcm <- readImage(tma.core.mask.jpg)

#extract xy from tma.core.mask
value = 0
label = "tma.core.mask"
tcm.xyl <- get.mask.xy(tcm, value, label)
write.csv.uw(tcm.xyl, file = paste(label,".he.csv",sep = ""))

#transform he mask to msi mask
he.mask.file="tma.core.mask.he.csv"
msi.mask.file="tma.core.mask.msi.csv"
trafo.matrix.file="trafomatrix.csv"
xyl.msi <- get.msi.mask(he.mask.file,trafo.matrix.file)
write.csv.uw(xyl.msi,msi.mask.file)

#import core areas from imzml
msi.mask.file="tma.core.mask.msi.csv"
tcm.xyl <- read.csv.uw(msi.mask.file)
tcm.xy <- as.matrix(tcm.xyl[,1:2])

print('Reading')
#import imzml
s <- importImzMl(path = imzml,
                 coordinates = tcm.xy)

#msi <- get.msi.matrix(s,center = 1000, tolerance = 10)
#save.msi.jpeg(msi,file = "imported.msi.jpg")

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

write.matrix(bins, 
             file = "$outfile_tabular", 
             sep = "\t")

bins <- filterPeaks(bins, 
                    minFrequency=0.25)


##save analysis results
exportImzMl(st, file="$outfile_imzml")
save(st, file="st.R")
save(peaks, file="peaks.R")
save(bins, file="bins.R")

#closing plot
dev.off()