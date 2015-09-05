import processing.opengl.*;
import codeanticode.gsvideo.*;

int SquareSize=3;
boolean AUTOROTATE=false;
boolean DEPTH_VARIATION =true;
int defaseX,defaseY;
GSCapture video;
int RenderColorMode=1;
float DepthFactor=1.5;


void setup() {
  size(900, 700,OPENGL);  
  
  cursor(CROSS);
  frameRate(30);
  
  colorMode(HSB,256);  
  
  video = new GSCapture(this, 640, 480, 60);
  hint( ENABLE_OPENGL_2X_SMOOTH );
  
  defaseX = (width-video.width)/2;
  defaseY = (height-video.height)/2;
}

void draw() {
  
  noFill();
  lights();
 strokeWeight(1);
  background(0,20);
  if (video.available()) {
    video.read();
    video.loadPixels();
  }
    pushMatrix();
    translate(width/2, height/2, 0);
    
    if(AUTOROTATE)
      rotateY(radians(millis())/15);
    else
    {
      rotateX(radians(-(mouseY-(height/2)))/2);
      rotateY(radians((mouseX-(width/2)))/2);
      
    }
    translate(-width/2, -height/2, 0);
    int index = 0;
    int pixelValue;
    
    for (int y = 0; y < video.height; y+=SquareSize) {
      beginShape();
      for (int x = 0; x < video.width; x+=SquareSize) 
      {       
        DrawVertex(x,y);
        index++;
      }
      endShape();
    }
    index = 0;
    for (int x = 0; x < video.width; x+=SquareSize) {
      beginShape();
      for (int y = 0; y < video.height; y+=SquareSize) 
      {       
        DrawVertex(x,y);
        index++;
      }
      endShape();
    }
    
      
    popMatrix();
  
}
void DrawVertex(int x, int y)
    {
        color c = video.pixels[x+(y*video.width)];
        int iBright = GetGrayScale(c);
        float z=iBright/DepthFactor;
        if (RenderColorMode==1)
        { 
          stroke(255-iBright,255,iBright);
        }
        else if (RenderColorMode==2)
        { 
          stroke(iBright,255,iBright);
        }
        else if (RenderColorMode==3)
        {
          stroke(c);
        }
        else if (RenderColorMode==4)
        {
          stroke(color(0, 0,brightness(c)));
        }
        
        if(!DEPTH_VARIATION)z=0;
        
        vertex (defaseX+x, defaseY+y, z);
        
        
    }
int missedframes=0;
int GetGrayScale(color c)
{
        int currR = (c >> 16) & 0xFF; // Like red(), but faster
        int currG = (c >> 8) & 0xFF;
        int currB = c & 0xFF;
 
        // Add these differences
        return (currR + currG + currB)/3;
}

void keyPressed()
{
  if(key=='q' && SquareSize >2)
    SquareSize--;
  else if(key=='a')
    SquareSize++;
  else if(key=='r')
    AUTOROTATE=!AUTOROTATE;
  else if(key=='w')
    DepthFactor+=0.1;
  else if(key=='s')
    DepthFactor-=0.1;
  else if(key=='x')
    DEPTH_VARIATION=!DEPTH_VARIATION;
  else if(key=='1')
    RenderColorMode=1;
  else if(key=='2')
    RenderColorMode=2;
  else if(key=='3')
    RenderColorMode=3;
  else if(key=='4')
    RenderColorMode=4;
  
  
  
}
