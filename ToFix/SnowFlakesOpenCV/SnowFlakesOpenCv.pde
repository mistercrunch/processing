import processing.opengl.*;
import javax.media.opengl.*;
import hypermedia.video.*;

OpenCV cam;



ArrayList SnowFlakes;

int WIDTH = 640;
int HEIGHT = 480;

int cellSize = 10;
//Texture texBall;
int nbSnowFlakes= 3000;
int [] lastFramePixs;
int [] diff;
int [] tmp;
int [] PixsBackground ;

//Fluid stuff
FluidSolver fs;
int dx, dy, dg, dg_2, d, c;
int u,v;
boolean SHOW_VECT=false;
   //Capture cam;
int myDelay=0;
boolean SHOW_CHANGE=false;
PImage PIlastFrame;

void setup() {
  lastFramePixs = new int [HEIGHT*WIDTH];
  diff = new int [HEIGHT*WIDTH];
  size(WIDTH, HEIGHT, P3D);
  //cam = new Capture(this, 640, 480);
   cam = new OpenCV(this);
   cam.capture( width, height );


  d = 640;
  fs = new FluidSolver();
  fs.setup(45, 0.2);
  dg   = d  / fs.n;
  dg_2 = dg / 2;
  
  colorMode(RGB,1);
  SnowFlakes = new ArrayList();

  frameRate(40);

  for(int i=0; i<nbSnowFlakes; i++)
  {
    SnowFlakes.add( new SnowFlake() );      
  }
  
  cam.read();


  

}

void draw() {
  println(frameRate);
  background(0); 
  cam.read();
  

  //cam.absDiff();    
  
  
  
  image( cam.image() ,0,0); 


  
 /*
  CheckMouse();
  fs.velocitySolver();
  Decay();

  for( Iterator it = SnowFlakes.iterator(); it.hasNext(); ){
      SnowFlake p = (SnowFlake) it.next();

        p.Move();
        
        p.Display();
  }
  */
}

void CheckMouse()
{
  if(mousePressed)
  {
  //fs.uOld[fs.I(mouseX/dg, mouseY/dg)] +=50;
  //fs.uOld[fs.I((mouseX/dg)-1, mouseY/dg)] -=5;
  //float amount=10;
//  fs.vOld[fs.I(mouseX/dg, mouseY/dg)] +=random(amount)-(amount/2);
  fs.vOld[fs.I(mouseX/dg, mouseY/dg)] -=10;
  }
}

void Decay()
{
  for(int i=0; i<=pow(fs.n,2);i++)
  {
    fs.u[i]*=0.99;
    fs.v[i]*=0.99;
  }
}
 
void Display()
{
  
        for (int i = 1; i <= fs.n; i++)
        {
            // x position of current cell
            dx = (int)( (i - 0.5f) * dg );
            for (int j = 1; j <= fs.n; j++)
            {
                // y position of current cell
                dy = (int)( (j - 0.5f) * dg );

                // draw velocity field
                if (SHOW_VECT)
                {
                    u = (int)( 50 * fs.u[fs.I(i,j)] );
                    v = (int)( 50 * fs.v[fs.I(i,j)] );
                    stroke(1,1,1);
                    line(dx, dy, dx+u, dy+v);           
                }
            }
        }
}


class SnowFlake
{
  Point3d pos;
  Point3d vel;
  float f,d;
  float percReaction;
  
  SnowFlake()
  {
    pos = new Point3d(random(WIDTH), random(HEIGHT), 0);
    vel = new Point3d(0,random(1)+2,0);
    percReaction=random(0.8)+0.2;
  }
  
  void Move()
  {
    if(pos.x>0 && pos.x<WIDTH && pos.y>0 && pos.y<HEIGHT)
    {
      int cellId = fs.I((int)(pos.x/dg),(int)(pos.y/dg));
      pos.x+=fs.u[cellId]*50*percReaction;
      pos.y+=fs.v[cellId]*50*percReaction;
      //println(fs.v[cellId]);
      
    }
    
    pos.Add(vel);
    //if (pos.y > HEIGHT || pos.x <30 || pos.x > WIDTH -30) 
    if (pos.y > HEIGHT) 
    {
      pos.y = -random(10);
      pos.x = random(WIDTH);
    }
  }
  
  void Display()
{
    stroke(1, percReaction);
 
      
    point(pos.x, pos.y);
    
    point(pos.x+1, pos.y);
    point(pos.x-1, pos.y);
    point(pos.x, pos.y+1);
    point(pos.x, pos.y-1);
    
  }
};

void keyPressed()
{
    cam.remember();

  
}


void BlackWhite(PImage p)
{
  p.loadPixels();
  for(int i=0; i<HEIGHT * WIDTH; i++)
  {
    p.pixels[i] = color(brightness(p.pixels[i]) * 0.7);
  }
  
  p.updatePixels();
}
/*
void ShowDiff()
{
  float diffSum;
  int [] tmp;

  for(int i=0; i<HEIGHT * WIDTH; i++)
  {
    diffSum=abs(red(cam.pixels[i]) - red(lastFramePixs[i]) ) +abs(green(cam.pixels[i]) - green(lastFramePixs[i]) )+abs(blue(cam.pixels[i]) - blue(lastFramePixs[i]) );
    
    //diffSum=abs(brightness(cam.pixels[i]) - brightness(lastFramePixs[i]));
    //println(diffSum);
    if(diffSum > 0.2 )
    {
      //diff[i] = color(1);
      fs.vOld[PixNumToCellNum(i)] -=0.01;
    }
    
    diffSum=abs(red(cam.pixels[i]) - red(PixsBackground[i]) ) +abs(green(cam.pixels[i]) - green(PixsBackground[i]) )+abs(blue(cam.pixels[i]) - blue(PixsBackground[i]) );
    if (diffSum < 0.2 )
      diff[i] = color(0);
    else
      diff[i] = cam.pixels[i];
    
  }

  
}
*/
int PixNumToCellNum(int PixNum)
{
  int y = (int)(PixNum / WIDTH);
  int x = PixNum % WIDTH;
  return fs.I(x/dg,y/dg);
}

