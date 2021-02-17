void serverEvent(Server extServer, Client extClient) {
  println("A new client connected! Sending checksum...");
  try{
    server.write(createChecksum(pmlFile));
  } catch (Exception e){
    println(e);
    server.write(new byte[0]);
  }
}

void clientEvent(Client someClient) {
  int dataIn = someClient.read();
  switch(dataIn) {
  case 0: //PML transfer
    server.write(buffer.array());
    break;
  case 1: //Image transfer
    server.write(serializedImages);
    break;
  }
}
