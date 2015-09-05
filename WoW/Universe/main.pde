import processing.opengl.*;
import javax.media.opengl.*;
import com.sun.opengl.util.texture.*;

PGraphicsOpenGL pgl;
GL gl;
PGraphics pgMenu;
ArrayList SubParticles;

float Repulsion = 0.6;
int ScreenSize = 900;
boolean locked = false;

RectButton AddBall, RemoveBall, Chaos;
long LastEventMillis;

int MouseBallStrength = 20;
int MARGIN=100;
Texture texBall;
System Sys;

boolean COLORSHIFT;
boolean SUBPARTICLES;

void setup() {
  pgMenu = createGraphics(30, 80, P2D);

  SUBPARTICLES=true;
  COLORSHIFT=true;
  colorMode(HSB,1);
  SubParticles = new ArrayList();

  frameRate(40);
  AddBall     = new RectButton(5, 5, 30, color(150), color((int)random(1),255,255));
  RemoveBall  = new RectButton(5, 40, 30, color(150), color((int)random(1),255,255));
  Chaos       = new RectButton(5, 75, 30, color(150), color((int)random(1),255,255));
  
  
  size(ScreenSize, ScreenSize, OPENGL);

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
  //Buttons buttons

  Sys = new System(ScreenSize, 10, MARGIN);
  
  
}

void draw() {


  background(0);

  
  pgMenu.beginDraw();
  //Buttons
  //AddBall.display();
  //RemoveBall.display();
  //Chaos.display();
  ButtonEvents(mouseX, mouseY);
  pgMenu.endDraw();
  image(pgMenu, 0, 0);
  
  perspective( 1.5, 1, 1, 2000 );
  
  
  gl.glDepthMask(false);
  gl.glEnable( GL.GL_BLEND );
  gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE);
  pgl.beginGL();


  //Balls
  texBall.bind();
  texBall.enable();

  for(int i=0; i<Sys.nbBalls; i++)
  {
    Sys.CalcNextFrame(i);
    Sys.Balls[i].Display(Sys.RaySize);
  }
  Sys.ManageSpeed();

  if (mousePressed && !ButtonOver())
  {
    Sys.showMouseBall = true;
    Sys.MouseBall.Position.x =(mouseX-(ScreenSize/2));
    Sys.MouseBall.Position.y =(mouseY-(ScreenSize/2));
    
    float tmp = pow(Sys.RaySize, 2) - pow(Sys.MouseBall.Position.x, 2) - pow(Sys.MouseBall.Position.y, 2);
    if(tmp >=0)
      if((mouseButton == LEFT))
        Sys.MouseBall.Position.z = pow(tmp, 0.5);
      else
        Sys.MouseBall.Position.z = -pow(tmp, 0.5);
    else
      Sys.MouseBall.Position.z = 0;
    
     
  }  

  else
  {
    Sys.showMouseBall = false;
  }
  for( Iterator it = SubParticles.iterator(); it.hasNext(); ){
      SubParticle p = (SubParticle) it.next();
      if( p.age < p.lifeSpan ){
        p.Move();
        p.Display();
        
      } else {
        it.remove();
      }
  }
  
  if(SUBPARTICLES)Sys.GenerateSubParticles();
  
  //renderImageTest(new Point3d(0,0,0), 100, color(1,1,1), 1);
  //renderImageTest(new Point3d(MARGIN,0,0), 100, color(1,1,1), 1);
  
  texBall.disable();  
  pgl.endGL();

}


void keyPressed()
{
  if(key=='1')COLORSHIFT = !COLORSHIFT; else 
  if(key=='2')SUBPARTICLES= !SUBPARTICLES;
  if(key=='q')Sys.AddBall();
  if(key=='a')Sys.RemoveBall();
}

