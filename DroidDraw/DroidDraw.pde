boolean was_pressed = false;
color bg_color = color(0,1,1);
color fg_color = color(0.5,1,1);
int start_x = 0;
int start_y = 0;

void setup(){
  colorMode(HSB,1);
  size(320, 480);
  frameRate(30);
  
  background(bg_color);
  strokeWeight(15);
  
}
void draw(){
  float circle_size = 10;
  fill(fg_color);
  stroke(fg_color);
  
  if(mousePressed) {
    if(was_pressed){
      line(mouseX, mouseY, pmouseX, pmouseY);
    }
    else{
      fg_color = color(random(1),1,1);
      start_x = mouseX;
      start_y = mouseY;
    }
    was_pressed = true;
  }
  else{
    if(mouseX==start_x && mouseY==start_y)
      background(bg_color);    
    was_pressed = false;
  }  
}
