library(abind)
switchFromOctantZeroTo<- function(octant, x, y) 
{
  coord<-NULL
  coord<-switch(octant+1, c(x,y), c(y,x), c(-y, x), c(-x, y), c(-x, -y), c(-y, -x), c(y, -x), c(x, -y)) 
return(coord)                
}


drawLine<-function (x1,y1,x2,y2)

{

x<-x2-x1
y<-y2-y1
dx<-abs(x)
dy<-abs(y)
coords<-c(x1,y1)

if (dx==0)
{
 if (dy==0)
 {return (coords)}
  else
  {
  
  
	for (i in 1:dy)
	 	{
		coords<-append(coords, c(x1, min(y1,y2)+i) ) 
		}
return(coords)
} 
}
else
  {
    if (dy==0)
      {
      	for (i in 1:dx)
      	  	{
      	  coords<-append(coords, c(min(x1,x2)+i, y1) )		
      	       	  			}
      return(coords)
      } 
  
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
dx<-abs(x0)
dy<-abs(y0)
  
  D <- 2*dy - dx
  ya=0
  
  if (D > 0){
    ya <-ya+1
    D <- D - (2*dx)
  }
  for (xa in 1:dx)
  {
    coords <-append(coords, c(switchFromOctantZeroTo(octant, xa, ya)[1]+x1, switchFromOctantZeroTo(octant, xa, ya)[2]+y1))    
    D <- D + (2*dy)
    if (D > 0){
      ya <-ya+1
      D <-D - (2*dx)}
  }
  return(coords) 
} 
   
}

}	

