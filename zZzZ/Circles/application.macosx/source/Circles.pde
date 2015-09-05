/**
Crazy circles overlap!
 */
int nbCircles = 50;
int interval = 50;
int lastMillis = -1;
int curCircle = 0;
int MainColor=0;
Circle[] myCircles = new Circle[nbCircles];
boolean DrawingMode=false;
int millisMouseRelease = -10000;
int Mode=1;
void setup() {
  cursor(CROSS);
  stroke(0);
  size(800, 600);
  noFill();
  frameRate(26);
  fill(0);
  rect(0, 0, width, height);
  noFill();
  for (int i = 0;i<nbCircles;i++)
  {
    myCircles[i] = new Circle();
    myCircles[i].SetXY((int)random(width), (int)random(height));
  }
}



void draw() {
  MainColor +=20;
  if(MainColor >= ColorRange*6) MainColor %= ColorRange*6;
  if(MainColor < 0) MainColor = (ColorRange*3) - (abs(MainColor) % (ColorRange*3));
  
  noStroke();         
  fill(0,20);
  rect(0, 0, width, height);
  noFill();
  
  for (int i = 0;i<nbCircles;i++)
  {
    myCircles[i].CalcNextFrame();
    myCircles[i].Draw();
  }
  
  if (millis() > lastMillis+interval )
  {
    if(DrawingMode)
    {
      
      myCircles[curCircle].ResetToCursor();
    }
    else
    {
      if (millis() > millisMouseRelease+ 2000 )
      {
      myCircles[curCircle].Start();
      myCircles[curCircle].curSize=1;
      myCircles[curCircle].SetXY((int)random(width), (int)random(height));
      }
    }
    
    curCircle++;
    if (curCircle >=nbCircles) curCircle=0;
    lastMillis=millis();
  }
  
}
class rgb{
  int r,g,b;
};
class Circle{
  boolean Drawn;
  int x,y;
  int ColorAlpha;
  int curSize;
  rgb myRGB;
  int GrowSpeed;
  int maxSize;
  int ShapeMode;
  Circle()
  {
    
    curSize = 1;
    myRGB = new rgb();
    Start();
  }
  void SetXY(int myX, int myY)
  {
    x = myX;
    y = myY;
  }
  void Start()
  {
    ShapeMode=Mode;
    Drawn=false;
    ColorAlpha = 255;
    GimmePureColor((int)random(ColorRange*6),myRGB);
    GrowSpeed = (int)random(3) + 1;
    GrowSpeed = 2;
    maxSize = (int)random(600) + 100;
  }
  
  void ResetToCursor()
  {
    ShapeMode=Mode;
    Drawn=true;
    curSize = 1;
    x = mouseX;
    y = mouseY;
    GimmePureColor(MainColor,myRGB);
  }
  void CalcNextFrame()
  {
    //GimmePureColor(curRGB
    curSize = curSize+GrowSpeed;
    
    if (curSize > maxSize)
    {
      curSize=100000;
      //x = (int) random(width);
      //y = (int) random(height);
    }
  }
  void Draw()
  {
    stroke(myRGB.r,myRGB.g,myRGB.b);
    
    if(ShapeMode==1)
    {
      //Drawing many to fill missing pixels
      ellipse(x,y,curSize,curSize);
      ellipse(x+1,y,curSize,curSize);
      ellipse(x-1,y,curSize,curSize);
      ellipse(x,y+1,curSize,curSize);
      ellipse(x,y-1,curSize,curSize);
    }
    else if(ShapeMode==2)
    {
      int i = curSize/2;
      rect(x-i,y-i,curSize,curSize);
    }
  }
};

void mousePressed() 
{
  if(mouseButton==LEFT)
  {
    DrawingMode = true;
    for(int i=0; i<nbCircles; i++)
    {
      if(!myCircles[i].Drawn)
      myCircles[i].curSize=100000;
      //myCircles[i].SetXY((int)random(width), (int)random(height));
      //GimmePureColor((int)random(ColorRange*3),myCircles[i].myRGB);
    }
  }  
  else if(mouseButton==RIGHT)
  {
    NextMode();
  }
}

void NextMode()
{
  //1= Circle Ripple
  //2= Squares
  Mode++;
  if (Mode>2) Mode=1;
}
 	
void mouseReleased()
{
  
  if(mouseButton==LEFT)
  {
    DrawingMode = false;
    millisMouseRelease = millis();
  }

}

int ColorRange = 256;
void GimmePureColor(int iSpot, rgb myRGB)
{
           
           int x = abs(iSpot % ColorRange);
           
           if (iSpot <ColorRange){
           //Red to yellow
                  myRGB.r = ColorRange-1;
                  myRGB.g = x;
                  myRGB.b = 0;
           }
           else if (iSpot <ColorRange*2)
           {

                  myRGB.r = ColorRange-x;
                  myRGB.g = ColorRange - 1;
                  myRGB.b = 0;
           }else if (iSpot <ColorRange*3)
           {
                  myRGB.r = 0;
                  myRGB.g = ColorRange - 1;
                  myRGB.b = x;
           }
           else if (iSpot <ColorRange*4)
           {
           //Turquoise to blue
                  myRGB.r = 0;
                  myRGB.g = ColorRange - x;
                  myRGB.b = ColorRange - 1;
           }else if (iSpot <ColorRange*5)
           {
                  myRGB.r = x;
                  myRGB.g = 0;
                  myRGB.b = ColorRange - 1;
           }else if (iSpot <ColorRange*6)
           {
                  myRGB.r = ColorRange - 1;
                  myRGB.g = 0;
                  myRGB.b = ColorRange - x;
           }     
}


