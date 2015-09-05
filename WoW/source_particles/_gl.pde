
// Any time I want to draw a square, I use the squareList.
// Should be slightly faster than calling all the vertex calls over and over.
int squareList;
void initGL(){
  pgl.beginGL();
  squareList = gl.glGenLists(1);
  gl.glNewList(squareList, GL.GL_COMPILE);
  gl.glBegin(GL.GL_POLYGON);
  gl.glTexCoord2f(0, 0);    gl.glVertex2f(-.5, -.5);
  gl.glTexCoord2f(1, 0);    gl.glVertex2f( .5, -.5);
  gl.glTexCoord2f(1, 1);    gl.glVertex2f( .5,  .5);
  gl.glTexCoord2f(0, 1);    gl.glVertex2f(-.5,  .5);
  gl.glEnd();
  gl.glEndList();
  pgl.endGL();
}

// It would be faster to just make QUADS calls directly to the loc
// without dealing with pushing and popping for every particle. The reason
// I am doing it this longer way is due to a billboarding problem which will come
// up later on.
void renderImage( Vec3D _loc, float _diam, color _col, float _alpha){

  
  gl.glPushMatrix();
  gl.glTranslatef( _loc.x, _loc.y, _loc.z );
  gl.glScalef( _diam *2, _diam*2, _diam*2 );
  gl.glColor4f( red(_col), green(_col), blue(_col), _alpha );
  //gl.glColor4f( random(1), 1, 1, 1 );
  gl.glCallList( squareList );
  gl.glPopMatrix();
}

