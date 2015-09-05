// Example of PTexture and PTextureFilter.
// By Andres Colubri
// Note: this example requires a video card that supports opengl 2
// (geforce 6x00 or better for nvidia, and radeon 1x00 or better for ati).

import processing.opengl.*;
import codeanticode.texture.*;

PTextureFilter pulseEmboss, pixelate, gaussBlur, edgeDetect, posterize;
PTexture tex0, tex1, tex2, tex3, tex4, tex5;

PTextureFilterParams params;

PImage img;

void setup()
{
    size(640, 480, OPENGL);

    // Loading moderately big image file (1600x1200)
    tex0 = new PTexture(this, "old_house.jpg");
    
    // Creating destination textures for the filters.
    tex1 = new PTexture(this, tex0.width, tex0.height);
    tex2 = new PTexture(this, tex0.width, tex0.height);    
    tex3 = new PTexture(this, tex0.width, tex0.height);
    tex4 = new PTexture(this, tex0.width, tex0.height);
    tex5 = new PTexture(this, tex0.width, tex0.height);
    
    // A filter is defined in an xml file where the glsl shaders and grid are specified.
    pulseEmboss = new PTextureFilter(this, "pulsatingEmboss.xml");
    gaussBlur = new PTextureFilter(this, "gaussBlur.xml");
    pixelate = new PTextureFilter(this, "pixelate.xml");    
    edgeDetect = new PTextureFilter(this, "edgeDetect.xml");
    posterize = new PTextureFilter(this, "posterize.xml");
    
    // This object is used to pass parameters to the filters.
    params = new PTextureFilterParams();
}

void draw()
{
   background(0); 

   // Filters can be chained, like here:   
   tex0.filter(pulseEmboss, tex1);
   tex1.filter(gaussBlur, tex2);

   // The resolution of the pixelization in the pixelate filter can be 
   // controled with the first float parameter.
   params.parFlt1 = map(mouseX, 0, 640, 1, 100);
   tex0.filter(pixelate, tex3, params);
   
   tex0.filter(edgeDetect, tex4);
   tex0.filter(posterize, tex5);
   
   tex2.renderTexture(0, 0, 320, 240);
   tex3.renderTexture(320, 0, 320, 240);
   tex4.renderTexture(0, 240, 320, 240);   
   tex5.renderTexture(320, 240, 320, 240);
}
