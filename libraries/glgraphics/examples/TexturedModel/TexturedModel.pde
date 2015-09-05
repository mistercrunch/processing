// Textured GLModel example.
// By Andres Colubri.
//
// It uses the Obsessive Camera Direction library:
// http://www.gdsstudios.com/processing/libraries/ocd/reference/

import processing.opengl.*;
import codeanticode.glgraphics.*;
import damkjer.ocd.*;

GLModel texpoly;
GLTexture tex;
Camera cam;

int numPoints = 4;

float distance = 1000;

float sensitivity = 1.0; // Scale factor to control camera motions.

void setup()
{
    size(640, 480, GLConstants.GLGRAPHICS);  

    cam = new Camera(this, 100, -125, 10);

    // The model is dynamic, which means that its coordinates can be
    // updating during the drawing loop.
    texpoly = new GLModel(this, numPoints, QUADS, GLModel.DYNAMIC);
    
    // Updating the vertices to their initial positions.
    texpoly.beginUpdateVertices();
    texpoly.updateVertex(0, 0, 0, 0);
    texpoly.updateVertex(1, 100, 0, 0);
    texpoly.updateVertex(2, 100, 100, 0);
    texpoly.updateVertex(3, 0, 100, 0);    
    texpoly.endUpdateVertices();

    // Enabling the use of texturing...
    texpoly.initTexures(1);
    // ... and loading and setting texture for this model.
    tex = new GLTexture(this, "milan.jpg");    
    texpoly.setTexture(0, tex);
   
     // Setting the texture coordinates.
    texpoly.beginUpdateTexCoords(0);
    texpoly.updateTexCoord(0, 0, 0);
    texpoly.updateTexCoord(1, 1, 0);    
    texpoly.updateTexCoord(2, 1, 1);
    texpoly.updateTexCoord(3, 0, 1);
    texpoly.endUpdateTexCoords();

    // Enabling colors.
    texpoly.initColors();
    texpoly.beginUpdateColors();
    for (int i = 0; i < numPoints; i++) texpoly.updateColor(i, random(0, 255), random(0, 255), random(0, 255), 225);
    texpoly.endUpdateColors();    
}

void draw()
{    
    GLGraphics renderer = (GLGraphics)g;
    renderer.beginGL();   
    
    background(0);
    
    // Randomizing the vertices.
    texpoly.beginUpdateVertices();
    for (int i = 0; i < numPoints; i++) texpoly.displaceVertex(i, random(-1.0, 1.0), random(-1.0, 1.0), random(-1.0, 1.0));   
    texpoly.endUpdateVertices();    

    cam.feed();
    renderer.model(texpoly);
    
    renderer.endGL();    
}

void mouseMoved() 
{
    cam.circle(radians(mouseX - pmouseX));
}
