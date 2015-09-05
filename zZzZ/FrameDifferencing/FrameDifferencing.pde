
import processing.opengl.*;
import javax.media.opengl.*;
import com.sun.opengl.util.texture.*;

import processing.video.*;

int numPixels;
int[] previousFrame;

color cRef=color(255);
color cBlack=color(0);
color cBack = color(0);
color cWhite = color(255);
float newHue;

  
Capture video;

void setup() {
  colorMode(HSB,256);
  background(0);
  frameRate(60);
  size(640, 480, P2D); // Change size to 320 x 240 if too slow at 640 x 480
  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, width, height, 90);
  numPixels = video.width * video.height;
  // Create an array to store the previously captured frame
  previousFrame = new int[numPixels];

}




void draw() {
  
  if(random(1) < 0.003)
    cBack= color(random(255),255,255);
  if(random(1) < 0.01)
    cBack= color(0);
  
  newHue = hue(cRef) + 6;
  if (newHue>255) newHue-=255;
  cRef = color(newHue,255,255);
  println(frameRate);
  fill(cBack, 10);
    
  //fill(cBlack);
  rect(0, 0, width, height);
  
 
  loadPixels();
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
          if(diffR + diffG + diffB > 100)
            //pixels[i] |= color(newHue, 255,(diffR + diffG + diffB)/2);
            pixels[(y*width)+(width - x)-1] |= cRef; 
        //}
        previousFrame[i] = currColor;      
        //pixels = tmpFrame;
    }  
    //image(video,0,0,640,480);
  }
  //if(random(1)<0.001) image(video, 0,0);
}

void keyPressed()
{
  if(key=='w')
    background(255);
}

