

void setup()
{
  size(600,600);
  background(0);
  smooth();
  
  DrawRing(12, 15, 200, color(255,0,0));
  DrawRing(25, 25, 300, color(0,255,0));
  DrawRing(50, 5, 50, color(255,0,255));
  DrawCircle(125, 4, color(0,0,255));
  //DrawRing(12, 15, 200, color(255,0,0));
  //DrawRing(12, 15, 200, color(255,0,0));
}

void DrawRing(int nbCircle, float cicleSize, float cicleDistance, color col)
{
  for(int c = 0; c<nbCircle; c++){
    fill(col);
    stroke(col);
    float x = cicleDistance * sin((TWO_PI / (float)nbCircle) * c);
    float y = cicleDistance * cos((TWO_PI / (float)nbCircle) * c);
    ellipse(x+(width/2),y+(height/2), cicleSize, cicleSize);
  }
}

void DrawCircle(float circleSize, float thickness, color col){
  stroke(col);
  strokeWeight(thickness);
  noFill();
  ellipse(width/2,(height/2), circleSize,circleSize);
}

void DrawFilledCircle(float circleSize, color col){
  stroke(col);
  //strokeWeight(col);
  fill(col);
  ellipse(width/2,(height/2), circleSize,circleSize);
}
