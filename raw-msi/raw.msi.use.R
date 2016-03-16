source("msi_roi_functions.R")

#file="UFX151104_Mel_01_Lymphoma.imzML"
#s<-import(file)
#save(s,"s.RData")
#load("s.RData")
#ROIcoord <- c(629,124,762,189)

s <- importImzMl("miniTMA.imzml")
ROIcoord <- c(650,150,700,160)
center <- 1000
tolerance <- 10

msi <- get.msi.matrix(s,center, tolerance)
display(msi)
save.msi.jpeg(msi, file="msi.jpg")

roi <- get.roi.rectangle.spectra(s,ROIcoord)

msi.roi <- get.msi.matrix(roi,center, tolerance)
display(msi.roi)
save.msi.jpeg(msi.roi, file="msi.roi.jpg")


#------export and reimport smaller roi
exportImzMl(roi,
            path="roi.imzml")

roi <- importImzMl(path="roi.imzml",
            removeEmptySpectra = TRUE,
            massRange = c(1000,1050),    #export function has no massRange
            minIntensity = 0)

exportImzMl(roi,
            path="roi.imzml")
