import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.net.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class browser extends PApplet {



Client client;

String[] buffer;

TextBox navBar = new TextBox(1, 0, 25, color(0), color(255));

boolean render = false;

int HEIGHT = 50;

int MARGINX = 2;

int MARGINY = 2;

public void setup(){
  
  background(255);

  navBar.text = "";
}

public void draw(){
  if(render) renderPage(buffer);

  navBar.render();
}


public void search(String text){
  String[] localSearch = text.split("file://");
  if(localSearch.length == 2){
    buffer = loadStrings(localSearch[1]);
  }else{
    println("notlocal");
    client = new Client(this, text, 5204);
  }
  render = true;
}

public void renderPage(String[] lines){
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

public void mouseClicked() {
  if(mouseY < navBar.size){
    navBar.focus = true;
  }else{
    navBar.focus = false;
  }
}

public void keyPressed(){
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
class TextBox{
  int x, y, size;
  String text = "";
  boolean focus = false;
  boolean release = true;
  int foreColor, backColor;
  TextBox(int x, int y, int size, int foreColor, int backColor){
    this.x = x;
    this.y = y;
    this.size = size;
    this.foreColor = foreColor;
    this.backColor = backColor;
  }
  
  public void render(){
    if(focus){
      fill(200);
    }else{
      fill(backColor);
    }
    rect(x, y, width-3, size);
    
    fill(foreColor);
    textSize(size/1.4f);
    text(text, x+5, y+size/1.3f);
  }
}
  public void settings() {  size(640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "browser" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
