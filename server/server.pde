import processing.net.*;

Server server;

byte[] buffer;

void setup() {
  size (640, 480);
  background(0);
  
  server = new Server(this, 5204);
  
  buffer = loadBytes("./index.pml");
}

void draw() {
  
}

void serverEvent(Server extServer, Client extClient){
  println("A new client connected! Sending data length...");
  server.write(buffer.length);
}

void clientEvent(Client someClient) {
  int dataIn = someClient.read();
  switch(dataIn){
    case 0:
      server.write(buffer);
      break;
  }
}
