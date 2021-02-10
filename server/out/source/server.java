import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.net.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class server extends PApplet {



Server server;

String[] buffer;

public void setup() {
    
    background(0);
    
    server = new Server(this, 5204);

    buffer = loadStrings("./index.pml");
}

public void serverEvent(Server extServer, Client extClient){
    server.write(buffer);
}
  public void settings() {  size (640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "server" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
