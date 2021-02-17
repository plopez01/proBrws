void serverEvent(Server extServer, Client extClient) {
  serverCLI.info("[" + extClient.ip() + "] A new client has connected, sending checksum...");
  try{
    server.write(createChecksum(pmlFile));
  } catch (Exception e){
    serverCLI.error(e.getMessage());
    server.write(new byte[0]);
  }
}

void clientEvent(Client someClient) {
  int dataIn = someClient.read();
  switch(dataIn) {
  case 0: //PML transfer
    server.write(buffer.array());
    serverCLI.info("[" + someClient.ip() + "] Client requested PML, sending...");
    break;
  case 1: //Image transfer
    server.write(serializedImages);
    serverCLI.info("[" + someClient.ip() + "] Client requested Images, sending...");
    break;
  }
}
