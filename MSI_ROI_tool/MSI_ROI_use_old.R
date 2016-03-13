source("msi_roi_functions.R")

#file="UFX151104_Mel_01_Lymphoma.imzML"
#s<-import(file)
#save(s,"s.RData")
#load("s.RData")

ROIcoord <- c(629,124,762,189)
center <- 1000
tolerance <- 10

msi <- get.msi.matrix(s,center, tolerance)
display(msi)
save.msi.jpeg(msi, file="msi.jpg")

roi <- get.roi.rectangle.spectra(s,ROIcoord)

msi.roi <- get.msi.matrix(roi,center, tolerance)
display(msi.roi)
save.msi.jpeg(msi.roi, file="msi.roi.jpg")

exportImzMl(roi,
            path="roi.test.imzml")

roi.test <- importImzMl(path="roi.test.imzml",
            removeEmptySpectra = TRUE,
            massRange = c(1000,1050),
            minIntensity = 0)

exportImzMl(roi.test,
            path="roi.test.1000-50.imzml")

roi.test.part <- importImzMl(path="roi.test.1000-50.imzml",
                        removeEmptySpectra = TRUE,
                        minIntensity = 0)

roi.test.msi <- get.msi.matrix(roi.test.part,center,tolerance)
display(roi.test.msi)
save.msi.jpeg(msi.roi, file="msi.roi.test.1000-50.jpg")
