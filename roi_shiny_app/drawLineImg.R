switchFromOctantZeroTo<- function(octant, x, y) 
{
  coord<-NULL
  coord<-switch(octant+1, c(x,y), c(y,x), c(-y, x), c(-x, y), c(-x, -y), c(-y, -x), c(y, -x), c(x, -y)) 
return(coord)                
}


drawLineImg<-function (img, x1,y1,x2,y2)

{

  farb=0  
if (is.Image(img)== FALSE )
{
  return()
}
#if (is.integer(x1)==FALSE | is.integer(x2)==FALSE | is.integer(y1)==FALSE | is.integer(y2)==FALSE)
 #    { return("No valid index") }
  #if ((x1>dim(img)[1]) | (x2>dim(img)[1]))
  #{
   # return()
  #}
if ((y1>dim(img)[2]) | (y2>dim(img)[2]))
{
  return("Out of index")
}

 
x<<-x2-x1
y<<-y2-y1
dx<<-abs(x)
dy<<-abs(y)

img1<-img
img1[x1,y1,]=farb


if (dx==0)
{

	for (i in 1:dy)
	 	{
	  
		img1[x1, min(y1,y2)+i,]=farb
	
	}#End for

} #end if


else
  {
    if (dy==0)
      {
      	for (i in 1:dx)
      	  	{
      	  		img1[min(x1,x2)+i, y1,]=farb
      	  			}#end for
      } #end if
  
else
{
  if (dx>=dy)
    if (y>0&x>0) 
      {
      octant=0
      x0<-x
      y0<-y}
    else
    { 
      if (y>0&x<0)
        {
        octant=3
        x0<--x
        y0<-y
      }
      else
        {
        if (y<0&x<0){
          octant=4
          x0<--x
          y0<--y
          }
        else 
          {
            octant=7
            x0<-x
            y0<--y
            
          }
        }
    }
  else
  {
    if (y>0&x>0) 
      {
      octant=1
      x0<-y
      y0<-x
      }
    else
    {
      if (y>0&x<0) {
        octant=2
        x0<-y
        y0<--x}
      else 
        {
        if (y<0&x<0){
          octant=5
          x0<--y
          y0<--x}
        else 
          {
            octant=6
            x0<--y
            y0<-x
         }
        }
    }
  }
dx<<-abs(x0)
dy<<-abs(y0)
  
  D <- 2*dy - dx
  ya=0
  
  if (D > 0){
    ya <-ya+1
    D <- D - (2*dx)
  }
  for (xa in 1:dx)
  {
    img1[switchFromOctantZeroTo(octant, xa, ya)[1]+x1, switchFromOctantZeroTo(octant, xa, ya)[2]+y1, ]=farb
    D <- D + (2*dy)
    if (D > 0){
      ya <-ya+1
      D <-D - (2*dx)}
  }
} #end else
}#end else

return(img1)
}	

