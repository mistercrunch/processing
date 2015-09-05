

class System
{
  int maxBalls=50;
  int nbBalls;
  Ball [] Balls;
  Point3d Middle;

  float RaySize;
  float SpeedControl;
  Ball MouseBall;
  boolean showMouseBall = false;
  
  System(float ScreenSize, int iNbBalls, int MARGIN)
  {
    SpeedControl = 1;
    RaySize = (ScreenSize/2) - (MARGIN);
    nbBalls = iNbBalls;
    Balls = new Ball[maxBalls];
    MouseBall = new Ball(0);
    for(int i=0;i<nbBalls;i++)
    {
      Balls[i] = new Ball(RaySize);
    }   
    Middle = new Point3d(width/2, height/2, RaySize);
  }
  void Chaos()
  {
     //flips vectors of about half of the balls
     for(int i=0;i<nbBalls;i++)
     {
       int flip = (int)random(2);
       if(flip==0)
       {
         Point3d tmp = Balls[i].LastPosition.Clone();
         Balls[i].LastPosition.Become(Balls[i].Position);
         Balls[i].Position.Become(tmp);
       }
     }
  }
  float AverageSpeed()
  {
    float SumSpeed=0;
    for(int i=0; i<nbBalls;i++)
    {
      SumSpeed += Balls[i].LastPosition.Distance(Balls[i].Position);
    }
    return SumSpeed/nbBalls;
  }
  void ManageSpeed()
  {
    float AvSpeed = AverageSpeed();
    if (AvSpeed>5000)
      SpeedControl *=.9995;
    else if(AvSpeed<1000)
       SpeedControl *=1.0005;
  }
  void AddBall()
  {
    if (nbBalls < maxBalls-1)
    {
      Balls[nbBalls] = new Ball(RaySize);
      nbBalls++;
    }
  }
  void RemoveBall()
  {
    if (nbBalls > 1)
    {
      nbBalls--;
      Balls[nbBalls] = null;
    }
  }
  void CalcNextFrame(int iBallNum)
  { 
    Point3d curPos = Balls[iBallNum].Position.Clone(); 
    
    Point3d vSum = new Point3d();
    
    for(int i=0;i<nbBalls;i++)
    {

      Point3d vDistance = Balls[iBallNum].Position.Clone();
      vDistance.Sub(Balls[i].Position);
      float D = vDistance.Distance();

      if (D != 0)
      {    
        vDistance.Div(D);
        vSum.Add(vDistance);
      }    
    }    

    //Calculating next position based on last one
    Point3d vDiff = Balls[iBallNum].Position.Clone();
    vDiff.Sub(Balls[iBallNum].LastPosition);
    vDiff.Multiply(SpeedControl);
    Balls[iBallNum].Position.Add(vDiff);

    //Adding forces of other balls previously calculated
    vSum.Multiply(Repulsion);
    //println(vSum.Distance());
    Balls[iBallNum].Position.Add(vSum);
    
    //Calculating MouseBall repulsion
    if(showMouseBall)
    {
      Point3d vDistance = Balls[iBallNum].Position.Clone();
      vDistance.Sub(Sys.MouseBall.Position);
      float D = vDistance.Distance();

      if (D != 0)
      {    
        vDistance.Div(D);
        vDistance.Multiply( MouseBallStrength);
        Balls[iBallNum].Position.Add(vDistance);
      }    
    }

    float D = Balls[iBallNum].Position.Distance();

    if (D > Sys.RaySize)
    {
      Balls[iBallNum].Position.Multiply(RaySize / D);
    }

    Balls[iBallNum].LastPosition.Become(curPos);
  }
  void GenerateSubParticles()
  {
    for(int i=0; i<Sys.nbBalls; i++)  
    {
      color c = color(random(.15)+.55,0,1);
      SubParticles.add( new SubParticle(c, Balls[i]) );    
      SubParticles.add( new SubParticle(c, Balls[i]) );    
      SubParticles.add( new SubParticle(c, Balls[i]) );    
    }
  }

};



