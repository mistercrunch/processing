public class GLTextureMax extends GLTexture 
{
  
  public GLTextureMax(PApplet parent, int width, int height)
  {
       super( parent,  width,  height);
  }
  
  public void renderTextureColor(float x, float y, float w, float h, float r, float g, float b, float a)
    {
        pgl.beginGL();
        
        int pw = parent.width;
        int ph = parent.height;
        
        glstate.saveGLState();  

        glstate.setOrthographicView(pw, ph);

        gl.glEnable(GL.GL_TEXTURE_2D);
        gl.glActiveTexture(GL.GL_TEXTURE0);
        gl.glBindTexture(GL.GL_TEXTURE_2D, tex[0]);
    
         // set tint color??
         gl.glColor4f(r,g,b,a);
    
        gl.glBegin(GL.GL_QUADS);
            gl.glTexCoord2f(0.0, 0.0);
            gl.glVertex2f(x, ph - y);

            gl.glTexCoord2f(1.0, 0.0);
            gl.glVertex2f(x + w, ph - y);

            gl.glTexCoord2f(1.0, 1.0);
            gl.glVertex2f(x + w, ph - (y + h));

            gl.glTexCoord2f(0.0, 1.0);
            gl.glVertex2f(x, ph - (y + h));
        gl.glEnd();  
        gl.glBindTexture(GL.GL_TEXTURE_2D, 0);
        
        glstate.restoreGLState();

        pgl.endGL();      
    }

    protected void initTexture(int w, int h)
    {
        if (tex[0] != 0)
        {
            releaseTexture();
        }
        
        gl.glGenTextures(1, tex, 0);
        gl.glBindTexture(GL.GL_TEXTURE_2D, tex[0]);
        gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_NEAREST);
        gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_NEAREST);
        gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_S, GL.GL_CLAMP);
        gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_T, GL.GL_CLAMP);
        gl.glTexImage2D(GL.GL_TEXTURE_2D, 0, GL.GL_RGBA, w, h, 0, GL.GL_BGRA, GL.GL_UNSIGNED_BYTE, null);
        gl.glBindTexture(GL.GL_TEXTURE_2D, 0);        
    }
 
}

