library (EBImage)
library (RNiftyReg)
#library (jpeg)


#compute transformation matrix
#from 3 corresponding pointers in images p,q
#use resulting matrix for coordinate trafo:
#corresponding pointer in p (x,y,1,1) <- pointer in q (x,y,1,1) %*% matrix
#for inverse trafo use matrix returned by solve(matrix)
trafo <- function (p1,p2,p3,q1,q2,q3)

{

  a=matrix(c(p1,1,1,p2,1,1,p3,1,1, p3,2,1), ncol=4, byrow=TRUE)
  b=matrix(c(q1,1,1,q2,1,1,q3,1,1,q3,2,1), ncol=4, byrow=TRUE)
  
  return(t(solve(a,b)))
}	


#transform he image to fit msi
#using transformation matrix from trafo function
heToMsi<-function(imgHE, imgMSI, trans)

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
#using transformation matrix from trafo function
msiToHE<-function(imgHE, imgMSI, trans)
  
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
