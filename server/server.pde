import processing.net.*;
import java.nio.ByteBuffer;

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

  File imgFolder = dataFile(sketchPath("/img"));
  int imgCount = imgFolder.list().length;

  String[] imgNames = getImageNames(imgCount);
  
  images = new PImage[imgCount];

  for (int i = 0; i < imgCount; i++) {
    images[i] = loadImage(imgNames[i]);
  }
  
  serializedImages = serializeImages(images);
}

String[] getImageNames(int maxImg) {
  String[] lines = loadStrings(pmlFile);
  String[] imgNames = new String[maxImg];
  int imgCount = 0;
  for (int i = 0; i < lines.length; i++) {
    String line = lines[i].split("<")[1];

    String code = line.split(" ")[0];
    String[] args = line.split(" ", 2)[1].split(">")[0].split(";");
    if (code.equals("img")) {
      imgNames[imgCount++] = args[0];
    }
  }
  return imgNames;
}

void draw() {}


void serverEvent(Server extServer, Client extClient) {
  println("A new client connected! Sending data length...");
  server.write(buffer.array());
}


void clientEvent(Client someClient) {
  int dataIn = someClient.read();
  switch(dataIn) {
  case 0:
    server.write(serializedImages);
    break;
  }
}


byte[] serializeImages(PImage[] img) {
  int space = 0;

  // Compute space allocation
  for (int i = 0; i < img.length; i++) {
    space += ((2 + img[i].pixels.length) * 4) * img.length;
  }
  space += 4; // Add one int
  ByteBuffer bb = ByteBuffer.allocate(space);
  bb.putInt(img.length);
  for (int i = 0; i < img.length; i++) {
    img[i].loadPixels();
    int[] px = img[i].pixels;
    bb.putInt(img[i].width);
    bb.putInt(img[i].height);
    for (int d : px) {
      bb.putInt(d);
    }
  }
  return bb.array();
}
