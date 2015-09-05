
import processing.opengl.*;
import javax.media.opengl.*;
import com.sun.opengl.util.texture.*;

import codeanticode.gsvideo.*;

int numPixels;
int[] previousFrame;

color cRef=color(255);
color cBlack=color(0);
color cBack = color(0);
color cWhite = color(255);
float newHue;

  
GSCapture video;

void setup() {
  colorMode(HSB,256);
  background(0);
  frameRate(30);
  size(640, 480, P2D); // Change size to 320 x 240 if too slow at 640 x 480
  // Uses the default video input, see the reference if this causes an error
  video = new GSCapture(this, width, height, 90);
  numPixels = video.width * video.height;
  // Create an array to store the previously captured frame
  previousFrame = new int[numPixels];

}

int mode=1;


void draw() {
  strokeWeight(3);
  //println(frameRate);
  
  loadPixels();
  
  if (video.available()) 
  {

      video.read(); // Read the new frame from the camera
      video.loadPixels(); // Make its pixels[] array available
      if(mode==0)
      {
        for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
            pixels[i] = video.pixels[i];
        }
      }
      else if (mode==1)
      {
        background(0);
        for (int i = width+1; i < numPixels-(width+1); i++) { // For each pixel in the video frame...


          int grayScale = GetGrayScale(video.pixels[i]);

          int totalDiff = abs(grayScale - GetGrayScale(video.pixels[i-1]));
          totalDiff += abs(grayScale - GetGrayScale(video.pixels[i+1]));
          totalDiff += abs(grayScale - GetGrayScale(video.pixels[i-width]));
          totalDiff += abs(grayScale - GetGrayScale(video.pixels[i+width]));
          totalDiff += abs(grayScale - GetGrayScale(video.pixels[i-(width+1)]));
          totalDiff += abs(grayScale - GetGrayScale(video.pixels[i-(width-1)]));
          totalDiff += abs(grayScale - GetGrayScale(video.pixels[i+(width+1)]));
          totalDiff += abs(grayScale - GetGrayScale(video.pixels[i+(width-1)]));
        
          if (totalDiff> 50)
            pixels[i] = cWhite;
          //pixels = tmpFrame;
        }
      } else if (mode==2) 
      {
        newHue = hue(cRef)+5;
        
        if (newHue>255) newHue-=255;
        cRef=color(newHue, 255,255);
        color cCounter;
        if(newHue>127) cCounter = color(newHue-127, 255,255);
        else cCounter = color(newHue+127, 255,255);
        for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
          if (GetGrayScale(video.pixels[i]) > 355)
            pixels[i] = cRef;
          else
            pixels[i] = cCounter;
        }
      }else if (mode==3) 
      {
        //Infrared colors with trail
        for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
          float g = GetGrayScale(video.pixels[i]);
          g = previousFrame[i]+ ((g-previousFrame[i]) *0.10);
          
          float perc = 255- (255 *((float)g/(float)765));
          pixels[i] = color(perc,255,255-perc);
          previousFrame[i] = (int)g;
        }    
      }
  }
  updatePixels();
  
}
void keyPressed()
{
  if(key=='1')mode=1;
  else if(key=='2')mode=2;
  else if(key=='3')mode=3;
  else if(key=='4')mode=4;
  else if(key=='0')mode=0;
  if(mode==3 && key=='p')
  {
    int grayScale= (int)random(765);
    for (int i = 0; i < numPixels; i++) {
      previousFrame[i] = 765;
    }
  }
}

int GetGrayScale(color c)
{
        int currR = (c >> 16) & 0xFF; // Like red(), but faster
        int currG = (c >> 8) & 0xFF;
        int currB = c & 0xFF;
 
        // Add these differences to the running tally
        return currR + currG + currB;
}

