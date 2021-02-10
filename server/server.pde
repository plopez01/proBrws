import processing.net.*;

Server server;

String[] buffer;

void setup() {
    size (640, 480);
    background(0);
    
    server = new Server(this, 5204);

    buffer = loadStrings("./index.pml");
}

void serverEvent(Server extServer, Client extClient){
    server.write(buffer);
}