String[] getImgPaths(String[] lines, int maxImg) {
  String[] imgNames = new String[maxImg];
  int imgCount = 0;
  int repImg = -1;
  for (int i = 0; i < lines.length; i++) {
    String line = lines[i].split("<")[1];

    String code = line.split(" ")[0];
    String[] args = line.split(" ", 2)[1].split(">")[0].split(";");
    if (code.equals("img")) {
      for(int z = 0; z < imgCount; z++){
       if(imgNames[z].equals(args[0])){
         repImg = z;
         break;
       }
      }
      if(repImg == -1){
        imgNames[imgCount] = args[0];
      }else{
        imgNames[imgCount] = imgNames[repImg];
        repImg = -1;
      }
      imgCount++;
    }
  }
  return imgNames;
}

int getImgNum(String[] lines){
  int imgCount = 0;
  for (int i = 0; i < lines.length; i++) {
    if (lines[i].contains("img")) {
      imgCount++;
    }
  }
  return imgCount;
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
