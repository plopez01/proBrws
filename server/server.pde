import processing.net.*;
import java.nio.ByteBuffer;
import java.security.MessageDigest;

Server server;

ByteBuffer buffer;

PImage[] images;

byte[] serializedImages;

String pmlFile = "./index.pml";

void setup() {
  size (640, 480);
  background(0);

  server = new Server(this, 5204);  
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
  
  println("Server started...");
}

void draw() {}
