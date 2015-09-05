class KeySet
{
  Key [] keys;
  int nbKeys;
  
  KeySet(int inNbKeys)
  {
    nbKeys = inNbKeys;
    //Creating a key object for each key
    keys = new Key [nbKeys];
    for(int i=0; i<nbKeys; i++)
    {
      keys[i] = new Key(i);
    }
  }
};
