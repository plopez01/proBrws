import processing.net.*;
import java.nio.ByteBuffer;

boolean cache = false;

String[] buffer;

PImage[] imgBuffer;

TextBox navBar = new TextBox(1, 0, 25, color(0), color(255));

boolean local = false;

boolean render = false;

int netData = 0;

int HEIGHT = 50;

int MARGINX = 2;

int MARGINY = 2;

void setup() {
  size(640, 480);
  background(255);

  navBar.text = "file://page.pml";
}

void draw() {
  if (render) renderPage(buffer);

  navBar.render();
}
