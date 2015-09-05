class Background{
  color current_color;
  int cycle_duration;
  int cycle_position;
  float alpha;
  int bg_mode;
  
  Background()
  {
    current_color = color(0);
    alpha=0;
    cycle_position = 0;
    cycle_duration = 10;
    bg_mode=1;
  }
  
  void Calc(){
    
    if(cycle_position>= cycle_duration)
      cycle_position=0;
    
    if(bg_mode==1)
      current_color = color((float)cycle_position/ cycle_duration);
    else if(bg_mode==2)
    {
      if(cycle_position< (cycle_duration/2))
        current_color=color(0);
      else
        current_color=color(1);
    }  
    cycle_position+=1; 
  }
  
  void Draw(){
    if(alpha != 0)
      background(current_color);
    else
      background(current_color, alpha);
  }
  void SetColor(color c){
  //Only for mode 0
    current_color = c;
  }
  void NextMode()
  {
    int nbMode = 3;
    bg_mode+=1;
    if (bg_mode>= nbMode)
      bg_mode=0;
  }

};
