/**
 * Brightness Tracking 
 * by Golan Levin. 
 * 
 * Tracks the brightest pixel in a live video signal. 
 */


import processing.video.*;
int CellSize= 6;
Capture video;
PGraphics layer;
int cHue=0;
void setup() {
  size(640, 480); // Change size to 320 x 240 if too slow at 640 x 480
  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, width, height, 30);
  noStroke();
  smooth();
  layer = createGraphics(640, 480, P3D);
  layer.background(0);
  layer.colorMode(HSB);
  colorMode(HSB);
}

void draw() {
  if (video.available()) {
    video.read();
    image(video, 0, 0, width, height); // Draw the webcam video onto the screen
    int brightestX = 0; // X-coordinate of the brightest video pixel
    int brightestY = 0; // Y-coordinate of the brightest video pixel
    float brightestValue = 0; // Brightness of the brightest video pixel

    video.loadPixels();
    int index = 0;
    int pixelIndex;
    for (int y = 0; y < video.height/CellSize; y++) {
      for (int x = 0; x < video.width/CellSize; x++) {
        int sumBrightness =0;
        for(int i=0; i<CellSize; i++)
        {
          for(int i2=0; i2<CellSize; i2++)
          {
            pixelIndex = (x*CellSize)+i;
            pixelIndex += ((y*CellSize)+i2) * width;
            sumBrightness += brightness(video.pixels[pixelIndex]);
            
          }
        }
        
        int pixelValue = video.pixels[index];
        float pixelBrightness = brightness(pixelValue);
        
        

        if (sumBrightness > brightestValue) {
          brightestValue = sumBrightness;
          brightestY = y;
          brightestX = x;
        }
        index++;
      }
    }
    // Draw a large, yellow circle at the brightest pixel
    
    layer.beginDraw();
    layer.fill(0,5);
    layer.noStroke();
    layer.rect(0,0,width,height);
      
    if(brightestValue > 250*CellSize*CellSize)
    {
      
      
      cHue+=20;
      if (cHue>255) cHue=0;
      cHue=255;      
      layer.fill(cHue, 0, 0);
      layer.ellipse((brightestX*CellSize)+CellSize/2, (brightestY*CellSize)+CellSize/2, 10, 10);

      
      
    }
    layer.endDraw();
    //image(layer, 0,0);
    blend(layer, 0,0, width, height,0,0, width, height,ADD);
  }
}
