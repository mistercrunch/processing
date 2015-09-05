// Swarming points using GLModel and GLCamera, using sprite textures.
// By Andres Colubri.
//
// It uses the Obsessive Camera Direction library:
// http://www.gdsstudios.com/processing/libraries/ocd/reference/

import processing.opengl.*;
import codeanticode.glgraphics.*;
import damkjer.ocd.*;

GLModel model;
GLTexture tex;
float[] coords;
float[] colors;

int numPoints = 10000;

Camera cam;

void setup()
{
    size(640, 480, GLConstants.GLGRAPHICS);  

    cam = new Camera(this, 100, -125, 10);
    
    model = new GLModel(this, numPoints, GLModel.POINT_SPRITES, GLModel.DYNAMIC);
    model.initColors();
    tex = new GLTexture(this, "particle.bmp");    
    
    coords = new float[4 * numPoints];
    colors = new float[4 * numPoints];
    
    for (int i = 0; i < numPoints; i++)
    {
        for (int j = 0; j < 3; j++) coords[4 * i + j] = 100.0 * random(-1, 1);
        for (int j = 0; j < 3; j++) colors[4 * i + j] = random(0, 1);
        colors[4 * i + 3] = 0.9;
    }

   model.updateVertices(coords);
   model.updateColors(colors);

   println("Maximum sprite size supported by the video card: " + model.getMaxPointSize() + " pixels.");   
   model.initTexures(1);
   model.setTexture(0, tex);   
   model.setPointSize(60);
   model.setSpriteFadeSize(40);
   model.setBlendMode(ADD);
}

void draw()
{    
    GLGraphics renderer = (GLGraphics)g;
    renderer.beginGL();  
    
    background(0);
    
    for (int i = 0; i < numPoints; i++)
        for (int j = 0; j < 3; j++)
            coords[4 * i + j] += random(-0.5, 0.5);
    
    model.updateVertices(coords);

    cam.feed();

    model.render();
    
    renderer.endGL();
}

void mouseMoved() 
{
    cam.dolly(mouseY - pmouseY);
}
