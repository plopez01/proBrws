class ServerCLI {
  String data = "";
  int textSize, xoffset, yoffset;
  ServerCLI(int textSize, int xoffset, int yoffset){
    this.textSize = textSize;
    this.xoffset = xoffset;
    this.yoffset = yoffset;
  }
 
  void render(){
    textSize(textSize);
    String[] lines = data.split("\n");
    String nwBuffer = "";
    for(int i = 0; i < lines.length; i++){
      setColor(lines[i].split("]")[0]);
      lines[i] = nwBuffer + lines[i]; 
      text(lines[i], xoffset, yoffset);
      nwBuffer += "\n";
    }
  }
  
  void init(String text){
    data += "[START] " + text + "\n";
  }
  
  void info(String text){
    data += "[INFO] " + text + "\n";
  }
  
  void warn(String text){
    data += "[WARNING] " + text + "\n";
  }
  
  void error(String text){
    data += "[ERROR] " + text + "\n";
  }
  
  private void setColor(String id){
    switch(id){
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
    }
  }
}
