class ServerCLI {
  String data = "";
  int textSize, xoffset, yoffset;
  boolean exitOnPress = false;
  TextBox inputBox;

  ServerCLI(int textSize, int xoffset, int yoffset) {
    this.textSize = textSize;
    this.xoffset = xoffset;
    this.yoffset = yoffset;
  }

  void begin() {
    inputBox = new TextBox(-2, height-yoffset, 20, color(255), color(0));
  }

  void render() {
    textSize(textSize);
    String[] lines = data.split("\n");
    String nwBuffer = "";
    for (int i = 0; i < lines.length; i++) {
      setColor(lines[i].split("]")[0]);
      lines[i] = nwBuffer + lines[i]; 
      text(lines[i], xoffset, yoffset);
      nwBuffer += "\n";
    }
    inputBox.render();
  }

  void init(String text) {
    data += "[START] " + text + "\n";
  }

  void info(String text) {
    data += "[INFO] " + text + "\n";
  }

  void warn(String text) {
    data += "[WARNING] " + text + "\n";
  }

  void error(String text) {
    data += "[ERROR] " + text + "\n";
  }

  void cmd() {
    data += "[>] " + inputBox.text + "\n";
    handleCMD(inputBox.text);
    inputBox.text = "";
  }

  void waitForExit() {
    data += "\n[INPUT] Press any key to exit...\n";
    exitOnPress = true;
  }

  private void handleCMD(String text) {
    String[] cmd = text.split(" ");
    switch(cmd[0].toLowerCase()){
      case "help":
        info("The available commands are: help, version, port, blacklist, stop.");
        break;
      case "version":
        info(_VERSION);
        break;
      case "port":
        info(str(_PORT));
        break;
      case "blacklist":
        String result = "The blacklisted IP's are: \n";
        if(blacklist.length > 0){
          for(int i = 0; i < blacklist.length; i++){
           result += blacklist[i];
           if(i % 6 == 0 && i != 0){
              result += "\n"; 
           }else{
             result += " ";
           }
          }
        }else{
          result = "There are no blacklisted IP's.";
        }
        info(result);
        break;
      case "stop":
        exit();
        break;
      default:
        error("Command not found, use \"help\" to see a list of available commands.");
      break;
    }
  }

  private void setColor(String id) {
    switch(id) {
    case "[INFO":
      fill(255);
      break;
    case "[WARNING":
      fill(255, 204, 0);
      break;
    case "[ERROR":
      fill(255, 0, 51);
      break;
    case "[START":
      fill(0, 255, 102);
      break;
    case "[INPUT":
      fill(192, 192, 192);
      break;
    case "[>":
      fill(200);
      break;
    }
  }
}

class TextBox {
  int x, y, size;
  String text = "";
  color foreColor, backColor;
  TextBox(int x, int y, int size, color foreColor, color backColor) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.foreColor = foreColor;
    this.backColor = backColor;
  }

  void render() {
    fill(backColor);
    stroke(200);
    rect(x, y, width+2, size);

    fill(foreColor);
    textSize(size/1.4);
    text(">$ " + text, x+5, y+size/1.3);
  }
}
