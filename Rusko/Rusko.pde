import processing.opengl.*;
import javax.media.opengl.*;
import com.sun.opengl.util.texture.*;

LinkedList Squares = new LinkedList();
Vect3d v3dCam = new Vect3d(); 
int     COLOR_MODE=1;
boolean FLAG_ROTATE=false;
boolean FLAG_CUBIC=false;
boolean FLAG_GRAVITY=false;

boolean key_state, key_pstate;
Background bg = new Background();
Camera cam = new Camera();

void setup()
{
  cursor(CROSS);
  size(800,600, OPENGL);
  colorMode(HSB, 1);
  for(int i=0; i<100;i++)
  {
    Squares.add(new Square());
  }
  smooth();
}

void draw()
{
  Squares.add(new Square());
  
  bg.Calc();
  bg.Draw();
  
  Iterator it = Squares.listIterator();
  while (it.hasNext())
  {
    Square s = (Square)it.next();
    s.calc();
    if(s.life<=0)
      it.remove();
    else
      s.draw();
  }
  
   if(mousePressed){
     cam.mode=0;
     if(mouseButton == LEFT) cam.DISTANCE-=20;
     else cam.DISTANCE+=20;
   }

   key_state=keyPressed;
   if(key_state){
     if(key=='q' && key_pstate!=key_state) 
       bg.NextMode();
     else if(key=='w')
     {
       bg.SetColor(color(1));
       bg.bg_mode=0;
     }
     else if(key=='b')
     {
       bg.SetColor(color(0));
       bg.bg_mode=0;
     }
     else if(key=='a' && key_pstate!=key_state)
        NextColorMode();
     else if (key=='r' && key_pstate!=key_state)
       FLAG_ROTATE=!FLAG_ROTATE;
     else if (key=='g' && key_pstate!=key_state)
       FLAG_GRAVITY=!FLAG_GRAVITY;
     else if (key=='c' && key_pstate!=key_state)
       FLAG_CUBIC=!FLAG_CUBIC;
     else if (key=='p' && key_pstate!=key_state){
       cam.RandomPos();
       cam.speed = new Vect3d();
       cam.mode=1;
     }
     
   }
   key_pstate=key_state;
   
   cam.Calc();
   cam.Draw();
   
}

void NextColorMode(){
    COLOR_MODE++;
    if (COLOR_MODE>=3)
      COLOR_MODE=0;
  }


