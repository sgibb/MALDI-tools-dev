source("lib/trafo_functions.R")

#input
cc <- "data/corresponding_coordinates.txt"
trafo.matrix.file <- "data/trafomatrix.txt"

xy <- read.tab.uw(cc)
xy <- as.matrix(xy)
t  <- get.trafomatrix.from.matrix (xy) #he to msi matrix

write.tab.uw(t,trafo.matrix.file)
