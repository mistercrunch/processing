
import processing.video.*;

int numPixels;
int[] previousFrame;

color cRef=color(255);
color cBlack=color(0);
color cBack = color(0);
color cWhite = color(255);
float newHue;

OpenGlAbstraction oGLa;
  
Capture video;

void setup() {
    
  colorMode(HSB,1);
  frameRate(5);
  size(640, 480, OPENGL); 
  hint(DISABLE_OPENGL_2X_SMOOTH);
  oGLa = new OpenGlAbstraction();
  oGLa.Start();
  oGLa.Background(0,0,0,1);
  oGLa.End();
  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, width, height, 60);
  numPixels = video.width * video.height;
  // Create an array to store the previously captured frame
  previousFrame = new int[numPixels];

}

void draw()
{
  oGLa.Start();
  float iHue = hue(cBack)+0.02;
  cBack = color(iHue, 1,1);
  oGLa.Background(red(cBack),green(cBack),blue(cBack),0.3);
  oGLa.End();
}

void olddraw() {
      
  println(frameRate);
  
  if(random(1) < 0.003)
    cBack= color(random(1),1, 1);
  if(random(1) < 0.01)
    cBack= color(0);
  
  oGLa.Start();
  oGLa.Background(red(cBack),green(cBack),blue(cBack),0.1);
  
  newHue = hue(cRef) + 0.01;
  if (newHue>1) newHue-=1;
  cRef = color(newHue,1,1);
  //println(frameRate);
  
  float cRefRed = red(cRef);
  float cRefGreen = green(cRef);
  float cRefBlue = blue(cRef);
 
  if (video.available()) 
  {
    int movementSum = 0; // Amount of movement in the frame

      video.read(); // Read the new frame from the camera
      video.loadPixels(); // Make its pixels[] array available
      for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
        color currColor = video.pixels[i];
        color prevColor = previousFrame[i];
        // Extract the red, green, and blue components from current pixel
        int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
        int currG = (currColor >> 8) & 0xFF;
        int currB = currColor & 0xFF;
        // Extract red, green, and blue components from previous pixel
        int prevR = (prevColor >> 16) & 0xFF;
        int prevG = (prevColor >> 8) & 0xFF;
        int prevB = prevColor & 0xFF;
        // Compute the difference of the red, green, and blue values
        int diffR = abs(currR - prevR);
        int diffG = abs(currG - prevG);
        int diffB = abs(currB - prevB);
        // Add these differences to the running tally
        movementSum += diffR + diffG + diffB;
        // Render the difference image to the screen
        //if(diffR + diffG + diffB > 100)
        //{
          int x=i%width;
          int y=(int)(i/width);
          //pixels[i] |= color(hue(cRef), 255, (diffR + diffG + diffB)/2);
          
          //println(diffR + diffG + diffB);
          
          if(diffR + diffG + diffB > 100)
            //pixels[i] |= color(newHue, 255,(diffR + diffG + diffB)/2);
          {         
            oGLa.Point(width-x,y, cRefRed,cRefGreen,cRefBlue);          
          }
  
  
        
        previousFrame[i] = currColor;      

      }
    //image(video,0,0,120,80);
  }
  //if(random(1)<0.001) image(video, 0,0);
  
  oGLa.End();
}

