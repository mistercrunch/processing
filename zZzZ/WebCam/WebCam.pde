import processing.video.*;

int nbPixel;
int Mode=0;
Capture camera;

void setup()
{
  size(800, 600, P3D);
  camera = new Capture(this, width, height, 30);

  colorMode(HSB);
  loadPixels();
  nbPixel = width*height;
}

void captureEvent(Capture camera)
{
 camera.read();
}

void draw()
{
 println(frameRate);
 
 camera.read();
 camera.loadPixels();
  for (int i = 0; i < (nbPixel); i++) {
    if(Mode==0)
      pixels[i] = color(255-hue(camera.pixels[i]));
    else if(Mode==1)
      pixels[i] = color(hue(camera.pixels[i]), 255,255);
    else if(Mode==2)
      pixels[i] = color(hue(camera.pixels[i]), 255,brightness(camera.pixels[i]));
    else if(Mode==3)
      pixels[i] = color(255-brightness(camera.pixels[i]));  
    else if(Mode==4 && i<nbPixel/2)
      {
        int iRow = i/width;
        int iCol = i%width;
        pixels[(((height-1)-iRow)*width) +iCol] = camera.pixels[i];
        pixels[i] = camera.pixels[i];
      }  
  }
  updatePixels();
 
} 

void keyPressed() {
  Mode++;
  if(Mode>4)
    Mode=0;
}
