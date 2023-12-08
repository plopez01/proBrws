import processing.net.*;
import java.nio.ByteBuffer;
import java.security.MessageDigest;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;

Server server;

ServerCLI serverCLI = new ServerCLI(14, 4, 20);

ByteBuffer buffer;

PImage[] images;

byte[] serializedImages;

String pmlFile = "./index.pml";
byte[] checkSum;

int _PORT = 5204;

String _VERSION = "0.1.0";

String[] blacklist;

void setup() {
  size (640, 480);
  background(0);
  noSmooth();
  serverCLI.begin();
  
  serverCLI.init("proBrws Web Server  v"+_VERSION);

  // Load config
  JSONObject config;

  try{
    config = loadJSONObject("config.json");
    _PORT = config.getInt("port");
    pmlFile = config.getString("main");
    blacklist = resolveJSONArray(config.getJSONArray("blacklist"));
    
    serverCLI.info("Loaded from config!");
  } catch (RuntimeException e){
    serverCLI.warn("config.json is not a valid json, using default config.");
  }

  if (_PORT > 1023 && _PORT < 65535) {
    server = new Server(this, _PORT);  
    byte[] bytes = loadBytes(pmlFile);

    if (bytes != null) {
      buffer = ByteBuffer.allocate(bytes.length + 4);
      buffer.putInt(bytes.length);
      buffer.put(bytes);

      String[] pmlData = loadStrings(pmlFile);

      int imgCount = getImgNum(pmlData);

      String[] imgPaths = getImgPaths(pmlData, imgCount);

      images = new PImage[imgCount];
      
      for (int i = 0; i < imgCount; i++) {
        images[i] = loadImage(imgPaths[i]);
      }
      
      serializedImages = serializeImages(images);
      try {
        checkSum = createChecksum(pmlFile);
      } 
      catch (Exception e) {
        serverCLI.error(e.getMessage());
        serverCLI.waitForExit();
      }
      
      serverCLI.info("Server started, listening on port " + _PORT + "...");
    } else {
      serverCLI.error("The file \"" + pmlFile + "\" is missing or inaccessible. Make sure you specified it correctly\nin the config.json.");
      serverCLI.waitForExit();
    }
  } else {
    serverCLI.error("The set port " + _PORT + " is invalid. The valid port range is 1024-65535.");
    serverCLI.waitForExit();
  }
}

void draw() {
  if(serverCLI.exitOnPress && keyPressed) exit();
  
  serverCLI.render();
}
