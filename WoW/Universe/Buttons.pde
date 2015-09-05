void ButtonEvents(int x, int y)
{
  if(ButtonOver())
    cursor(HAND);
  else
    cursor(CROSS);
    
  if(locked == false) {
    AddBall.update();
    RemoveBall.update();
    Chaos.update();
  } 
  else {
    locked = false;
  }
  if(mousePressed && millis() - LastEventMillis > 200) {
    boolean EventHappened = false;
    if(AddBall.pressed()) {
      Sys.AddBall();
      EventHappened = true;
    }
    else if(RemoveBall.pressed()) {
      Sys.RemoveBall();
      EventHappened = true;
    }
    else if(Chaos.pressed()) {
      background(0);
      Sys.Chaos();
      EventHappened = true;
    }
      
    if (EventHappened)
    {
      LastEventMillis = millis();
    }
  }
}

boolean ButtonOver()
{
  if(Chaos.over() || AddBall.over() || RemoveBall.over())
    return true;
  else
    return false;
}

class CircleButton extends Button
{ 
  CircleButton(int ix, int iy, int isize, color icolor, color ihighlight) 
  {
    x = ix;
    y = iy;
    size = isize;
    basecolor = icolor;
    highlightcolor = ihighlight;
    currentcolor = basecolor;
  }

  boolean over() 
  {
    if( overCircle(x, y, size) ) {
      over = true;
      return true;
    } 
    else {
      over = false;
      return false;
    }
  }

  void display() 
  {
    stroke(255);
    fill(currentcolor);
    pgMenu.ellipse(x, y, size, size);
  }
}

class RectButton extends Button
{
  RectButton(int ix, int iy, int isize, color icolor, color ihighlight) 
  {
    x = ix;
    y = iy;
    size = isize;
    basecolor = icolor;
    highlightcolor = ihighlight;
    currentcolor = basecolor;
  }

  boolean over() 
  {
    if( overRect(x, y, size, size) ) {
      over = true;
      return true;
    } 
    else {
      over = false;
      return false;
    }
  }

  void display() 
  {
    stroke(1);
    fill(currentcolor);
    pgMenu.rect(x, y, size, size);
  }
}

void mousePressed()
{
  if(mouseButton==RIGHT)
  {
    Sys.showMouseBall= !Sys.showMouseBall;
  }
}


class Button
{
  int x, y;
  int size;
  color basecolor, highlightcolor;
  color currentcolor;
  boolean over = false;
  boolean pressed = false;   

  void update() 
  {
    if(over()) {
      float myHue = hue(highlightcolor)+0.01;
      if (myHue>1) myHue -= 1;
      highlightcolor=color(myHue, 255,255);
      currentcolor = highlightcolor;
      
    } 
    else {
      currentcolor = basecolor;
    }
  }

  boolean pressed() 
  {
    if(over) {
      locked = true;
      return true;
    } 
    else {
      locked = false;
      return false;
      
    }    
  }

  boolean over() 
  { 
    
    return true; 
  }

  boolean overRect(int x, int y, int width, int height) 
  {
    
    if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
      return true;
    } 
    else {
      return false;
    }
  }

  boolean overCircle(int x, int y, int diameter) 
  {
    float disX = x - mouseX;
    float disY = y - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
      return true;
    } 
    else {
      return false;
    }
  }

}

