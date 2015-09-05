
class Ball
{
  int DefasageX, DefasageY;
  Point3d Position = new Point3d();
  Point3d LastPosition = new Point3d();
  color c;
  float HueIncrement;

  Ball(float RaySize)
  {   
    
    HueIncrement = random(0.03);
    Position.x = (random(RaySize)) - (RaySize/2);
    Position.y = (random(RaySize)) - (RaySize/2);
    Position.z = (random(RaySize)) - (RaySize/2);
    LastPosition.x = Position.x - random(50);
    LastPosition.y = Position.y - random(50);  
    LastPosition.z = Position.z - random(50);
    
    //c = color(random(0.15),1,1);
    c = color(random(1),1,1);
  }

  void Display(float RaySize)
  {
    if(COLORSHIFT)
    {
      float fHue = hue(c)+HueIncrement;
      if(fHue>1)fHue-=1;
      c= color(fHue, saturation(c), brightness(c));
    }
    
    float zMod = ((Position.z+RaySize) / 3) + 50;
    renderImage(Position, 150, c, 1);
    
  }
};
