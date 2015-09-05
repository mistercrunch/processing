class Square{
  Vect3d base_pos;
  Vect3d pos;
  Vect3d speed;
  float size;
  color c;
  int cycle_duration;
  int cycle_position;
  float life = 500;
  float opacity;

  float rX, rY, rZ;
  
  Square(){
    size = random(50)+30;
    float midsize=size/2;
    float pos_range=100;
    //base_pos = new Vect3d(random(pos_range)-pos_range/2,random(pos_range)-pos_range/2,random(pos_range)-pos_range/2);
    base_pos = new Vect3d(0,0,0);
    pos = base_pos.Clone();
    
    float speed_base = 10;
    speed = new Vect3d(random(speed_base)-speed_base/2,random(speed_base)-speed_base/2,random(speed_base)-speed_base/2);
    c = color(1);
    cycle_duration = (int)random(40)+5;
    opacity = 0.85;

    rY = random(PI);
  }
  
  void calc()
  {
    if (FLAG_GRAVITY) speed.z-=0.2;
    pos.Add(speed);
    if(COLOR_MODE==0)
    {
      if (cycle_position==0)
      {
        if(random(1)>0.5)
          c = color(0);
        else
          c = color(1);
      }
    }
    else if (COLOR_MODE==1)
    {
      c = color(sin(((float)cycle_position/(float)cycle_duration) * PI));
    }
    else if (COLOR_MODE==2)
    {
      c = color((float)cycle_position/(float)cycle_duration, 1,1);
    }
    
    cycle_position+=1;
    if (cycle_position>=cycle_duration) {
      cycle_position=0;
      //cycle_duration = (int)random(10)+10;
    }
    life-=1;
      
    
  }
  
  void draw()
  {
    float midsize=size/2;
    
    
    if (FLAG_ROTATE) rotateY(rY);
    if(!FLAG_CUBIC)
    {
      beginShape();
        fill(c, opacity);    
        vertex(pos.x-midsize, pos.y-midsize, pos.z);
        vertex(pos.x+midsize, pos.y-midsize, pos.z);
        vertex(pos.x+midsize, pos.y+midsize, pos.z);
        vertex(pos.x-midsize, pos.y+midsize, pos.z);
      endShape(CLOSE);
    }
    else
    {
      fill(c, opacity);
      translate(pos.x, pos.y, pos.z);
      box(size);
      translate(-pos.x, -pos.y, -pos.z);  
    }
    
    if (FLAG_ROTATE)rotateY(-rY);
    
  }
  
};
