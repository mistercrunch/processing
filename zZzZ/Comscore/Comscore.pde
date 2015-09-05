import java.io.BufferedInputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement; 

int MARGIN = 50;
int POS_RANDOMIZER_FACTOR=40;
float xScale=1; 
float yScale=1;
void setup()
{
  size(1000, 1000, P2D);
  stroke(0,100);
  background(255);
  String SID = "jdbc:oracle:thin:@(DESCRIPTION =" ;
  SID += "(ADDRESS = (PROTOCOL = TCP)(HOST = db1-vip.pie.corp.sk1.yahoo.com)(PORT = 1521)) ";
  SID += "  (ADDRESS = (PROTOCOL = TCP)(HOST = db2-vip.pie.corp.sk1.yahoo.com)(PORT = 1521)) ";
  SID += "  (ADDRESS = (PROTOCOL = TCP)(HOST = db3-vip.pie.corp.sk1.yahoo.com)(PORT = 1521)) ";
  SID += "  (ADDRESS = (PROTOCOL = TCP)(HOST = db4-vip.pie.corp.sk1.yahoo.com)(PORT = 1521)) ";
  SID += "  (ADDRESS = (PROTOCOL = TCP)(HOST = db5-vip.pie.corp.sk1.yahoo.com)(PORT = 1521)) ";
  SID += "  (ADDRESS = (PROTOCOL = TCP)(HOST = db6-vip.pie.corp.sk1.yahoo.com)(PORT = 1521)) ";
  SID += "  (ADDRESS = (PROTOCOL = TCP)(HOST = db7-vip.pie.corp.sk1.yahoo.com)(PORT = 1521)) ";
  SID += "  (ADDRESS = (PROTOCOL = TCP)(HOST = db8-vip.pie.corp.sk1.yahoo.com)(PORT = 1521)) ";
  SID += " (ADDRESS = (PROTOCOL = TCP)(HOST = db9-vip.pie.corp.sk1.yahoo.com)(PORT = 1521)) ";
  SID += "  (ADDRESS = (PROTOCOL = TCP)(HOST = db10-vip.pie.corp.sk1.yahoo.com)(PORT = 1521)) ";
  SID += "  (ADDRESS = (PROTOCOL = TCP)(HOST = db11-vip.pie.corp.sk1.yahoo.com)(PORT = 1521)) ";
  SID += "  (ADDRESS = (PROTOCOL = TCP)(HOST = db12-vip.pie.corp.sk1.yahoo.com)(PORT = 1521)) ";
  SID += "  (ADDRESS = (PROTOCOL = TCP)(HOST = db13-vip.pie.corp.sk1.yahoo.com)(PORT = 1521)) ";
  SID += "  (ADDRESS = (PROTOCOL = TCP)(HOST = db14-vip.pie.corp.sk1.yahoo.com)(PORT = 1521)) ";
  SID += "  (ADDRESS = (PROTOCOL = TCP)(HOST = db15-vip.pie.corp.sk1.yahoo.com)(PORT = 1521)) ";
  SID += "  (ADDRESS = (PROTOCOL = TCP)(HOST = db16-vip.pie.corp.sk1.yahoo.com)(PORT = 1521)) ";
  SID += "  (LOAD_BALANCE = yes) ";
  SID += "  (CONNECT_DATA = ";
  SID += "    (SERVER = DEDICATED) ";
  SID += "    (SERVICE_NAME = PIEDB) ";
  SID += "))";
  
   try
   {
DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
//  Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:SATURNDB3.world","COMSCORE","COMSCORE"); 
Connection conn = DriverManager.getConnection(SID,"COMSCORE","COMSCORE"); 
        

        Statement stmt = conn.createStatement();
        ResultSet rset = stmt.executeQuery("SELECT * FROM (SELECT * FROM V_AGG_SEGMENT_TMP ORDER BY MACHINE_ID) WHERE ROWNUM < 50000 ");
        int i=0;
        float xPos,yPos;
        while (rset.next())
        {
             i++;
             //println (rset.getString(1));   // Print col 1
             xPos=MARGIN + (rset.getFloat(2)/xScale) * (width  -(MARGIN*2));
             yPos=MARGIN + ((1-rset.getFloat(3))/yScale) * (height -(MARGIN*2));
             DrawSquare(xPos, yPos); 
             //println(Float.toString(rset.getFloat(2)) + ":" + Float.toString(rset.getFloat(3)));
             //println(xPos);
             //println(yPos);
             //println("");
             if(i %1000 ==0)
               println("Loaded "+ i);
        }
        stmt.close();
   }
   catch(Exception e)
   {
    print(e);
   }
  
}

void DrawSquare(float x, float y)
{
  int r = (int)random(POS_RANDOMIZER_FACTOR);

  x += (int)random(r)-(r/2);
  y += (int)random(r)-(r/2);
  //rect(x-1,y-1, 3,3);
  point((int)x,(int)y);

}

void draw()
{
  
}
