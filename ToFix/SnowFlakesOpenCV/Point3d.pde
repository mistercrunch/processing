
class Point3d
{
  float x,y,z;

  Point3d()
  { 
    x=y=z=0;
  }
  Point3d(float range)
  { 
    x= random(range)-(range/2);
    y= random(range)-(range/2);
    z= random(range)-(range/2);
  }
  Point3d(float daX, float daY, float daZ)
  { 
    x=daX;
    y=daY;
    z=daZ;
  }
  
  Point3d(Point3d p)
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
  float Distance(Point3d p)
  {
    float f = pow((float)x-p.x,2) + pow((float)y-p.y,2) + pow((float)z-p.z,2);
    return pow(f, 1.5);
  }
  
  void Sub(Point3d p)
  {
    x -= p.x;
    y -= p.y;
    z -= p.z; 
  }
  void Add(Point3d p)
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
  Point3d Clone()
  {
    Point3d tmp = new Point3d(x,y,z);
    return tmp;
  }
  
  void Become(Point3d p3d)
  {
    x = p3d.x;
    y = p3d.y;
    z = p3d.z;
  }
};

