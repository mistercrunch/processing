// Rendering the result of a texture filter operation to a 3D model.
// By Andres Colubri.
//
// Basically, the luminance of of the pixels that result of applying 
// a pulsating emboss filter on an image are used as the Z coordinates 
// of the model. The number of vertices in the model equals  the 
// resolution of the source image, in this case 200x200 = 40000. 
// All of this can be done very quickly because the model is stored and updated
// directly in the GPU memory. There are no transfers between CPU and GPU.

import processing.opengl.*;
import codeanticode.glgraphics.*;

GLTextureFilter pulse, zMap;
GLTexture srcTex, tmpTex, destTex;
GLModel destModel;

void setup()
{
  size(640, 480, GLConstants.GLGRAPHICS);
   
  srcTex = new GLTexture(this, "milan_rubbish.jpg");

  // Pulsating emboss filter.
  pulse = new GLTextureFilter(this, "pulsatingEmboss.xml");
  
  // This filter extracts the brightness of an input image.
  zMap = new GLTextureFilter(this, "brightExtract.xml");
  
  tmpTex = new GLTexture(this, srcTex.width, srcTex.height);  
  destTex = new GLTexture(this, srcTex.width, srcTex.height, GLTexture.FLOAT, GLTexture.NEAREST);
  
  int numPoints = srcTex.width * srcTex.height;
  destModel = new GLModel(this, numPoints, POINTS, GLModel.STREAM);
  destModel.initColors();
  destModel.setColors(255, 100);
}

void draw()
{
  float mx = (mouseX - width / 2.0) / (width / 2.0);
  float my = (mouseY - height / 2.0) / (height / 2.0);   
  
  background(0);
  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();
    
  pulse.apply(srcTex, tmpTex);
  // The brightness from tmpTex is written into destTex and also into destModel.
  zMap.apply(tmpTex, destTex, destModel); 

  camera(100 * sin(mx), 0, -100 * cos(mx), 0, 0, 0, 0, 1, 0);
  perspective(PI/3.0, 4.0/3.0, 1, 1000);

  renderer.model(destModel);
  
  renderer.endGL();   
   
  println(frameRate);
}