
class Cell
{
  PImage pImg;
  Vect2d v2dCur, v2dOrigin, v2dVel;
  int ConfortDistance;
  
  Cell(PImage _p, Vect2d v)
  {
    pImg = _p;
    v2dOrigin = v.Clone();
    v2dCur = v.Clone();
    v2dVel= new Vect2d(0,0);
    ConfortDistance=(int)random(20)+5;
  }
  void Blend()
  {
    
    blend(pImg, 0,0, cellSize, cellSize, (int)v2dCur.x, (int)v2dCur.y, cellSize, cellSize, ADD);   
  }
  
  void AdjustVel()
  {
    Vect2d v2dMouse = new Vect2d(mouseX, mouseY);
    Vect2d v2dMouseDist = v2dCur.Sub(v2dMouse);
    
    float mouseDistance = v2dMouseDist.Distance();
    if(mousePressed)
    {  
      v2dMouseDist.Div(mouseDistance);
      if (mouseButton==LEFT)
        v2dVel.Add(v2dMouseDist);
      else
        v2dVel.Minus(v2dMouseDist);
    }
    
    Vect2d v = v2dOrigin.Sub(v2dCur);
    v.Div(100);
    v2dVel.Add(v);
    v2dVel.Div(1.02);
    if(v2dVel.Distance()<0.5 && v2dOrigin.Distance(v2dCur) < 0.5) 
    {
      v2dVel.x=0;
      v2dVel.y=0;
      v2dCur = v2dOrigin.Clone();
    }
    
  }
  void Move()
  {
    v2dCur.Add(v2dVel);
  }
}
