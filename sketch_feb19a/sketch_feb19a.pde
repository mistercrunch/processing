void setup()
{
  float rad1 = atan2(1,9);
  println("Angle1:"+ ((rad1*360) / TWO_PI));
  float rad2 = atan2(4,10);
  println("Angle2:"+((rad2*360)/TWO_PI));
  
  float angle = TWO_PI - (2*(rad1+rad2));
  
  println("Sin:"+sin(angle));
  println("Cos:"+cos(angle));
  
  
}
