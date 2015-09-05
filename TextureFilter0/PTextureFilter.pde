/**
 * Texture library.
 * Processing library to handle openGL textures in a simplified way and define 2D filters on them.
 *
 * PTextureFilter class that defines a glsl 2D filter to apply on PTexture objects.
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

import processing.xml.*;
import javax.media.opengl.*;

public class PTextureFilter
{
    public PTextureFilter(PApplet parent, String filename)
    {
        this(parent, filename, 1);
    }
  
    public PTextureFilter(PApplet parent, String filename, int nInTex)
    {
        this.parent = parent;
       
        pgl = (PGraphicsOpenGL)parent.g;
        gl = pgl.gl;
        glstate = new PGLState(gl);        
        initFBO();

        defFilterParams = new PTextureFilterParams();
        
        xmlFilterCfg = new XMLElement(parent, filename);
        initFilter(nInTex);
    }
  
    public String getDescription()
    {
        return description;  
    }

    public int getNumInputTextures()
    {
        return numInputTex;  
    }

    public void apply(PTexture[] srcTex, PTexture[] destTex)
    {
        apply(srcTex, destTex, defFilterParams);
    }
    
    public void apply(PTexture[] srcTex, PTexture[] destTex, PTextureFilterParams params)
    {
        pgl.beginGL();      
      
	int w = destTex[0].width;
	int h = destTex[0].height;
        setGLConf(w, h);
      
        bindDestFBO(); 
        bindDestTexToFBO(destTex);
          
        shader.start();
        setupShader(srcTex, w, h, params);
      
	bindSrcTex(srcTex);
	grid.render(w, h, srcTex.length);
	unbindSrcTex(srcTex.length);
    
        shader.stop();

        unbindDestFBO();
        
        
        restoreGLConf();

        pgl.endGL();
    }
  
    protected void setGLConf(int w, int h)
    {
	blendOn = gl.glIsEnabled(GL.GL_BLEND);
	//gl.glGetIntegerv(GL.GL_POLYGON_MODE, polyMode);
      
        gl.glDisable(GL.GL_BLEND);
        gl.glPolygonMode(GL.GL_FRONT, GL.GL_FILL);

	glstate.saveView();
	glstate.setOrthographicView(w, h);
    }

    protected void restoreGLConf()
    {
        glstate.restoreView();

	if (blendOn) gl.glEnable(GL.GL_BLEND);
	//glPolygonMode(GL_FRONT, m_poly_mode);
    }
    
    protected void bindSrcTex(PTexture[] srcTex)
    {
        gl.glEnable(GL.GL_TEXTURE_2D);
        
        for (int i = 0; i < srcTex.length; i++)
	{
            gl.glActiveTexture(GL.GL_TEXTURE0 + i);
            gl.glBindTexture(GL.GL_TEXTURE_2D, srcTex[i].getTextureID());
	}      
    }

    protected void unbindSrcTex(int ntex)
    {
        for (int i = ntex; 0 < i; i--)
	{
            gl.glActiveTexture(GL.GL_TEXTURE0 + i - 1);
            gl.glBindTexture(GL.GL_TEXTURE_2D, 0);
	}
    }

    protected void bindDestFBO()
    {
        gl.glBindFramebufferEXT(GL.GL_FRAMEBUFFER_EXT, destFBO[0]);  
    }
  
    protected void unbindDestFBO()
    {
        gl.glBindFramebufferEXT(GL.GL_FRAMEBUFFER_EXT, 0);  
    }  
  
    protected void bindDestTexToFBO(PTexture[] destTex)
    {
        for (int i = 0; i < destTex.length; i++)
        {
            gl.glFramebufferTexture2DEXT(GL.GL_FRAMEBUFFER_EXT, GL.GL_COLOR_ATTACHMENT0_EXT + i, GL.GL_TEXTURE_2D, destTex[i].getTextureID(), 0);
        }
        checkFBO();
        
//             gl.glDrawBuffers(2, IntBuffer.wrap(colorDrawBuffers));
    }    
    
    protected void checkFBO()
    {
        int stat = gl.glCheckFramebufferStatusEXT(GL.GL_FRAMEBUFFER_EXT);
        if (stat != GL.GL_FRAMEBUFFER_COMPLETE_EXT) System.err.println("Framebuffer Object error!");
    }
    
    protected void initFBO()
    {
        gl.glGenFramebuffersEXT(1, destFBO, 0);
    }
    
    protected void initFilter(int nInTex)
    {
        grid = null;
        String vertexFN, geometryFN, fragmentFN;
        
        // Parsing xml configuration.
        int n = xmlFilterCfg.getChildCount();
        String name;
        XMLElement child;
        vertexFN = geometryFN = fragmentFN = "";
        for (int i = 0; i < n; i++) 
        {
            child = xmlFilterCfg.getChild(i);
            name = child.getName();
            if (name.equals("description"))
            {
                description = child.getContent();
            }            
            else if (name.equals("vertex"))
            {
                vertexFN = child.getContent();
            }
            else if (name.equals("geometry"))
            {
                geometryFN = child.getContent(); 
            }
            else if (name.equals("fragment"))
            {
                fragmentFN = child.getContent();
            }
            else if (name.equals("grid"))
            {
                grid = new PTextureGrid(gl, child);
            }
            else
            {
                System.err.println("Unrecognized element in filter config file!");
            }
        }

        if (grid == null)
        {
            // Creates a 1x1 grid.
            grid = new PTextureGrid(gl);
        }

        // Initializing shader.
        shader = new PGLSLShader(gl);
        if (!vertexFN.equals(""))
        {
            shader.loadVertexShader(vertexFN);
        }
        if (!geometryFN.equals(""))
        {
            //shader.loadGeometryShader(vertexFN);
        }            
        if (!fragmentFN.equals(""))
        {
            shader.loadFragmentShader(fragmentFN);
        }            

        shader.linkProgram();
           
        // Initializing list of input textures.
        numInputTex = nInTex;
        srcTexUnitUniform = new int[numInputTex];
        srcTexOffsetUniform = new int[numInputTex];
            
	// Gettting uniform parameters.
	for (int i = 0; i < numInputTex; i++)
        {
	    srcTexUnitUniform[i] = shader.getUniformLocation("src_tex_unit" + i);
	    srcTexOffsetUniform[i] = shader.getUniformLocation("src_tex_offset" + i);
        }

	timingDataUniform = shader.getUniformLocation("timing_data");
	destTexSizeUniform = shader.getUniformLocation("dest_tex_size");
	parFlt1Uniform = shader.getUniformLocation("par_flt1");
	parFlt2Uniform = shader.getUniformLocation("par_flt2");
	parFlt3Uniform = shader.getUniformLocation("par_flt3");
	parMat2Uniform = shader.getUniformLocation("par_mat2");
	parMat3Uniform = shader.getUniformLocation("par_mat3");
	parMat4Uniform = shader.getUniformLocation("par_mat4");
    }

    void setupShader(PTexture[] srcTex, int w, int h, PTextureFilterParams params)
    {
        int n = min(numInputTex, srcTex.length); 
        for (int i = 0; i < n; i++)
        {
           if (-1 < srcTexUnitUniform[i]) gl.glUniform1iARB(srcTexUnitUniform[i], i);
           if (-1 < srcTexOffsetUniform[i]) gl.glUniform2fARB(srcTexOffsetUniform[i], 1.0 / srcTex[0].width, 1.0 / srcTex[0].height);
        }
        
        if (-1 < timingDataUniform)
        {
            int fcount = parent.frameCount;
            int msecs = parent.millis();          
            gl.glUniform2fARB(timingDataUniform, fcount, msecs);
        }
        
        if (-1 < destTexSizeUniform) gl.glUniform2fARB(destTexSizeUniform, w, h);
        
        if (-1 < parFlt1Uniform) gl.glUniform1fARB(parFlt1Uniform, params.parFlt1);
        if (-1 < parFlt2Uniform) gl.glUniform1fARB(parFlt2Uniform, params.parFlt2);
        if (-1 < parFlt3Uniform) gl.glUniform1fARB(parFlt3Uniform, params.parFlt3);        
        
        if (-1 < parMat2Uniform) gl.glUniformMatrix2fvARB(parMat2Uniform, 1, false, FloatBuffer.wrap(params.parMat2));
        if (-1 < parMat3Uniform) gl.glUniformMatrix3fvARB(parMat3Uniform, 1, false, FloatBuffer.wrap(params.parMat3));
        if (-1 < parMat4Uniform) gl.glUniformMatrix4fvARB(parMat4Uniform, 1, false, FloatBuffer.wrap(params.parMat4));
    }

    protected PApplet parent;
    protected GL gl;
    protected PGraphicsOpenGL pgl;
    protected PGLState glstate;    
    protected int[] destFBO = { 0 };
    protected PTextureGrid grid;
    protected XMLElement xmlFilterCfg;
    protected String description;
    protected PGLSLShader shader;
    protected int numInputTex;
    protected int[] srcTexUnitUniform;    
    protected int[] srcTexOffsetUniform;
    protected int timingDataUniform;
    protected int destTexSizeUniform;
    protected int parFlt1Uniform;
    protected int parFlt2Uniform;
    protected int parFlt3Uniform;
    protected int parMat2Uniform;
    protected int parMat3Uniform;
    protected int parMat4Uniform;
    protected boolean blendOn;
    protected PTextureFilterParams defFilterParams;
}
