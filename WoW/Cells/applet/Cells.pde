//import processing.opengl.*;
//import javax.media.opengl.*;
//import com.sun.opengl.util.texture.*;

int cellSize=10;
PImage piBase;
Cell [][] cells;

FlickPics f;
boolean SHOWORIGINAL = false;
boolean PAUSED =false;
int MARGIN=150;

boolean MouseMoved=false;
long MouseLastMoved=0;

int nbHorCells, nbVerCells;
void setup()
{
  
  size(800,800, P3D);
  loadingScreen();
  String [] tags = {"burningman"};
  f = new FlickPics(tags,"b30b0348689790827bdfcfd8b64063bb", "81dee0709083d088");
  frameRate(40);  
  SetImage();
}

void loadingScreen()
{

  background(0);
  fill(255);
  ellipse(width/2, height/2, 20,20);
  ellipse((width/2)-50, height/2, 20,20);
  ellipse((width/2)+50, height/2, 20,20);
}
void SetImage()
{
  loadingScreen();
  PAUSED=false;
  cellSize=7+(int)random(20);
  cells = new Cell[(width/cellSize)][(height/cellSize)];
  piBase = ResizeCrop(f.GetMediumRandPic(), (width-(MARGIN*2)),(height-(MARGIN*2)));
  nbHorCells = ((width-(MARGIN*2)) / cellSize);
  nbVerCells = ((height-(MARGIN*2)) / cellSize);
  //piBase.resize();
 

  for(int x = 0; x<(width/cellSize); x++)
  {
    for(int y = 0; y<(height/cellSize); y++)
    {
      cells[x][y]=new Cell(PIPart(piBase, x*cellSize,(x*cellSize)+cellSize, y*cellSize,(y*cellSize)+cellSize), new Vect2d((x*cellSize)+MARGIN,(y*cellSize)+MARGIN));
    }
  }
}
void draw()
{
  println(frameRate);
  background(0);
  if(SHOWORIGINAL)image(piBase,MARGIN,MARGIN);

  if(mouseX != pmouseX || mouseY != pmouseY)
  {
    MouseMoved=true;
    MouseLastMoved=millis();
  }
  else if (millis()-MouseLastMoved>500)
  { 
    MouseMoved = false;
  }
  for(int x = 0; x<nbHorCells; x++)
  {
    for(int y = 0; y<nbVerCells; y++)
    {
      if(!PAUSED)
      {
        cells[x][y].AdjustVel();
        cells[x][y].Move();
      }
      cells[x][y].Blend();
    }
  }
}
void StopMovement()
{
  for(int x = 0; x<(width/cellSize); x++)
    {
      for(int y = 0; y<(height/cellSize); y++)
      {
        cells[x][y].v2dVel = new Vect2d(0,0);
        cells[x][y].v2dCur.Match(cells[x][y].v2dOrigin);
      }
    }
}
void keyPressed()
{
  if(key==' ')SetImage();
  else if(key=='i')SHOWORIGINAL=!SHOWORIGINAL;
  else if(key=='s')StopMovement();
  else if(key=='p')PAUSED=!PAUSED;
}
PImage PIPart(PImage _p, int xStart, int xEnd, int yStart, int yEnd)
{
  PImage PItmp = new PImage(xEnd-xStart, yEnd-yStart);
  
  for(int x=xStart; x<xEnd;x++)
    {
      for(int y=yStart; y<yEnd;y++)
      {
        PItmp.set(x-xStart,y-yStart, _p.get(x,y));
      }
    }
   return(PItmp);
}
class Cell
{
  PImage pImg;
  Vect2d v2dCur, v2dOrigin, v2dVel;
  int ConfortDistance;
  
  Cell(PImage _p, Vect2d v)
  {
    pImg = _p;
    v2dOrigin = v.Clone();
    v2dCur = v.Clone();
    v2dVel= new Vect2d(0,0);
    ConfortDistance=(int)random(20)+5;
  }
  void Blend()
  {
    blend(pImg, 0,0, cellSize, cellSize, (int)v2dCur.x, (int)v2dCur.y, cellSize, cellSize, ADD);   
  }
  
  void AdjustVel()
  {
    Vect2d v2dMouse = new Vect2d(mouseX, mouseY);
    Vect2d v2dMouseDist = v2dCur.Sub(v2dMouse);
    
    float mouseDistance = v2dMouseDist.Distance();
    if(MouseMoved)
    {  
      v2dMouseDist.Div(mouseDistance);
      v2dVel.Add(v2dMouseDist);
    }
    
    Vect2d v = v2dOrigin.Sub(v2dCur);
    v.Div(100);
    v2dVel.Add(v);
    v2dVel.Div(1.02);
    if(v2dVel.Distance()<0.5 && v2dOrigin.Distance(v2dCur) < 0.5) 
    {
      v2dVel.x=0;
      v2dVel.y=0;
      v2dCur = v2dOrigin.Clone();
    }
    
  }
  void Move()
  {
    v2dCur.Add(v2dVel);
  }
}


PImage ResizeCrop(PImage _p, int w, int h)
{
  int newWidth,newHeight;
  float SreenWhRatio = (float)w/(float)h;
  float PicWhRatio = (float)_p.width/(float)_p.height;

  if(PicWhRatio > SreenWhRatio)
  {
    newWidth=(int)(((float)_p.width)/(PicWhRatio/SreenWhRatio));
    newHeight=_p.height;
    _p = PIPart(_p, (_p.width- newWidth)/2, _p.width-((_p.width- newWidth)/2), 0, _p.height);
    
  }
  else
  {
    newHeight=(int)(_p.height*(PicWhRatio/SreenWhRatio));
    newWidth=_p.width;
    _p = PIPart(_p, 0, _p.width, (_p.height- newHeight)/2, _p.height-((_p.height- newHeight)/2));
     
  }
 // println(newWidth);
 // println(newHeight);
 //p = null;
 //_p = PIPart(_p, 500,1000,500,1000);
 _p.resize(w, h);
 return _p;

 //println(_p.width);

}


