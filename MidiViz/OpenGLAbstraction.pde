import processing.opengl.*;
import javax.media.opengl.*;
import com.sun.opengl.util.texture.*;
// Any time I want to draw a square, I use the squareList.
// Should be slightly faster than calling all the vertex calls over and over.

class OpenGLAbstraction
{

int squareList;
PGraphicsOpenGL pgl;
GL gl;
Texture texBall;

OpenGLAbstraction(){
  pgl         = (PGraphicsOpenGL) g;
  gl          = pgl.gl;
  gl.setSwapInterval(1);
  pgl.beginGL();
  squareList = gl.glGenLists(1);
  gl.glNewList(squareList, GL.GL_COMPILE);
  gl.glBegin(GL.GL_POLYGON);
  gl.glTexCoord2f(0, 0);    gl.glVertex2f(-.5, -.5);
  gl.glTexCoord2f(1, 0);    gl.glVertex2f( .5, -.5);
  gl.glTexCoord2f(1, 1);    gl.glVertex2f( .5,  .5);
  gl.glTexCoord2f(0, 1);    gl.glVertex2f(-.5,  .5);
  gl.glEnd();
  gl.glEndList();
  pgl.endGL();
  
  //Loading textures
  try {
    if(LINUX_MODE)
      texBall = TextureIO.newTexture(new File(dataPath("/home/mistercrunch/Code/Processing/particle2.png")), true);  
    else
      texBall = TextureIO.newTexture(new File(dataPath("c:\\particle.png")), true);  
  }
  catch (IOException e) {    
    println("Texture file is missing");
    exit();  
  } 
}

void OpenGLStartDraw()
{
  gl.glDepthMask(false);
  gl.glEnable( GL.GL_TEXTURE_2D );
  gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE);
  /*
  translate(width, height, 0);
  rotateY(radians((mouseX/2)-(width)));
  rotateX(radians(-((mouseY/2)-(height))));
  translate(-width, -height, 0);
  */
  pgl.beginGL();
  texBall.bind();
  texBall.enable();
}

void OpenGLEndDraw()
{
texBall.disable();  
  pgl.endGL();
}
// It would be faster to just make QUADS calls directly to the loc
// without dealing with pushing and popping for every particle. The reason
// I am doing it this longer way is due to a billboarding problem which will come
// up later on.
void renderImage(Vect3d _loc, float _diam, ColorGL _col, float _alpha){
  gl.glPushMatrix();
  gl.glTranslatef( _loc.x, _loc.y, _loc.z);
  
  gl.glRotatef(degX,0,1,0);
  gl.glRotatef(degY+90,1,0,0);
  gl.glRotatef(random(360),0,0,1);
  
  
  
  gl.glScalef( _diam, _diam, _diam );
  gl.glColor4f( _col.r, _col.g, _col.b, _alpha );
  gl.glCallList( squareList );
  gl.glPopMatrix();
}

void Background(color c, float a)
{
  gl.glDepthMask(false);
  gl.glEnable( GL.GL_TEXTURE_2D );
  gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE);
  
  pgl.beginGL();
  gl.glColor4f(red(c), green(c), blue(c), a);
  gl.glRectf(0, 0, width, height);

  pgl.endGL();
}

};
