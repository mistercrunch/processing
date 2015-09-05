void setup()
{
  size(900,570);
  smooth();
  colorMode(HSB);
  background(0);
  noStroke();
  PImage b;
  b = loadImage("http://www.shanandmax.com/img/MaxShanMountainBorder.jpg");
  image(b, 50, 50);
  for(int i=0;i<500;i++)
     drawOne();
}

void draw()
{
    fill(255,2);
   //rect(0,0,width,height);
    frameRate(30);
   for(int i=0;i<10;i++)
     drawOne();
 
   

}
void drawOne()
{
    println(frameRate);
    boolean done=false;
    while(!done)
    {
      int x =(int)random(width);
      int y =(int)random(height);
      if(IsClear(x,y))
      {
        drawCircle(x,y,20);
        //drawCircle(x+intRand(5),y+intRand(5),30);
        //drawCircle(x+intRand(5),y+intRand(5),15);
        drawCircle(x,y,10);
        drawCircle(x,y,5);
        done=true;
      }
    }
}
void drawCircle(int x, int y, float sizeSeed)
{
  int size = (int)sizeSeed+ (int)random(sizeSeed/2);
    fill(color(random(255), 255, 55+ (int)random(300)));
    ellipse(x,y,size, size);
}
int intRand(float r)
{
   return (int)random(r);
}
/*
boolean IsClear(int x,int y, int size)
{
  boolean flag=true;
  for(int xx = x-size; xx<x+size; xx++)
  {
    for(int yy = y-size; yy<y+size; yy++)
    {
      if(get(xx,yy) != color(0)) flag= false;
    }
  }
  return flag;
}*/

boolean IsClear(int x,int y)
{
  int margin=40;
  int frameSize=20;
  if(
      (
        ((x>margin && x<frameSize+margin) || (x>width-(frameSize+margin) && x<width-margin)) &&
        y>margin && y<height-margin
      ) 
    || 
      (
        ((y>margin && y<frameSize+margin) || (y>height-(frameSize+margin) && y<height-margin)) &&
        x>margin && x<width-margin
      ) 
    )
    return true;
  else
    return false;
}
