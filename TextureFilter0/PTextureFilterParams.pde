/**
 * Texture library.
 * Processing library to handle openGL textures in a simplified way and define 2D filters on them.
 *
 * PTextureFilterParams stores the parameters for a filter.
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
 
public class PTextureFilterParams
{
    public PTextureFilterParams()
    {
        parFlt1 = parFlt2 = parFlt3 = 0.0;
        parMat2 = new float[2 * 2];
        parMat3 = new float[3 * 3];
        parMat4 = new float[4 * 4];
    }
    
    public void setMat2(int i, int j, float v)
    {
        parMat2[2 * i + j] = v; 
    }
    public float getMat2(int i, int j)
    {
        return parMat2[2 * i + j];  
    }

    public void setMat3(int i, int j, float v)
    {
        parMat3[3 * i + j] = v; 
    }
    public float getMat3(int i, int j)
    {
        return parMat3[3 * i + j];  
    }

    public void setMat4(int i, int j, float v)
    {
        parMat4[4 * i + j] = v; 
    }
    public float getMat4(int i, int j)
    {
        return parMat4[4 * i + j];  
    }
    
    public float parFlt1;
    public float parFlt2;
    public float parFlt3;
    public float[] parMat2;
    public float[] parMat3;
    public float[] parMat4;
}
