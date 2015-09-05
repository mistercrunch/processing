//Simple class to store colors in OpenGL compatible format
//Processing stores color in an int where 2bytes are used for R, G, B, A
//OpenGL needs float values between 0-1
//This class stores in OpenGL format, removing the need for conversions, thus optimising
class ColorGL
{
  float r,g,b;
  
  ColorGL()
  {
    r=g=b=0;
  }
  ColorGL(color c)
  {
    SetColor(c);
  }
  ColorGL(ColorGL inCgl)
  {
    r=inCgl.r;
    g=inCgl.g;
    b=inCgl.b;
  }
  ColorGL(float inR, float inG, float inB)
  {
    SetColor(inR, inG, inB);
  }
  
  void SetColor(color c)
  {
    int currR = (c >> 16) & 0xFF; // Like red(), but faster
    int currG = (c >> 8) & 0xFF;
    int currB = c & 0xFF;
 
    r=(float)currR/255;
    g=(float)currG/255;
    b=(float)currB/255;
  }
  void SetColor(float inR, float inG, float inB)
  {
    r=inR;
    g=inG;
    b=inB;
  }
  ColorGL Clone()
  {
    ColorGL tmp = new ColorGL(r, g, b);
    return tmp;
  }
  void Randomize(float range)
  { 
    
    r += (random(range)) - range/2;
    
    g += (random(range)) - range/2;
    b += (random(range)) - range/2;
    
    FixRange(r);
    FixRange(g);
    FixRange(b);
  }
  
  float FixRange(float a)
  {
    if (a>1)a=1;
    else if (a<0)a=1;
    return a;
  }
};

