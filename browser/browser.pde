import processing.net.*;

String[] buffer;

TextBox navBar = new TextBox(1, 0, 25, color(0), color(255));

boolean render = false;

int HEIGHT = 50;

int MARGINX = 2;

int MARGINY = 2;

void setup(){
  size(640, 480);
  background(255);

  navBar.text = "localhost";
}

void draw(){
  if(render) renderPage(buffer);

  navBar.render();
}


void search(String text){
  String[] localSearch = text.split("file://");
  if(localSearch.length == 2){
    buffer = loadStrings(localSearch[1]);
  }else{
    Client client = new Client(this, text, 5204);
    if(client.available() > 0){
      //Get content len
      int len = client.read();
      byte[] bBuffer = new byte[len];
      //TODO: Implement rsc data
      //Got len, ask for data
      client.write(0);
      while(client.available() != len); // Block thread until we got all the data
      client.readBytes(bBuffer);
      String decodedData = "";
      for(int i = 0; i < len; i++){
        decodedData += char(bBuffer[i]);
      }
      println(decodedData);
      buffer = decodedData.split("\n");
    }
    client.stop();
    while(client.active()); // Block thread until the client has shutdown
  }
  render = true;
}

void renderPage(String[] lines){
  for(int i = 0; i < lines.length; i++){
    String line = lines[i].split("<")[1];
    
    String code = line.split(" ")[0];
    String[] args = line.split(" ", 2)[1].split(">")[0].split(";");
    if(code.equals("background")){
      background(parseInt(args[0]), parseInt(args[1]), parseInt(args[2]));
    }
    if(code.equals("text")){
      if(args.length == 1){
        text(args[0], MARGINX, MARGINY+HEIGHT);
      }else{
        text(args[0], MARGINX+parseInt(args[1]), MARGINY+parseInt(args[2])+HEIGHT);
      }
      
    }
    if(code.equals("img")){
      if(args.length == 1){
        image(loadImage(args[0]), MARGINX, MARGINY+HEIGHT, 100, 140);
      }else{
        image(loadImage(args[0]), MARGINX+parseInt(args[1]), MARGINY+parseInt(args[2])+HEIGHT, 100, 140);
      }
      HEIGHT += 140;
    }
    if(code.equals("nl")){
     HEIGHT += 20; 
    }
    if(code.equals("margin")){
     MARGINX = parseInt(args[0]);
     MARGINY = parseInt(args[1]);
    }
  }
  HEIGHT = 50;
  MARGINX = 2;
  MARGINY = 2;
}

void mouseClicked() {
  if(mouseY < navBar.size){
    navBar.focus = true;
  }else{
    navBar.focus = false;
  }
}

void keyPressed(){
  if(navBar.focus){
     switch(keyCode){
       case 8:
        if(navBar.text.length() != 0){
          navBar.text = navBar.text.substring(0, navBar.text.length()-1);
        }
       break;
       
       case 10:
         navBar.focus = false;
         search(navBar.text);
       break;
       
       default:
         if (keyCode > 31) navBar.text += key;
       break;
    }
  }
}
