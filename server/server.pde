import processing.net.*;
import java.nio.ByteBuffer;

Server server;

ByteBuffer buffer;

int imgCount = 0;

byte[][] imgBuffer;

void setup() {
  size (640, 480);
  background(0);
  
  server = new Server(this, 5204);  
  byte[] bytes = loadBytes("./index.pml");
  
  buffer = ByteBuffer.allocate(bytes.length + 4);
  buffer.putInt(bytes.length);
  buffer.put(buffer);
  
  File imgFolder = dataFile("./img");
  
  String[] names = imgFolder.list();
  imgCount = names.length;
  
  for(int i = 0; i < imgCount; i++){
    imgBuffer[i] = serialize(loadImage("./img/"+names[i]));
  }
}

void draw() {}

void serverEvent(Server extServer, Client extClient){
  println("A new client connected! Sending data length...");
  server.write(buffer.array());
}

void clientEvent(Client someClient) {
  int dataIn = someClient.read();
  switch(dataIn){
    case 0:
      server.write(imgCount);
      break;
  }
  if(dataIn > 1){
    server.write(imgBuffer[dataIn]);
  }
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
