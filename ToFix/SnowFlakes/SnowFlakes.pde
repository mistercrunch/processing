import processing.opengl.*;
import javax.media.opengl.*;
import com.sun.opengl.util.texture.*;
import processing.video.*;

PGraphicsOpenGL pgl;
GL gl;
ArrayList SnowFlakes;

int WIDTH = 640;
int HEIGHT = 640;
int cellSize = 10;
Texture texBall;
int nbSnowFlakes= 3000;

//Fluid stuff
FluidSolver fs;
int dx, dy, dg, dg_2, d, c;
int u,v;
boolean SHOW_VECT=false;
Capture cam;

void setup() {
  size(WIDTH, HEIGHT, OPENGL);
  cam = new Capture(this, 640, 480);
  d = 640;
  fs = new FluidSolver();
  fs.setup(40, 0.2);
  dg   = d  / fs.n;
  dg_2 = dg / 2;
  
  colorMode(HSB,1);
  SnowFlakes = new ArrayList();

  frameRate(40);

  for(int i=0; i<nbSnowFlakes; i++)
  {
    SnowFlakes.add( new SnowFlake() );      
  }
  

  //hint( ENABLE_OPENGL_4X_SMOOTH );
  pgl         = (PGraphicsOpenGL) g;
  gl          = pgl.gl;
  gl.setSwapInterval(1);
  initGL();
  try {
    texBall = TextureIO.newTexture(new File(dataPath("particle.png")), true);  
  }
  catch (IOException e) {    
    println("Texture file is missing");
    exit();  // or handle it some other way
  } 
  
  
}

void draw() {
  println();
  background(0);  
  cam.read();
  //image(cam, 0, 0);
  CheckMouse();
  
  fs.velocitySolver();
  Decay();
  Display();

  gl.glDepthMask(false);
  gl.glEnable( GL.GL_BLEND );
  gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE);
  pgl.beginGL();


  //Balls
  texBall.bind();
  texBall.enable();


  for( Iterator it = SnowFlakes.iterator(); it.hasNext(); ){
      SnowFlake p = (SnowFlake) it.next();

        p.Move();
        p.Display();
  }
  
  texBall.disable();  
  pgl.endGL();

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
    percReaction=random(0.7)+0.3;
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
    if (pos.y > HEIGHT) 
    {
      pos.y = -random(10);
      pos.x = random(WIDTH);
    }
  }
  
  void Display()
  {
    renderImage(pos, random(20)+10, color(1,0,1), 1);
  }
};

