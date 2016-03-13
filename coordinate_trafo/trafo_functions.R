library (EBImage)
library (RNiftyReg)

read.csv.uw <- function(file)
{
     return (data.frame(read.csv(
          file, header = TRUE, sep = ",", 
          quote = "\"", dec = ".", 
          fill = TRUE, comment.char = "")))
}

write.csv.uw <- function(dataframe, file)
{
     write.table(dataframe,file,
            append=FALSE,quote=TRUE,sep=",",eol="\n",na="NA",dec=".",
            row.names=FALSE,col.names=FALSE,
            qmethod=c("escape", "double"),fileEncoding="")
}

#compute trafomatrix
#by convention for trafo of he to msi coordinates
#from 3 corresponding pointers in images p(he),q(msi)
#to use matrix for coordinate trafo see functions get.msi/get.he:

get.trafomatrix <- function (p1,p2,p3,q1,q2,q3)

{

  a=matrix(c(p1,1,1,p2,1,1,p3,1,1,p3,2,1), ncol=4, byrow=TRUE)
  b=matrix(c(q1,1,1,q2,1,1,q3,1,1,q3,2,1), ncol=4, byrow=TRUE)
  
  return(t(solve(a,b)))
}	

#compute trafomatrix from matrix of corresponding coordinates
#matrix layout:
#first 3 rows = xy in he, next 3 rows = xy in msi
get.trafomatrix.from.matrix <- function (m)
     
{
     
     a=matrix(c(m[1,],1,1,m[2,],1,1,m[3,],1,1,m[3,],2,1), ncol=4, byrow=TRUE)
     b=matrix(c(m[4,],1,1,m[5,],1,1,m[6,],1,1,m[6,],2,1), ncol=4, byrow=TRUE)
     
     return(t(solve(a,b)))
}	



#get coordinates in msi as vector (x,y) by trafomatrix
get.msi <- function(pointer.he,trafomatrix)
{
     pointer.he <- c(pointer.he,1,1)
     pointer.msi <- trafomatrix %*% pointer.he
     return(pointer.msi[1:2])
}

#get coordinates in he as vector (x,y) by trafomatrix
get.he <- function(pointer.msi,trafomatrix)
{
     pointer.msi <- c(pointer.msi,1,1)
     inverse.trafomatrix <- solve(trafomatrix)
     pointer.he <- inverse.trafomatrix %*% pointer.msi
     return(pointer.he[1:2])
}



#transform he image to fit msi
#using transformation matrix
map.he.on.msi <- function(imgHE, imgMSI, trans)

{
if (!is.Image(imgHE)|!is.Image(imgMSI)) {stop("Input not of class Image.")}
else if (!isAffine(trans)) {stop("Transformation not affine.")}
  else
{
  tr=solve(trans)
  writeAffine(tr,"aff")
  tr=readAffine("aff", target=imgMSI, source=imgHE)
  img=applyTransform(tr, imgHE)
  img=as.Image(img)
  colorMode(img)="color"
  return(img)
}

}


#transform msi image to fit he
#using transformation matrix
map.msi.on.he<-function(imgHE, imgMSI, trans)
  
{
  if (!is.Image(imgHE)|!is.Image(imgMSI)) {stop("Input not of class Image.")}
  else if (!isAffine(trans)) {stop("Transformation not affine.")}
  else
  {
    tr=trans
    writeAffine(tr,"aff")
    tr=readAffine("aff", target=imgHE, source=imgMSI)
    img=applyTransform(tr, imgMSI)
    img=as.Image(img)
    colorMode(img)="color"
    return(img)
  }
  
}
