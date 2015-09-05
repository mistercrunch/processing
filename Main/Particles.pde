class Particle
{
  Vect3d Pos, Speed;
  ColorGL cgl;
  int OriginalSize;
  int Age;
  float LifeLenght;
  int Generation;
  boolean isKeyPushed;
  
  Particle(Vect3d v3d, ColorGL inColor, boolean isDown, int Velocity)
  {
    Generation=0;
    Pos = new Vect3d(v3d);
    Speed = new Vect3d(15);
    OriginalSize= (int)(Velocity*6 )+60;
    LifeLenght=LIFELENGHT;
    Speed = new Vect3d();
    //LifeLenght=30;
    cgl = new ColorGL(inColor);
    isKeyPushed=isDown;
    
  }
  
  Particle(Particle p)
  {
    Generation=p.Generation+1;
    Pos = new Vect3d(p.Pos);
    Speed = new Vect3d(p.Speed);
    OriginalSize=p.OriginalSize;
    Age=p.Age;
    LifeLenght=p.LifeLenght;
    isKeyPushed=false;
    cgl=new ColorGL(p.cgl);
  }
  
  void Move()
  {
    
    if(!isKeyPushed)
    {
      
      if(GRAVITY!=0)
      {
        Speed.y +=GRAVITY;
        Pos.Add(Speed);
        if(Pos.y >= FLOOR)
        {
        
          //If the ball has hit the floor
          Speed.y=-Speed.y;
          Pos.Add(Speed);
          Speed.y*=BOUNCE;
        
          float range=(Speed.y/2)*BOUNCE_RANDOMNESS;
        
          if(Generation<=MAXGENERATION)
          {
            //Split in three!
            
            Particle p1 = new Particle(this);
            Particle p2 = new Particle(this);
            ParticlesToAdd.add(p1);
            ParticlesToAdd.add(p2);
            
            Generation++;
            
            p1.Speed.Randomize(range);
            p2.Speed.Randomize(range);
            Speed.Randomize(range);
            p1.Age++;
            p2.Age++;
          }
        }
      }  
      if(VORTEX)
      {
        float Distance = v3dVortex.Distance(Pos);
        println((int)(Distance));
        float VortexAccleration=1;
        Vect3d v3dDiff = v3dVortex.Clone();
        v3dDiff.Sub(Pos);
        v3dDiff.Multiply(Distance /10000);
        
        Speed.Add(v3dDiff);
        Speed.Multiply(0.9);
        /*
        if(Pos.x > v3dVortex.x)Speed.x-=VortexAccleration;
        if(Pos.x < v3dVortex.x)Speed.x+=VortexAccleration;
        if(Pos.y > v3dVortex.y)Speed.y-=VortexAccleration;
        if(Pos.y < v3dVortex.y)Speed.y+=VortexAccleration;
        */
        Pos.Add(Speed);
      }
      
      Age++;
    } 
  }
  
  void Draw()
  {
        float tmpSize=CurrentSize();       
     
        if (tmpSize>0)
        gl.renderImage(Pos, CurrentSize(), cgl, 1);    
  }
  
  float CurrentSize()
  {
    if(Age < LifeLenght)
    {
      float lifePerc = (float)abs(Age-LifeLenght)/LifeLenght;
      if(Generation==0)
        return (float)(OriginalSize*lifePerc);
      else
        return (float)(OriginalSize*lifePerc) / (Generation * 1.5);
    }
    else
      return 0;
    
  }
};
