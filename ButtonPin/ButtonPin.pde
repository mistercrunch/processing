int WIDTH = 250;
int MARGIN = 10;
int buttonSize = WIDTH-MARGIN;
int nbLed = 6;
Led [] daLeds = new Led[nbLed];

void setup()
{
  frameRate(30);
  size(WIDTH, WIDTH);
  //for(int i=0; i<nbLed; i++)
  
    //daLeds[i] = new Led();
  daLeds[0] = new Led(TWO_PI * (0f/6f), (buttonSize/2)-20);
  daLeds[1] = new Led(TWO_PI * (1f/6f), (buttonSize/2)-20);
  daLeds[2] = new Led(TWO_PI * (2f/6f), (buttonSize/2)-20);
  daLeds[3] = new Led(TWO_PI * (3f/6f), (buttonSize/2)-20);
  daLeds[4] = new Led(TWO_PI * (4f/6f), (buttonSize/2)-20);
  daLeds[5] = new Led(TWO_PI * (5f/6f), (buttonSize/2)-20);
  
  
}

int whosTurn=0;
boolean LastOn=false;
int mode=0;
void draw()
{
  background(255);
  fill(0);
  ellipse(width/2, width/2, buttonSize,buttonSize);
  
  //for(int i=0; i<nbLed; i++)
  
  //  daLeds[i].Draw();
   if(mode==0)
   {
     daLeds[(int)random(nbLed)].Draw();
     delay(60);
   }
   else if (mode==1)
   {
    //Spin
    daLeds[whosTurn].Draw();
     delay(60);
    whosTurn++;
    if (whosTurn>=nbLed)whosTurn=0; 
   }
     
}

class Led
{
  int x,y;
  
  Led()
  {
    float Distance = random(buttonSize/2);
    float rad = random(TWO_PI);
    x= (int)(sin(rad)*Distance)+(buttonSize/2);
    y= (int)(cos(rad)*Distance)+(buttonSize/2);
  }
  Led(int _x, int _y)
  {
    x = _x;
    y = _y;
  }
  Led(float rad, float Distance)
  {
    x= (int)(sin(rad)*Distance)+(buttonSize/2);
    y= (int)(cos(rad)*Distance)+(buttonSize/2);
 
  }
  void Draw()
  {
    fill(255);
    ellipse(x,y, 15,15);
  }
};

void mousePressed() 
{
  println(mouseX + ":" + mouseY);
}
