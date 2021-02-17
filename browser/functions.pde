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
  } else {
    // Load from cache
    String[] cacheRead = loadStrings("./cache/"+host+"/index.pml");
    if (cacheRead != null && cache) {
      buffer = cacheRead;
      
      File imgFolder = dataFile(sketchPath("./cache/"+host+"/img"));
      int imgCount = imgFolder.list().length;
      
      imgBuffer = new PImage[imgCount];
      
      for (int i = 0; i < imgCount; i++) {
        imgBuffer[i] = loadImage("./cache/"+host+"/img/"+i+".tif");
      }
    } else {
      // Download page from server
      downloadPage(host);
    }
  }
  render = true;
}

void renderPage(String[] lines) {
  int imgCounter = 0;

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
        if (args.length == 1) {
          image(loadImage(args[0]), MARGINX, MARGINY+HEIGHT, 100, 140);
        } else {
          image(loadImage(args[0]), MARGINX+parseInt(args[1]), MARGINY+parseInt(args[2])+HEIGHT, 100, 140);
        }
      } else {
        if (args.length == 1) {
          image(imgBuffer[imgCounter], MARGINX, MARGINY+HEIGHT, 100, 140);
        } else {
          image(imgBuffer[imgCounter], MARGINX+parseInt(args[1]), MARGINY+parseInt(args[2])+HEIGHT, 100, 140);
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
  HEIGHT = 50;
  MARGINX = 2;
  MARGINY = 2;
}

void downloadPage(String host) {
  Client client = new Client(this, host, 5204);
  blockUntilDone(client); // Block thread until we got all the data

  //Get page markup file
  ByteBuffer bb = ByteBuffer.wrap(client.readBytes());
  int len = bb.getInt();
  byte[] bBuffer = new byte[len];
  //TODO: Implement rsc data
  bb.get(bBuffer);
  String decodedData = "";
  for (int i = 0; i < len; i++) {
    decodedData += char(bBuffer[i]);
  }
  buffer = decodedData.split("\n");

  //Get images
  client.write(0);
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
    println(x);
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
    println(img.pixels.length);
    imgs[x] = img;
  }
  return imgs;
}
