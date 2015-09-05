class SubParticle
{
  Point3d pos;
  Point3d vel;
  color c;
  int lifeSpan;
  int age;
  
  Ball MotherBall;
  
  SubParticle(color _c, Ball b)
  {
    pos = new Point3d(b.Position);
    vel = new Point3d(7);
    MotherBall = b;
    lifeSpan = (int) random(15)+15;
    age = 0;
    c= MotherBall.c;
    //c=color(random(1),1,1);
  }
  
  void Move()
  {
    //Gravity for particles?
    //vel.y+=1;
    pos.Add(vel);
    age++;
  }
  
  void Display()
  {
    float zMod = ((pos.z+Sys.RaySize) / 75) + 60;
    
    float percentLife = (float)(lifeSpan-age) / lifeSpan;
    color tmpCol = color(hue(c), saturation(c),  1);
    
    //random glitter
    /*
    if (random(1) < 0.1)
    {
      tmpCol = color(1,0,1);
      zMod=10;
    }
    */ 
    
    renderImage(pos, 75*percentLife, tmpCol, 1);
  }
  
};
