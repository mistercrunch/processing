class KeySet
{
  Key [] keys;
  int nbKeys;
  int FirstNoteNumber;
  int LastNoteNumber;
  
  KeySet(int First, int Last)
  {
    FirstNoteNumber=First;
    LastNoteNumber=Last;
    nbKeys = 128;
    //Creating a key object for each key
    keys = new Key [nbKeys];
    for(int i=0; i<nbKeys; i++)
    {
      keys[i] = new Key(i);
    }
    if(KEYS_LAYOUT_MODE==0)SetPositionLinear();
    else if(KEYS_LAYOUT_MODE==1)SetPositionSpiral();  
  }
  void PushAll()
  {
    for(int i=FirstNoteNumber; i<=LastNoteNumber; i++)
    {
      keys[i].Push(80);
      keys[i].Release();
    }
  }
  void SetPositionLinear()
  {
    for(int i=FirstNoteNumber; i<=LastNoteNumber; i++)
    {
      keys[i].Pos.x=((width/KEYS_WIDTH) * (i+X_OFFSET));
      keys[i].Pos.y=-(KEY_HEIGHT/2);  
      int NoteInScale=keys[i].NoteInScale();
      if(BLACK_KEYS_HIGHER!=0 && (NoteInScale==1||NoteInScale==3||NoteInScale==6||NoteInScale==8||NoteInScale==10))
        keys[i].Pos.y-=BLACK_KEYS_HIGHER;    
      keys[i].Pos.z=0;
    }
  }
  
  void SetPositionSpiral()
  {
    int iCpt=12;
    for(int i=FirstNoteNumber; i<=LastNoteNumber; i++)
    {
      
      float f = ((float)i/12) * 2 * (float)Math.PI;
      float fDistanceFromMiddle = ((float)(iCpt+12)/12) * (height/5);
      keys[i].Pos.x = (sin(f)*fDistanceFromMiddle);
      keys[i].Pos.y = (cos(f)*fDistanceFromMiddle);
      keys[i].Pos.z = 0;
      iCpt++;
    }
  }
};
