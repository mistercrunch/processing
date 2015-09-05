import processing.opengl.*;
import javax.media.opengl.*;
import hypermedia.video.*;

OpenCV cam;



ArrayList SnowFlakes;

int WIDTH = 640;
int HEIGHT = 480;



//Fluid stuff
//FluidSolver fs;


void setup() {
   cam = new OpenCV(this);
   cam.capture( width, height );
  cam.read();


  

}

void draw() {
  println(frameRate);

  
  image( cam.image() ,0,0); 


}

