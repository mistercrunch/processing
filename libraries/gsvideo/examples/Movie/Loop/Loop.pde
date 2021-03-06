/**
 * Loop. 
 * Built-in video library replaced with gsvideo by Andres Colubri
 * 
 * Move the cursor across the screen to draw. 
 * Shows how to load and play a QuickTime movie file.  
 */

import codeanticode.gsvideo.*;

GSMovie myMovie;


void setup() {
  size(640, 480, P3D);
  background(0);
  // Load and play the video in a loop
  myMovie = new GSMovie(this, "station.mov");
  myMovie.loop();
}


void movieEvent(GSMovie myMovie) {
  myMovie.read();
}


void draw() {
  tint(255, 20);
  image(myMovie, mouseX-myMovie.width/2, mouseY-myMovie.height/2);
}
