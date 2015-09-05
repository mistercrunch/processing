int MINLENGTH;
float SPACE;
ArrayList lines;
int NBGEN;
float COLORSEED, COLORRANGE;
boolean PAUSED,RANDOMCOLOR;
PImage PIbase;
PGraphics PGmain;
FlickPics fPic;
void setup()
{  
  PAUSED=false;
  RANDOMCOLOR=false;
  size(800,800,P3D);
  //PGmain = createGraphics(width, height, OPENGL);

  cursor(CROSS);
  colorMode(HSB, 1);
  point(0,0);
  stroke(1);
  point(0,100);
  
  
  String [] tags = {"baconwood"};
  fPic = new FlickPics(tags,"b30b0348689790827bdfcfd8b64063bb", "81dee0709083d088");

  PIbase = loadImage(fPic.GetRandURL());
  
  PIbase = ResizeCrop(PIbase);
  ResetScreen();
  StartCross((int)random(width), (int)random(height));
  
}


void draw()
{
  if(!PAUSED)
  {
    //println(frameRate);
    int nbLines=0;
    ArrayList newLines = new ArrayList();
    for( Iterator it = lines.iterator(); it.hasNext(); )
    {
      nbLines++;
      Line theLine = (Line) it.next();
    
      if(theLine.isDead || theLine.gen > NBGEN)
      {
        it.remove(); 
        //println("removed!");    
      }
      else if(theLine.OutOfBonds())
      {
        it.remove(); 
      }
      else if(theLine.age > theLine.lifeSpan)
      {  
        newLines.add(new Line(theLine.gen+1, theLine.vPos.x, theLine.vPos.y, !theLine.vert, true, (int)(theLine.lifeSpan )));
        newLines.add(new Line(theLine.gen+1, theLine.vPos.x, theLine.vPos.y, !theLine.vert, false, (int)(theLine.lifeSpan )));
        //newLines.add(new Line(theLine.gen, theLine.vPos.x, theLine.vPos.y, theLine.vert, theLine.isPositive, (int)(theLine.lifeSpan )));
        theLine.Reset();
        //it.remove(); 
      } 
      else
      {
        theLine.Move();
        theLine.Display();
      }
    }
    for( Iterator it = newLines.iterator(); it.hasNext(); )
    {
      Line theLine = (Line) it.next();
      lines.add(theLine);
    }
   //println(nbLines);
   if(nbLines<200)
   {
     StartCross((int)random(width), (int)random(height));
     StartCross((int)random(width), (int)random(height));
     StartCross((int)random(width), (int)random(height));
     StartCross((int)random(width), (int)random(height));
   } 
  }
  //image(PGmain,0,0);
}

class Vect2d
{
  float x,y;
  
  Vect2d(float _x, float _y)
  {
    x = _x;
    y = _y;
  }
  
  Vect2d(float Range)
  {
    x = random(Range);
    y = random(Range);
  }
  
  void Add(Vect2d _v)
  {
    x+=_v.x;
    y+=_v.y;
  }
};

class Line
{
  int gen;
  boolean vert, isDead, isPositive;
  int inc;
  int age, lifeSpan;
  color c1;
  color c2;
  Vect2d vPos, vInc;
  float spillBase;
  
  Line(int _gen, float _x, float _y, boolean _vert, boolean _isPositive, int _Length)
  {
    spillBase= random(40);
    isPositive=_isPositive;
    isDead=false;
    gen = _gen;
    vPos = new Vect2d(_x, _y);
    vert = _vert;
    
    if(vert)
    {
      if(isPositive)
        vInc = new Vect2d(0, 1);
      else
        vInc = new Vect2d(0, -1);
    }
    else
    {
      if(isPositive)
        vInc = new Vect2d(1, 0);
      else
        vInc = new Vect2d(-1, 0);
    }
    c1 = GetColor();
    c2 = GetColor();
    lifeSpan = (int)((0.5 + random(0.8))*_Length);
    if(lifeSpan<MINLENGTH)
      lifeSpan=MINLENGTH;
    age =0;
  }
  void Reset()
  {
        age=0;
        c1 = GetColor();
        c2 = GetColor();
  }
  void GoToEnd()
  {
    while(!isDead)
    {
        Move();
        Display();
    }
  }
  color GetColor()
  {
    if(RANDOMCOLOR)
    {
      float _hue = COLORSEED+random(COLORRANGE);
      if(_hue>1)_hue-=1;
      return color(_hue, random(1),1);
    }
    else
    {
      return PIbase.get((int)vPos.x, (int)vPos.y);
    }
  }
  
  void Move()
  {
    
    
      vPos.Add(vInc);
      age++;
  }

  void Display()
  {
    
    if(get((int)vPos.x, (int)vPos.y) == color(0) || OutOfBonds())
      isDead=true;
    else
    {
      set((int)vPos.x, (int)vPos.y, color(0));
      if(!vert)
      {
        
        int i=1;
        //float spill = spillBase+random(spillBase);
        while( vPos.y-i >=0&&  get((int)vPos.x, (int)vPos.y-i) != color(0))
        {
          set((int)vPos.x, (int)vPos.y-i, c1);
          i++;
        }
         i=1;
        //float spill = spillBase+random(spillBase);
        while( vPos.y+i <=width&&  get((int)vPos.x, (int)vPos.y+i) != color(0))
        {
          set((int)vPos.x, (int)vPos.y+i, c2);
          i++;
        }
      }
    }
  }
  boolean OutOfBonds()
  {
    if(vPos.x<0 || vPos.x >= width || vPos.y<0 || vPos.y >= height)
      return true;
    else
      return false;
  }
};

void StartCross(int x, int y)
{
  lines.add(new Line(1, x-1, y, false, true, (int)random(100)+20));
  lines.add(new Line(1, x, y, false, false,(int) random(100)+20));
  lines.add(new Line(1, x, y, true, true, (int)random(100)+20));
  lines.add(new Line(1, x, y, true, false, (int)random(100)+20));
}

void mousePressed()
{
  StartCross(mouseX, mouseY);
}
void ToggleImage()
{
  
  image(PIbase,0,0);
  PAUSED=true;
}
void keyPressed()
{
  if (key==' ') ResetScreen();
  else if (key=='r') RANDOMCOLOR=!RANDOMCOLOR;
  else if (key=='i') ToggleImage();
  else if (key=='q')
  {
    for(int i=0; i<3000;i++)
    {
      StartCross((int)random(width), (int)random(height));   
    }
  }
  else if (key=='p')
  {
     for( Iterator it = lines.iterator(); it.hasNext(); )
    {
      Line theLine = (Line) it.next();
      theLine.GoToEnd();
    }  
    PAUSED = !PAUSED;
  }
}

void ResetScreen()  
{
    PIbase = fPic.GetMediumRandPic();
    PIbase = ResizeCrop(PIbase);
    PAUSED=false;
    COLORSEED= random(1);
    COLORRANGE= random(1);
    MINLENGTH = (int) random(20);
    NBGEN=10+(int)random(10);
    lines = new ArrayList();
    background(color(1));
}
PImage ResizeCrop(PImage _p)
{
  int newWidth,newHeight;
  float SreenWhRatio = (float)width/(float)height;
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
 _p.resize(width, height);
 return _p;

 //println(_p.width);

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
