void blockUntilDone(Client client) {
  netData = client.available();
  delay(100);
  if (netData != client.available()) {
    blockUntilDone(client);
  }
}

void search(String host) {
  String[] localSearch = host.split("file://");
  if (localSearch.length == 2) {
    //Load fom local
    buffer = loadStrings(localSearch[1]);
    local = true;
    println("Loading from local pml!");
  } else {
    // Load from cache
    local = false;
    byte[] cacheChecksum = loadBytes("./cache/"+host+"/sum.md5");

    Client client = new Client(this, host, 5204);

    blockUntilDone(client); // Block thread until we got all the data
    byte[] checkSum = client.readBytes();

    if (checkSum[0] == -1) {
      println("Connection couldn't be made!");
      return;
    }

    if (cacheChecksum != null && cache) {
      boolean invalidCache = false;

      // Validate cache using checksum
      for (int i = 0; i < checkSum.length; i++) {
        if (checkSum[i] != cacheChecksum[i]) {
          invalidCache = true;
        }
      }
      if (!invalidCache) {
        println("Loading from cache!");
        String[] cacheRead = loadStrings("./cache/"+host+"/index.pml");
        if (cacheRead != null) {
          buffer = cacheRead;

          File imgFolder = dataFile(sketchPath("./cache/"+host+"/img"));
          int imgCount = imgFolder.list().length;

          imgBuffer = new PImage[imgCount];

          for (int i = 0; i < imgCount; i++) {
            imgBuffer[i] = loadImage("./cache/"+host+"/img/"+i+".tif");
          }
          println("Cache loaded.");
        } else {
          // Download page from because there is no cache
          println("There is no cache, downloading from server...");
          downloadPage(host, client, checkSum);
        }
      } else {
        // Download page from server because the checksum is no the same anymore
        println("The cache is invalid, downloading from server...");
        downloadPage(host, client, checkSum);
      }
    } else {
      // Download page from server becouse there is no checksum in the cache or it has been disabled
      println("There is no checksum or cache has been disabled, downloading from server...");
      downloadPage(host, client, checkSum);
    }
  }
  render = true;
}

void renderPage(String[] lines) {
  int imgCounter = 0;
  try {
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].split("<")[1];

      String code = line.split(" ")[0];
      String[] args = line.split(" ", 2)[1].split(">")[0].split(";");
      if (code.equals("background")) {
        background(parseInt(args[0]), parseInt(args[1]), parseInt(args[2]));
      }
      if (code.equals("text")) {
        if (args.length == 1) {
          text(args[0], MARGINX, MARGINY+HEIGHT);
        } else {
          text(args[0], MARGINX+parseInt(args[1]), MARGINY+parseInt(args[2])+HEIGHT);
        }
      }
      if (code.equals("img")) {
        if (local) {
          PImage lImage = loadImage(args[0]);
          if (args.length == 2) {
            image(lImage, MARGINX, MARGINY+HEIGHT, lImage.width*parseFloat(args[1]), lImage.height*parseFloat(args[1]));
          } else {
            image(lImage, MARGINX+parseInt(args[1]), MARGINY+parseInt(args[2])+HEIGHT, lImage.width*parseFloat(args[3]), lImage.height*parseFloat(args[3]));
          }
        } else {
          if (args.length == 2) {
            image(imgBuffer[imgCounter], MARGINX, MARGINY+HEIGHT, imgBuffer[imgCounter].width*parseFloat(args[1]), imgBuffer[imgCounter].height*parseFloat(args[1]));
          } else {
            // Wow, this is long... should probably make shorter somehow.
            image(imgBuffer[imgCounter], MARGINX+parseInt(args[1]), MARGINY+parseInt(args[2])+HEIGHT, imgBuffer[imgCounter].width*parseFloat(args[3]), imgBuffer[imgCounter].height*parseFloat(args[3]));
          }
        }
        imgCounter++;
        HEIGHT += 140;
      }
      if (code.equals("nl")) {
        HEIGHT += 20;
      }
      if (code.equals("margin")) {
        MARGINX = parseInt(args[0]);
        MARGINY = parseInt(args[1]);
      }
    }
  }
  catch(Exception e) {
    println("An error has ocurred, check your PML code: " + e);
  }
  HEIGHT = 50;
  MARGINX = 2;
  MARGINY = 2;
}

void downloadPage(String host, Client client, byte[] checksum) {
  saveBytes("./cache/"+host+"/sum.md5", checksum); // Save cache checksum

  //Get page markup file
  client.write(0);
  blockUntilDone(client);
  ByteBuffer bb = ByteBuffer.wrap(client.readBytes());
  int len = bb.getInt();
  byte[] bBuffer = new byte[len];
  bb.get(bBuffer);
  String decodedData = "";
  for (int i = 0; i < len; i++) {
    decodedData += char(bBuffer[i]);
  }
  buffer = decodedData.split("\n");

  //Get images
  client.write(1);
  blockUntilDone(client);
  imgBuffer = deserializeImages(client);


  //Save page to the cache
  PrintWriter cacheStream = createWriter("./cache/"+host+"/index.pml");
  cacheStream.print(decodedData);
  cacheStream.flush();
  cacheStream.close();

  //Save images to the cache
  for (int i = 0; i < imgBuffer.length; i++) {
    imgBuffer[i].save(savePath("./cache/"+host+"/img/"+i));
  }

  //Stop connection
  client.stop();
}


PImage[] deserializeImages(Client client) {
  blockUntilDone(client);
  ByteBuffer bb = ByteBuffer.wrap(client.readBytes());

  bb.rewind();
  int imgNum = bb.getInt();
  PImage[] imgs = new PImage[imgNum];
  for (int x = 0; x < imgNum; x++) {
    int w = bb.getInt();
    int h = bb.getInt();
    PImage img = new PImage(w, h);
    int[] px = img.pixels;
    for (int i = 0; i < px.length; i++) {
      try { 
        px[i] = bb.getInt();
      } 
      catch (java.nio.BufferUnderflowException e) {
      }
    }
    img.updatePixels();
    imgs[x] = img;
  }
  return imgs;
}

// https://forum.processing.org/two/discussion/27473/paste-and-copy-text
String GetTextFromClipboard () {
  String text = (String) GetFromClipboard(DataFlavor.stringFlavor);
  if (text==null) 
    return "";
  return text;
}

Object GetFromClipboard (DataFlavor flavor) {

  Clipboard clipboard = getJFrame(getSurface()).getToolkit().getSystemClipboard();

  Transferable contents = clipboard.getContents(null);
  Object object = null; // the potential result 

  if (contents != null && contents.isDataFlavorSupported(flavor)) {
    try
    {
      object = contents.getTransferData(flavor);
    }
    catch (UnsupportedFlavorException e1) // Unlikely but we must catch it
    {
      println("Clipboard.GetFromClipboard() >> Unsupported flavor: " + e1);
      e1.printStackTrace();
    }
    catch (java.io.IOException e2)
    {
      println("Clipboard.GetFromClipboard() >> Unavailable data: " + e2);
      e2.printStackTrace() ;
    }
  }
  return object;
} 

static final javax.swing.JFrame getJFrame(final PSurface surf) {
  return
    (javax.swing.JFrame)
    ((processing.awt.PSurfaceAWT.SmoothCanvas)
    surf.getNative()).getFrame();
}
