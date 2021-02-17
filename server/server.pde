import processing.net.*;
import java.nio.ByteBuffer;
import java.security.MessageDigest;

Server server;

ServerCLI serverCLI = new ServerCLI(14, 4, 20);

ByteBuffer buffer;

PImage[] images;

byte[] serializedImages;

String pmlFile = "./index.pml";

int _PORT = 5204;

void setup() {
  size (640, 480);
  background(0);
  noSmooth();

  server = new Server(this, _PORT);  
  byte[] bytes = loadBytes(pmlFile);

  buffer = ByteBuffer.allocate(bytes.length + 4);
  buffer.putInt(bytes.length);
  buffer.put(bytes);

  String[] pmlData = loadStrings(pmlFile);;

  int imgCount = getImgNum(pmlData);

  String[] imgPaths = getImgPaths(pmlData, imgCount);
  
  images = new PImage[imgCount];

  for (int i = 0; i < imgCount; i++) {
    images[i] = loadImage(imgPaths[i]);
  }
  
  serializedImages = serializeImages(images);
  
  serverCLI.info("Server started, listening on port " + _PORT + "...");
}

void draw() {
  serverCLI.render();
}
