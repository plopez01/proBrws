import processing.net.*;
import java.nio.ByteBuffer;

Server server;

ByteBuffer buffer;

int imgCount = 0;

PImage[] images;

void setup() {
  size (640, 480);
  background(0);
  
  server = new Server(this, 5204);  
  byte[] bytes = loadBytes("./index.pml");
  
  buffer = ByteBuffer.allocate(bytes.length + 4);
  buffer.putInt(bytes.length);
  buffer.put(bytes);
  
  File imgFolder = dataFile(sketchPath("/img"));
  String[] imgNames = imgFolder.list();
  imgCount = imgNames.length;
  
  images = new PImage[imgCount];
  
  
  for(int i = 0; i < imgCount; i++){
    images[i] = loadImage("./img/"+imgNames[i]);
  }
}

void draw() {}

void serverEvent(Server extServer, Client extClient){
  println("A new client connected! Sending data length...");
  server.write(buffer.array());
}

byte[] serialize(PImage img) {
  img.loadPixels();
  int[] px = img.pixels;
  ByteBuffer bb = ByteBuffer.allocate((2 + px.length) * 4);
  bb.putInt(img.width);
  bb.putInt(img.height);
  for (int d : px) {
    bb.putInt(d);
  }
  return bb.array();
}
