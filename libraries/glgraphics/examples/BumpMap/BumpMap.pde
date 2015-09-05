// Bump mapping effect using GLModel and GLModelEffect classes.
// A GLModelEffect encapsulates a GLSL shader that it is applied
// when rendering a model. 

import processing.opengl.*;
import codeanticode.glgraphics.*;

GLModel cube;
GLModelEffect bump;

float angle;

void setup()
{
    size(640, 480, GLConstants.GLGRAPHICS);  
    
    cube = new GLModel(this, "cube.xml");
    bump = new GLModelEffect(this, "bump.xml");  
}

void draw()
{    
    float mx = (mouseX - width / 2.0) / (width / 2.0);
    float my = (mouseY - height / 2.0) / (height / 2.0);
    
    angle += 0.003;
    
    background(50, 0, 0);
    
    // When drawing GLModels, the drawing calls need to be encapsulated 
    // between beginGL()/endGL() to ensure that the camera configuration 
    // is properly set.    
    GLGraphics renderer = (GLGraphics)g;
    renderer.beginGL();   
    
    // Once inside beginGL()/endGL(), lights can be used... 
    lights();
    ambient(250, 250, 250);
    
    // ...as well as camera transformations.
    camera(400 * sin(mx), 0, -400 * cos(mx), 0, 0, 0, 0, 1, 0);
    perspective(PI / 3.0, 4.0 / 3.0, 1, 1000);

    pointLight(255, 255, 255, 0, 0, -100);    
    
    pushMatrix();
    rotateY(angle);
    
    // A model effect can be applied in different ways: 
    // effect.apply(), model.render(effect), GLGraphics.model(model, effect):
    //bump.apply(cube);
    //cube.render(bump);
    renderer.model(cube, bump);
    popMatrix();
     
    renderer.endGL();  
  
    println(frameRate);
}
