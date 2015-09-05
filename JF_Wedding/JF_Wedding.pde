void setup()
{
  size(1600,2100);
  int nbColor=5;
  color [] palette = new color[nbColor];
  palette[0] = color(218,17,0);//Red
  palette[1] = color(248,52,0);//Orange
  palette[2] = color(235,223,2);//Yellow
  palette[3] = color(136,224,20);//Pale Green
  palette[4] = color(56,94,49);//Green
  stroke(0);smooth();
  background(255);
  int MARGIN=400;
  
  for(int i=0; i<150; i++){
    float maxDrift=25;
    fill(palette[int(random(nbColor))], 32);
    float x=random(width-(MARGIN*2))+MARGIN;float y=random(height-(MARGIN*2))+MARGIN;
    for(float largeness = 150+random(100); largeness>3; largeness-=2){
      x +=((random(maxDrift)-(maxDrift/2)) * largeness) / 100 ;
      y +=((random(maxDrift)-(maxDrift/2)) * largeness) / 100 ;
      ellipse(x,y, largeness,largeness);
    }
  }
  save("/home/mistercrunch/WeddingCard.tif");
}


