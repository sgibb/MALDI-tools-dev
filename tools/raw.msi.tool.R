source("lib/raw.msi.functions.R")

#input var
imzml = "data/miniTMA.imzml"
mz.start = 1000
mz.end = 2000
mz.step = 100
tolerance = 10
jpegfile="data/"

#load imzml data
s <- importImzMl(imzml)

#save jpeg sequence for film
mzseq <- seq(from = mz.start, to = mz.end, by = mz.step)
save.msi.seq(s, mzseq, tolerance, jpegfile)

#--> please make film from sequence ;-)