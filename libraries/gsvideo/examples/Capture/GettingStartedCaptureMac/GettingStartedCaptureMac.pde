/**
 * Getting Started with Capture.
 * 
 * GSVideo version by Andres Colubri. 
 * 
 * Reading and displaying an image from an attached Capture device. 
 */ 
import codeanticode.gsvideo.*;

GSCapture cam;

void setup() {
  size(640, 480);

  /*
  // List functionality hasn't been tested on Mac OSX. Uncomment this 
  // code to try it out.
  String[] cameras = GSCapture.list();
  
  if (cameras.length == 0)
  {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++)
      println(cameras[i]);
    cam = new GSCapture(this, 320, 240, cameras[0]);
  }
  */
  cam = new GSCapture(this, 320, 240);
}

void draw() {
  if (cam.available() == true) {
    cam.read();
    image(cam, 160, 100);
    // The following does the same, and is faster when just drawing the image
    // without any additional resizing, transformations, or tint.
    //set(160, 100, cam);
  }
}
