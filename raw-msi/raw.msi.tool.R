source("raw.msi.functions.R")

#input var
imzml = "miniTMA.imzml"
mz.start = 1000
mz.end = 2000
mz.step = 100
tolerance = 10

#load imzml data
s <- importImzMl(imzml)

#save jpeg sequence for film
mzseq <- seq(from = mz.start, to = mz.end, by = mz.step)
save.msi.seq(s, mzseq, tolerance)

#--> please make film from sequence ;-)