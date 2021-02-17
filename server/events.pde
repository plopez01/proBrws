void serverEvent(Server extServer, Client extClient) {
  println("A new client connected! Sending data...");
  server.write(buffer.array());
}


void clientEvent(Client someClient) {
  int dataIn = someClient.read();
  switch(dataIn) {
  case 0:
    server.write(serializedImages);
    break;
  }
}
