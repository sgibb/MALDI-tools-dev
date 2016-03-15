source("trafo_functions.R")

xy <- read.csv.uw("corresponding_coordinates.csv")

xy <- as.matrix(xy)
t  <- get.trafomatrix.from.matrix (xy) #he to msi matrix

write.csv.uw(t,"trafomatrix.csv")
