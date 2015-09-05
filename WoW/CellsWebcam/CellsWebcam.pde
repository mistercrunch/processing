//import processing.opengl.*;
//import javax.media.opengl.*;
//import com.sun.opengl.util.texture.*;
import processing.opengl.*;
import codeanticode.gsvideo.*;


int cellSize=10;
PImage piBase;
Cell [][] cells;


boolean PAUSED =false;
int MARGIN=150;

boolean MouseMoved=false;
long MouseLastMoved=0;
GSCapture video;
int nbHorCells, nbVerCells;

boolean LOCKED=true;
String Command="Init";
void setup()
{
  size(800,800, P2D);
  
  video = new GSCapture(this, 640, 480, 30);
  //cursor(WAIT);
  cursor(CROSS);

  
  frameRate(40);  
  cursor(WAIT);
  PAUSED=false;
  cellSize=5+(int)random(10);
  cells = new Cell[(width/cellSize)][(height/cellSize)];
  nbHorCells = ((width-(MARGIN*2)) / cellSize);
  nbVerCells = ((height-(MARGIN*2)) / cellSize);
  //piBase.resize();
 

  for(int x = 0; x<(width/cellSize); x++)
  {
    for(int y = 0; y<(height/cellSize); y++)
    {
      PImage tmp = new PImage();
      cells[x][y]=new Cell(PIPart(tmp, x*cellSize,(x*cellSize)+cellSize, y*cellSize,(y*cellSize)+cellSize), new Vect2d((x*cellSize)+MARGIN,(y*cellSize)+MARGIN));
    }
  }
  cursor(CROSS);
}
void loadingScreen()
{
  background(0);
  fill(255);
  ellipse(width/2, height/2, 20,20);
  ellipse((width/2)-50, height/2, 20,20);
  ellipse((width/2)+50, height/2, 20,20);
}

void draw()
{
    //println(frameRate);
    background(0);
   

    if(mouseX != pmouseX || mouseY != pmouseY)
    {
      MouseMoved=true;
      MouseLastMoved=millis();
    }
    else if (millis()-MouseLastMoved>500)
    { 
      MouseMoved = false;
    }
    
    if (video.available()) {  
       video.read();
       
    }
    
    for(int x = 0; x<nbHorCells; x++)
    {
      for(int y = 0; y<nbVerCells; y++)
      {
        
          cells[x][y].pImg = PIPart(video, x*cellSize,(x*cellSize)+cellSize, y*cellSize,(y*cellSize)+cellSize);
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
  if(key=='s')StopMovement();
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


