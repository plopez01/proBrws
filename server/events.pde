void serverEvent(Server extServer, Client extClient) {
  if(isBlacklisted(extClient.ip())){
    serverCLI.warn("[" + extClient.ip() + "] IP is blacklisted, preventing connection.");
    server.write(new byte[] {-1});
    return;
  }
  
  serverCLI.info("[" + extClient.ip() + "] A new client has connected, sending checksum...");
  
  try{
    server.write(createChecksum(pmlFile));
  } catch (Exception e){
    serverCLI.error(e.getMessage());
    server.write(new byte[0]);
  }
}

void clientEvent(Client someClient) {
  if(isBlacklisted(someClient.ip())){
    serverCLI.warn("[" + someClient.ip() + "] IP is blacklisted, preventing connection.");
    server.write(new byte[] {-1});
    return;
  }
  
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

void keyPressed() {
  switch(keyCode) {
  case 8:
    if (serverCLI.inputBox.text.length() != 0) {
      serverCLI.inputBox.text = serverCLI.inputBox.text.substring(0, serverCLI.inputBox.text.length()-1);
    }
    break;

  case 10:
    serverCLI.cmd();
    break;

  default:
    if (keyCode > 31) serverCLI.inputBox.text += key;
    break;
  }
}
