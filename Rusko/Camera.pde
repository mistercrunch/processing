class Camera{
  Vect3d anchor;
  Vect3d pos;
  Vect3d speed;
  int mode;
  float DISTANCE;
  float speed_target;
  
  Camera(){
    anchor = new Vect3d(500,0,0);
    speed = new Vect3d(0,0,0);
    pos = anchor.Clone();
    mode = 1;
    speed_target = 20;
    DISTANCE = 500;
    
  }
  
  void Calc(){
    if (mode==0)
    {
      //Mouse controled
      ///////////////////////////////////////////////////
      //Calculating perspective
      float percX=(((float)mouseX ) -((float)width)) / width;
      float percY=(float)mouseY / (height*2);
      
      float radX = percX * TWO_PI;
      float radY = percY * TWO_PI;
      pos.x    = sin(radX) * sin(radY) * DISTANCE;
      pos.y    = cos(radY) * DISTANCE;
      pos.z    = cos(radX) * -sin(radY) * DISTANCE;
    }
    else if (mode==1)
    {
      pos.Add(speed);
      speed.Randomize(5);
      if (speed.Distance() > speed_target)
        speed.Multiply(0.9999);
      else
        speed.Multiply(1.00001);
      
      Vect3d d = pos.Clone();
      d.Sub(anchor);
      d.Multiply(0.001);
      speed.Sub(d);
    }
    
  }
  
  void Draw(){
    camera(pos.x, pos.y, pos.z,   0,0,0,   0,1,0);
  }
  
  void RandomPos(){
    float base = 500 + random(1000);
    anchor.x = random(base) - (base/2); 
    anchor.y = random(base) - (base/2); 
    anchor.z = random(base) - (base/2); 
    
    pos = anchor.Clone();
  }
};
