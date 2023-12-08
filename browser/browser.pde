import processing.net.*;
import java.net.*;
import java.nio.ByteBuffer;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;

boolean cache = true;

String[] buffer;

PImage[] imgBuffer;

TextBox navBar = new TextBox(1, 0, 25, color(0), color(255));

boolean local = false;

boolean render = false;

int netData = 0;

int HEIGHT = 50;

int MARGINX = 2;

int MARGINY = 2;

String URI = "";

void setup() {
  size(640, 480);
  background(255);

  navBar.text = "";
  
  println("Browser started!");
}

void draw() {
  if (render) renderPage(buffer);

  navBar.render();
}
