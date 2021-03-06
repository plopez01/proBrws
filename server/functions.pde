String[] getImgPaths(String[] lines, int maxImg) {
  String[] imgNames = new String[maxImg];
  int imgCount = 0;
  int repImg = -1;
  for (int i = 0; i < lines.length; i++) {
    String line = lines[i].split("<")[1];

    String code = line.split(" ")[0];
    String[] args = line.split(" ", 2)[1].split(">")[0].split(";");
    if (code.equals("img")) {
      for (int z = 0; z < imgCount; z++) {
        if (imgNames[z].equals(args[0])) {
          repImg = z;
          break;
        }
      }
      if (repImg == -1) {
        imgNames[imgCount] = args[0];
      } else {
        imgNames[imgCount] = imgNames[repImg];
        repImg = -1;
      }
      imgCount++;
    }
  }
  return imgNames;
}

int getImgNum(String[] lines) {
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

String[] resolveJSONArray(JSONArray array) {
  String[] result = new String[array.size()];
  for (int i = 0; i < array.size(); i++) {
    result[i] = array.getString(i);
  }
  return result;
}

boolean isBlacklisted(String ip){
  for(int i = 0; i < blacklist.length; i++){
    if(ip.equals(blacklist[i])) return true;
  }
  return false;
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

// https://www.rgagnon.com/javadetails/java-0416.html
byte[] createChecksum(String filename) throws Exception {
  InputStream fis =  createInput(filename);

  byte[] buffer = new byte[1024];
  MessageDigest complete = MessageDigest.getInstance("MD5");
  int numRead;

  do {
    numRead = fis.read(buffer);
    if (numRead > 0) {
      complete.update(buffer, 0, numRead);
    }
  } while (numRead != -1);

  fis.close();
  return complete.digest();
}
