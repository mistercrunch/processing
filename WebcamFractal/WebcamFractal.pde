import processing.opengl.*;
import javax.media.opengl.*;
import com.sun.opengl.util.texture.*;
import codeanticode.gsvideo.*;
import codeanticode.glgraphics.*;

float RATIO=20;
GSCapture video;
GLTextureMax texFrame;

void setup()
{
  size(640, 480, GLConstants.GLGRAPHICS);  
  
  cursor(CROSS);
  frameRate(30);
  
  colorMode(HSB,256);  
  
  video = new GSCapture(this, 640, 480, 30);  
  texFrame = new GLTextureMax(this, video.width, video.height);
}
float VidSize=20;
void draw()
{
  println(frameRate);
  if (video.available()) 
  {
    VidSize*=1.05;
    background(0);
    video.read();
    
    PImage PThumb = CopyPImage(video);
    PThumb.resize((int)VidSize,(int)VidSize);
    texFrame.putImage(PThumb);
    //texFrame.setFlippedX(true);
    
    
    for(int x=0;x<width;x+=VidSize)
    {
      for(int y=0;y<height;y+=VidSize)
      {
        float avB = AverageBrightness(video, x,y, (int)VidSize,(int)VidSize);
        texFrame.renderTextureColor(x,y, (int)VidSize,(int)VidSize,1,1,1,avB);
      }
    }
  }
}

float AverageBrightness(GSCapture pImg, int inX, int inY, int inWidth, int inHeight)
{
  int i=0;
  float sum=0;
  pImg.loadPixels();
  
  if(inX+inWidth>=pImg.width)
  {
    if(inX>=pImg.width)
      return 0;
    else
      inWidth = pImg.width-(inX+1);
  }
  if(inY+inHeight>=pImg.height)
  {
    if(inY>=pImg.height)
      return 0;
    else
      inHeight = pImg.height-(inY+1);
  }
  for(int x=inX; x<inX+inWidth; x++)
  {
    for(int y=inY; y<inY+inHeight; y++)
    {
      sum+=GetGrayScale(pImg.pixels[(y*pImg.width)+x]);
      i++;
    }
  }
  return sum/(float)i;
}

float GetGrayScale(color c)
{
        int currR = (c >> 16) & 0xFF; // Like red(), but faster
        int currG = (c >> 8) & 0xFF;
        int currB = c & 0xFF;
 
        // Add these differences
        return (float)(currR + currG + currB)/(float)(3*255);
}


PImage CopyPImage(PImage p)
{
  PImage newP = new PImage(p.width, p.height);
  newP.loadPixels();
  p.loadPixels();
  for(int i=0;i<p.width*p.height; i++)
  {
    newP.pixels[i]=p.pixels[i];
  }
  newP.updatePixels();
  return newP;
}

