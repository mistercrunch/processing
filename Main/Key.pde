/*
Key as in key on a midi keyboard
*/
class Key
{
  int NoteNumber;
  ColorGL cgl;
  boolean isDown;
  Particle LatestParticle;
  Vect3d Pos;
  int LatestVelocity;
 
  Key(int iNoteNumber)
  {
    LatestVelocity=0;
    NoteNumber = iNoteNumber;
    AssignColor();
    
    Pos = new Vect3d();
    AssignPosition();
  }
  
  void Push(int inVelocity)
  {
    isDown=true;
    LatestVelocity = inVelocity;
    Particle p = new Particle(Pos, cgl, true, inVelocity);
    Particles.add(p);
    LatestParticle=p;
  }
  void Release()
  {
    if (isDown)
    {
      isDown=false;
      LatestParticle.isKeyPushed=false;
    }
  }
  
  void AssignPosition()
  {
    if(KEYS_LAYOUT_MODE==0)
    {
      Pos.x=((width/KEYS_WIDTH) * (NoteNumber+X_OFFSET));
      Pos.y=-250;  
      if(BLACK_KEYS_HIGHER!=0 && (NoteInScale()==1||NoteInScale()==3||NoteInScale()==6||NoteInScale()==8||NoteInScale()==10))
        Pos.y-=BLACK_KEYS_HIGHER;    
      Pos.z=Z_DEFAULT;
    }
    else if(KEYS_LAYOUT_MODE==1)
    {
      float f = ((float)NoteNumber/12) * 2 * (float)Math.PI;
      Pos.x = (sin(f)*height)+(height/2);
      Pos.y = (cos(f)*height)+(height/2);
      Pos.z = -900;
    }
  }
  
  void AssignColor()
  {
    int NoteInScale = NoteNumber % 12;
    float fHue=0;
    //Assigning color based on consonance / dissonance
    switch (NoteInScale)
    {
      case 0:   fHue=  (float)0/12;   break;
      case 1:   fHue=  (float)7/12;   break;
      case 2:   fHue=  (float)2/12;  break;
      case 3:   fHue=  (float)9/12;   break;
      case 4:   fHue=  (float)4/12;   break;
      case 5:   fHue=  (float)11/12;   break;
      case 6:   fHue=  (float)6/12;   break;
      case 7:   fHue=  (float)1/12;  break;
      case 8:   fHue=  (float)8/12;   break;
      case 9:   fHue=  (float)3/12;   break;
      case 10:  fHue=  (float)10/12;   break;
      case 11:  fHue=  (float)5/12;   break;
    }

    color c = color(fHue, 1, 1);
    cgl = new ColorGL(c);
  }
  int NoteInScale()
 {
   return NoteNumber % 12;
 } 
  String PitchLetter()
  {
    String S="";
    
    switch(NoteNumber % 12)
    {  
      case 0: S = "C";break;
      case 1: S = "C#";break;
      case 2: S = "D";break;
      case 3: S = "Eb";break;
      case 4: S = "E";break;
      case 5: S = "F";break;
      case 6: S = "F#";break;
      case 7: S = "G";break;
      case 8: S = "Ab";break;
      case 9: S = "A";break;
      case 10: S = "Bb";break;
      case 11: S = "B";break;  
    }
      
    return S;
  }
  int Octave()
  {
    return (int)NoteNumber/12;
  }
};
