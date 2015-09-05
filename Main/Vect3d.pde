
class Vect3d
{
  float x,y,z;

  Vect3d()
  { 
    x=y=z=0;
  }
  Vect3d(float range)
  { 
    x= random(range)-(range/2);
    y= random(range)-(range/2);
    z= random(range)-(range/2);
  }
  Vect3d(float daX, float daY, float daZ)
  { 
    x=daX;
    y=daY;
    z=daZ;
  }
  
  Vect3d(Vect3d p)
  { 
    x=p.x;
    y=p.y;
    z=p.z;
  }

  void Randomize(float range)
  { 
    x += (random(range)) - range/2;
    y += (random(range)) - range/2;
    z += (random(range)) - range/2;
  }
  float Distance()
  {
    float f = pow((float)x,2) + pow((float)y,2) + pow((float)z,2);
    return pow(f, 0.5);
  } 
  float Distance(Vect3d p)
  {
    float f = pow((float)x-p.x,2) + pow((float)y-p.y,2) + pow((float)z-p.z,2);
    return pow(f, 0.5);
  }
  
  void Sub(Vect3d p)
  {
    x -= p.x;
    y -= p.y;
    z -= p.z; 
  }

  void Add(Vect3d p)
  {
    x += p.x;
    y += p.y;
    z += p.z; 
  }
  void Div(float fDivider)
  {

    x /= fDivider;
    y /= fDivider;
    z /= fDivider;
  }
  void Multiply(float multiplier)
  {
    x *= multiplier;
    y *= multiplier;
    z *= multiplier;
  }
  Vect3d Clone()
  {
    Vect3d tmp = new Vect3d(x,y,z);
    return tmp;
  }
  
  void Clone(Vect3d v3d)
  {
    x=v3d.x;
    y=v3d.y;
    z=v3d.z;
  }
  
  void Become(Vect3d p3d)
  {
    x = p3d.x;
    y = p3d.y;
    z = p3d.z;
  }
};

