/**
 * Texture library.
 * Processing library to handle openGL textures in a simplified way and define 2D filters on them.
 *
 * PGLState class that offers some utilities function to set and restore opengl state.
 * v0.6
 * Changes:
 * First implementation.
 * Author: 
 * Andres Colubri
 */

/*
  Copyright (c) 2008 Andres Colubri

  This source is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This code is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  General Public License for more details.

  A copy of the GNU General Public License is available on the World
  Wide Web at <http://www.gnu.org/copyleft/gpl.html>. You can also
  obtain it by writing to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

import com.sun.opengl.util.*;
import java.nio.*;

public class PTexture extends PImage 
{
    public PTexture(PApplet parent)
    {
        super(1, 1, ARGB);  
        this.parent = parent;
       
        pgl = (PGraphicsOpenGL)parent.g;
        gl = pgl.gl;       
        glstate = new PGLState(gl);
    }  
  
    public PTexture(PApplet parent, int width, int height)
    {
        super(width, height, ARGB);  
        this.parent = parent;
       
        pgl = (PGraphicsOpenGL)parent.g;
        gl = pgl.gl;
        glstate = new PGLState(gl);
       
        initTexture(width, height);
    }
    
    public PTexture(PApplet parent, String filename)
    {
        super(1, 1, ARGB);  
        this.parent = parent;
       
        pgl = (PGraphicsOpenGL)parent.g;
        gl = pgl.gl;
        glstate = new PGLState(gl);      
    
        loadTexture(filename);
    }

    public void init(int width, int height)
    {
        init(width, height, ARGB);
        initTexture(width, height);        
    }

    public boolean available()
    {
        return 0 < tex[0];
    }
    
    public int getTextureID()
    {
        return tex[0];
    }
    
    public int getTextureTarget()
    {
        return GL.GL_TEXTURE_2D;
    }    

    // Puts img into texture, pixels and image.
    public void putImage(PImage img)
    {
        img.loadPixels();
        
        if ((img.width != width) || (img.width != height))
        {
            init(img.width, img.height, ARGB);
            initTexture(width, height);
        }

        // Putting img into pixels...
        arraycopy(img.pixels, pixels);
   
        // ...into texture...
        loadTexture();
        
        // ...and into image.
        updatePixels();
    }
   
    // Copies texture to img.
    public void getImage(PImage img)
    {
        int w = width;
        int h = height;
        
        if ((img.width != w) || (img.height != h))
        {
            img.init(w, h, ARGB);
        }
       
        IntBuffer buffer = BufferUtil.newIntBuffer(w * h * 4);
        gl.glBindTexture(GL.GL_TEXTURE_2D, tex[0]);
        gl.glGetTexImage(GL.GL_TEXTURE_2D, 0, GL.GL_BGRA, GL.GL_UNSIGNED_BYTE, buffer);
        gl.glBindTexture(GL.GL_TEXTURE_2D, 0);       
       
        buffer.get(img.pixels);
        img.updatePixels();       
    }

    // Load texture, pixels and image from file.
    public void loadTexture(String filename)
    {
        PImage img = parent.loadImage(filename);
        putImage(img);
    }
   
    // Copy from pixels to texture (loadPixels should have been called beforehand).
    public void loadTexture()
    {
        if (tex[0] == 0)
        {
            initTexture(width, height);
        }      
        gl.glBindTexture(GL.GL_TEXTURE_2D, tex[0]);
        gl.glTexSubImage2D(GL.GL_TEXTURE_2D, 0, 0, 0, width, height, GL.GL_BGRA, GL.GL_UNSIGNED_BYTE, IntBuffer.wrap(pixels));
        gl.glBindTexture(GL.GL_TEXTURE_2D, 0);
    }

    // Copy texture to pixels (doesn't call updatePixels).
    public void updateTexture()
    {
        IntBuffer buffer = BufferUtil.newIntBuffer(width * height * 4);        
        gl.glBindTexture(GL.GL_TEXTURE_2D, tex[0]);
        gl.glGetTexImage(GL.GL_TEXTURE_2D, 0, GL.GL_BGRA, GL.GL_UNSIGNED_BYTE, buffer);
        gl.glBindTexture(GL.GL_TEXTURE_2D, 0);
        buffer.get(pixels);
    }

    public void filter(PTextureFilter texFilter, PTexture destTex)
    {
        texFilter.apply(new PTexture[] { this }, new PTexture[] { destTex });
    }

    public void filter(PTextureFilter texFilter, PTexture[] destTexArray)
    {
        texFilter.apply(new PTexture[] { this }, destTexArray);
    }

    public void filter(PTextureFilter texFilter, PTexture destTex, PTextureFilterParams params)
    {
        texFilter.apply(new PTexture[] { this }, new PTexture[] { destTex }, params);
    }

    public void filter(PTextureFilter texFilter, PTexture[] destTexArray, PTextureFilterParams params)
    {
        texFilter.apply(new PTexture[] { this }, destTexArray, params);
    }

    public void renderTexture()
    {
        renderTexture(0, 0, width, height);
    }

    public void renderTexture(float x, float y)
    {
        renderTexture(x, y, width, height);
    }
    
    public void renderTexture(float x, float y, float w, float h)
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
         gl.glColor4f(1.0, 1.0, 1.0, 1.0);
    
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
    
    protected void releaseTexture()
    {
        gl.glDeleteTextures(1, tex, 0);  
        tex[0] = 0;
    }
    
    protected GL gl;
    protected PGraphicsOpenGL pgl;
    protected int[] tex = { 0 }; 
    protected PGLState glstate;
}
