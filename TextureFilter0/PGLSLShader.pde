/**
 * Texture library.
 * Processing library to handle openGL textures in a simplified way and define 2D filters on them.
 *
 * PGLSLShader class to hangle glsl shaders.
 * v0.6
 * Changes:
 * Slightly better handling of error upon initialization.
 * ToDo: 
 * Add support for geometry shader.
 * Author: 
 * JohnG, Andres Colubri
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

import javax.media.opengl.*;
import com.sun.opengl.util.*;
import java.nio.*;

public class PGLSLShader
{
    public PGLSLShader(GL gl)
    {
        this.gl = gl;
        programObject = gl.glCreateProgramObjectARB();
        vertexShader = -1;
        fragmentShader = -1;
    }

    public void loadVertexShader(String file)
    {
        String shaderSource = join(loadStrings(file), "\n");
        vertexShader = gl.glCreateShaderObjectARB(GL.GL_VERTEX_SHADER_ARB);
        gl.glShaderSourceARB(vertexShader, 1, new String[]{shaderSource}, (int[]) null, 0);
        gl.glCompileShaderARB(vertexShader);
        checkLogInfo("Vertex shader compilation: ", vertexShader);
        gl.glAttachObjectARB(programObject, vertexShader);
    }

    public void loadFragmentShader(String file)
    {
        String shaderSource = join(loadStrings(file), "\n");
        fragmentShader = gl.glCreateShaderObjectARB(GL.GL_FRAGMENT_SHADER_ARB);
        gl.glShaderSourceARB(fragmentShader, 1, new String[]{shaderSource},(int[]) null, 0);
        gl.glCompileShaderARB(fragmentShader);
        checkLogInfo("Fragment shader compilation: ", fragmentShader);
        gl.glAttachObjectARB(programObject, fragmentShader);
    }

    public int getAttribLocation(String name)
    {
        return(gl.glGetAttribLocationARB(programObject, name));
    }

    public int getUniformLocation(String name)
    {
        return(gl.glGetUniformLocationARB(programObject, name));
    }

    public void linkProgram()
    {
        gl.glLinkProgramARB(programObject);
        gl.glValidateProgramARB(programObject);
        checkLogInfo("GLSL program validation: ", programObject);
    }

    public void start()
    {
        gl.glUseProgramObjectARB(programObject);
    }

    public void stop()
    {
        gl.glUseProgramObjectARB(0);
    }

    protected void checkLogInfo(String title, int obj)
    {
        IntBuffer iVal = BufferUtil.newIntBuffer(1);
        gl.glGetObjectParameterivARB(obj, GL.GL_OBJECT_INFO_LOG_LENGTH_ARB, iVal);

        int length = iVal.get();
        
        if (length <= 1) 
        {
            return;
        }    
        
        // Some error ocurred...
        ByteBuffer infoLog = BufferUtil.newByteBuffer(length);
        iVal.flip();
        gl.glGetInfoLogARB(obj, length, iVal, infoLog);
        byte[] infoBytes = new byte[length];
        infoLog.get(infoBytes);
        System.err.println(title);
        System.err.println(new String(infoBytes));
    }
    
    protected GL gl;
    protected int programObject;
    protected int vertexShader;
    protected int fragmentShader;    
}
