import codeanticode.gsvideo.*;

int numPixels;
int[] backgroundPixels;
int[] previousFramePixels;
GSCapture video;

PImage testi = loadImage("/home/mistercrunch/Code/Processing/BreakfastChampion/test.jpg");

void setup() {
  size(640, 480); 
  testi.loadPixels();
   
  video = new GSCapture(this, width, height, 24);
  numPixels = video.width * video.height;
  // Create array to store the background image
  backgroundPixels = new int[numPixels];
  previousFramePixels = new int[numPixels];
  // Make the pixels[] array available for direct manipulation
  loadPixels();
  frameRate(30);
}

void draw() {
  if (video.available()) {
    video.read(); // Read a new video frame
    video.loadPixels(); // Make the pixels of video available
    // Difference between the current frame and the stored background
    int cDiff = 0;
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...

      cDiff = diffColor(video.pixels[i], backgroundPixels[i]);

      if(cDiff>100)
        pixels[i] = video.pixels[i];
      else
        pixels[i] = previousFramePixels[i];      
    }
    
    arraycopy(pixels, previousFramePixels);
    updatePixels(); // Notify that the pixels[] array has changed
  }
}

// When a key is pressed, capture the background image into the backgroundPixels
// buffer, by copying each of the current frame�s pixels into it.
void keyPressed() {
  video.loadPixels();
  for (int i = 0; i < numPixels; i++) pixels[i]=testi.pixels[i];
  arraycopy(pixels, previousFramePixels);
  updatePixels();
  arraycopy(video.pixels, backgroundPixels);
}

int diffColor(color c1, color c2){
       // Extract the red, green, and blue components of the current pixel�s color
      int currR = (c1 >> 16) & 0xFF;
      int currG = (c1 >> 8) & 0xFF;
      int currB = c1 & 0xFF;
      // Extract the red, green, and blue components of the background pixel�s color
      int bkgdR = (c2 >> 16) & 0xFF;
      int bkgdG = (c2 >> 8) & 0xFF;
      int bkgdB = c2 & 0xFF;
      // Compute the difference of the red, green, and blue values
      return abs(currR - bkgdR) + abs(currG - bkgdG) + abs(currB - bkgdB);
}
