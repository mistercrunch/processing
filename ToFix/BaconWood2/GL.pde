import processing.opengl.*;
import javax.media.opengl.*;
import com.sun.opengl.util.texture.*;
import java.nio.FloatBuffer;
import com.sun.opengl.util.*;

class OpenGlAbstraction
{
  PGraphicsOpenGL pgl;
  GL gl;
  
  FloatBuffer pointPosArray;
  FloatBuffer pointColArray;
  int nbPoint;

  OpenGlAbstraction()
  {
    //pgl = (PGraphicsOpenGL) g;
    int maxPixels = width*height;
    pointPosArray = BufferUtil.newFloatBuffer(maxPixels * 2);
    pointColArray = BufferUtil.newFloatBuffer(maxPixels * 3);
  }
  void Start()
  {
             // processings opengl graphics object
    pgl = (PGraphicsOpenGL) g; //processing graphics object
    gl = pgl.beginGL();

    nbPoint =0;
    //gl.glBlendFunc(GL.GL_ONE, GL.GL_ONE);  // additive blending (ignore alpha)
    //gl.glEnable(GL.GL_POINT_SMOOTH);        // make points round
    //gl.glPointSize(1);
  }
  void End()
  {
    if (nbPoint>0)
      DrawPoints();
      
    gl.glDisable(GL.GL_BLEND);
    pgl.endGL();
  }
  void Point(int x, int y, float r, float g, float b) {
    
        int vi = nbPoint * 2;
        pointPosArray.put(vi++, x);
        pointPosArray.put(vi++, y);

        int ci = nbPoint * 3;
        pointColArray.put(ci++, r);
        pointColArray.put(ci++, g);
        pointColArray.put(ci++, b);
        
        nbPoint++;
    }
    
  void DrawPoints()
  {
            gl.glEnableClientState(GL.GL_VERTEX_ARRAY);
            gl.glVertexPointer(2, GL.GL_FLOAT, 0, pointPosArray);

            gl.glEnableClientState(GL.GL_COLOR_ARRAY);
            gl.glColorPointer(3, GL.GL_FLOAT, 0, pointColArray);

            gl.glDrawArrays(GL.GL_POINTS, 0, nbPoint);
  }
  
  void Background(float r, float g, float b, float speed) {
    
    gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE_MINUS_SRC_ALPHA);
    gl.glColor4f(r, g, b, speed);
    gl.glBegin(GL.GL_QUADS);
    gl.glVertex2f(0, 0);
    gl.glVertex2f(width, 0);
    gl.glVertex2f(width, height);
    gl.glVertex2f(0, height);
    gl.glEnd();
  }  
  
  void Background(float r, float g, float b) {
    
    //gl.glBlendFunc(GL.GL_ZERO, GL.GL_ZERO);
    gl.glColor3f(r, g, b);  
    gl.glBegin(GL.GL_QUADS);
    gl.glVertex2f(0, 0);
    gl.glVertex2f(width, 0);
    gl.glVertex2f(width, height);
    gl.glVertex2f(0, height);
    gl.glEnd();
  }  
};
