
boolean locked = false;
long LastEventMillis;
RectButton btnColorEraseMode;
int ColorEraseMode=0;

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
  btnColorEraseMode     = new RectButton(10, 10, 30, color(150), color((int)random(255),255,255));
  
  cursor(CROSS);
  stroke(0);
  size(600, 600);
  noFill();
  frameRate(40);
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
  strokeWeight(4);
  //println(frameRate);
  MainColor +=20;
  if(MainColor >= ColorRange*6) MainColor %= ColorRange*6;
  if(MainColor < 0) MainColor = (ColorRange*3) - (abs(MainColor) % (ColorRange*3));
  
  noStroke();
  if(ColorEraseMode==0)  
    fill(0,20);
  else if(ColorEraseMode==1)
    fill(0);
  else if(ColorEraseMode==2)
    fill(0,0);
    
  rect(0, 0, width, height);
  noFill();
  
  for (int i =0;i<nbCircles;i++)
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
  
  strokeWeight(2);
  btnColorEraseMode.display();
  ButtonEvents(mouseX, mouseY);
}

void ButtonEvents(int x, int y)
{
  if(locked == false) {
    btnColorEraseMode.update();
  } 
  else {
    locked = false;
  }
  if(mousePressed && millis() - LastEventMillis > 200) {
    boolean EventHappened = false;
    if(btnColorEraseMode.pressed()) {
      background(0);
      ColorEraseMode++;
      if (ColorEraseMode>2)ColorEraseMode=0;
      EventHappened = true;
    }
    if (EventHappened)
    {
      LastEventMillis = millis();
    }
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
  boolean isEnabled;
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
    isEnabled=true;
    ShapeMode=Mode;
    Drawn=false;
    GimmePureColor((int)random(ColorRange*6),myRGB);
    //GrowSpeed = (int)random(3) + 1;
    GrowSpeed = 2;
    maxSize = (int)random(600) + 100;
  }
  
  void ResetToCursor()
  {
    isEnabled=true;
    ShapeMode=Mode;
    Drawn=true;
    curSize = 1;
    x = mouseX;
    y = mouseY;
    GimmePureColor(MainColor,myRGB);
  }
  void CalcNextFrame()
  {
    curSize = curSize+GrowSpeed;
    
    if (curSize > maxSize)
    {
      isEnabled=false;
    }
  }
  void Draw()
  {
    smooth();
    if (isEnabled)
    {
      stroke(myRGB.r,myRGB.g,myRGB.b);
      if(ShapeMode==1)
      {
        //Drawing many to fill missing pixels
        //strokeWeight(1);
        ellipse(x,y,curSize,curSize);
        
        
      }
      else if(ShapeMode==2)
      {
        noSmooth();
        int i = curSize/2;
        rect(x-i,y-i,curSize,curSize);  
      }
      else if(ShapeMode==3)
      {
        float i = curSize * cos(3.14/3);
        //rect(x-i,y-i,curSize,curSize);
        triangle(x, y - curSize,x - i, y +i, x+i, y+i);
      }
      else if(ShapeMode==4)
      {
        line((x-(100))+curSize,y+curSize,(x+(100))-curSize,y-curSize);
      }
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
  if (Mode>4) Mode=1;
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


class Button
{
  int x, y;
  int size;
  color basecolor, highlightcolor;
  color currentcolor;
  boolean over = false;
  boolean pressed = false;   

  void update() 
  {
    if(over()) {
      float myHue = hue(highlightcolor)+5;
      
      if (myHue>255) 
      {
        myHue -= 255;
      }
      highlightcolor=color(myHue, 255,255);
      currentcolor = highlightcolor;
      
    } 
    else {
      currentcolor = basecolor;
    }
  }

  boolean pressed() 
  {
    if(over) {
      locked = true;
      return true;
    } 
    else {
      locked = false;
      return false;
      
    }    
  }

  boolean over() 
  { 
    
    return true; 
  }

  boolean overRect(int x, int y, int width, int height) 
  {
    
    if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
      return true;
    } 
    else {
      return false;
    }
  }

  boolean overCircle(int x, int y, int diameter) 
  {
    float disX = x - mouseX;
    float disY = y - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
      return true;
    } 
    else {
      return false;
    }
  }

}

class CircleButton extends Button
{ 
  CircleButton(int ix, int iy, int isize, color icolor, color ihighlight) 
  {
    x = ix;
    y = iy;
    size = isize;
    basecolor = icolor;
    highlightcolor = ihighlight;
    currentcolor = basecolor;
  }

  boolean over() 
  {
    if( overCircle(x, y, size) ) {
      over = true;
      return true;
    } 
    else {
      over = false;
      return false;
    }
  }

  void display() 
  {
    stroke(255);
    if (over)
      fill(currentcolor);
    else
      noFill();
    ellipse(x, y, size, size);
  }
}

class RectButton extends Button
{
  RectButton(int ix, int iy, int isize, color icolor, color ihighlight) 
  {
    x = ix;
    y = iy;
    size = isize;
    basecolor = icolor;
    highlightcolor = ihighlight;
    currentcolor = basecolor;
  }

  boolean over() 
  {
    if( overRect(x, y, size, size) ) {
      over = true;
      return true;
    } 
    else {
      over = false;
      return false;
    }
  }

  void display() 
  {
    stroke(255);
    if(over)
      fill(currentcolor);
    else
      noFill();
    rect(x, y, size, size);
  }
}


