## reading magic big sequence from XML file: python -c "print [ '%02X '
##% ord( x ) for x in open('infile.ibd', 'rb').read(16) ]"

##libraries
library (MALDIquant)
library (MALDIquantForeign)
library(MASS)

##open pdf
pdf('$outfile_plots')

print('Reading')
##import imzML file
s<-import( 'infile.imzML', type="imzML" )
##s <- importMzMl( './infile.imzML' )

print('sclicing')
##slices <- msiSlices(s, center=290)
##slices <- msiSlices(s, center=2900, tolerance=10, method="median")
##plotMsiSlice(slices)
##title(main = 'Original')

print('transforming')
##transformation
st <- transformIntensity(s, method="sqrt")
slices <- msiSlices(st, center=2900, tolerance=10, method="median")
plotMsiSlice(slices)
print('smooting')
##smoothing
st <- smoothIntensity(st, halfWindowSize=10)
slices <- msiSlices(st, center=2900, tolerance=10, method="median")
plotMsiSlice(slices)
print('baseline removing')
##remove baseline
st <- removeBaseline(st, method="SNIP", iterations=100)
slices <- msiSlices(st, center=2900, tolerance=10, method="median")
plotMsiSlice(slices)
print('calibrate')
##calibrate
st <- calibrateIntensity(st, method="TIC")
slices <- msiSlices(st, center=2900, tolerance=10, method="median")
plotMsiSlice(slices)

print('align')
##align spectra
st <- alignSpectra(st, halfWindowSize=20,SNR=2, tolerance=0.002,
warpingMethod="lowess")
slices <- msiSlices(st, center=2900, tolerance=10, method="median")
plotMsiSlice(slices)


##average technical replicates: example
##samples <- factor(sapply(spectra, function(x)metaData(x)$sampleName))
##avgSpectra <- averageMassSpectra(spectra, labels=samples, method="mean")

##detect and bin peaks
peaks <- detectPeaks(st, method="MAD", halfWindowSize=20, SNR=2)
plot(st[[1]], xlim=c(4000, 5000), ylim=c(0, 0.002))
points(peaks[[1]], col="red", pch=4)
bins <- binPeaks(peaks, tolerance=$binPeaks_tolerance)
write.matrix(bins, file = "$outfile_tabular", sep = "\t")
#if $filterPeaks:
bins <- filterPeaks(bins, minFrequency=0.25)
#end if
print('create intensities')
##create intensity matrix
imatrix <- intensityMatrix(bins, st)
##write.matrix(bins, file = "$outfile_tabular", sep = "\t")
##define groups
##classes <- factor(ifelse(cancer, "cancer",
"control"),levels=c("cancer", "control"))

##plot heatmap
imatrixasm <- t(as.matrix(imatrix))
heatmap(imatrixasm)

##save analysis results
save(st, file="st.R")

save(bins, file="bins.R")
save(peaks, file="peaks.R")

exportImzMl(st, file="$outfile_mzml")

#closing plot
dev.off()