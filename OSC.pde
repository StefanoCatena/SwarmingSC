OscP5 osc;
NetAddress address;

class OSC {
  OSC() {
    osc = new OscP5(this, 12000);
    address = new NetAddress("192.168.43.80", 57120); //SC's server location, port to listen to
    //address = new NetAddress("127.0.0.1", 57120); //Local for testing
  }

  float bright;

  void send() {
    OscMessage msg = new OscMessage("/msg");
    msg.add(mouseX);
    msg.add(mouseY);
    osc.send(msg, address);
  }

  void size() {
    OscMessage msg = new OscMessage("/size");
    msg.add(height);
    msg.add(width);
    osc.send(msg, address);
  }

  void buffer() {
    OscMessage buffer = new OscMessage("/buf");
    osc.send(buffer, address);
  }
  
  void kill(){
  OscMessage kill = new OscMessage("/kill");
  osc.send(kill, address);
    
  }
  
  void gateon()
  {
    OscMessage gateon = new OscMessage ("/gateon");
    osc.send(gateon, address);
  }
  
  void gateoff()
  {
    OscMessage gateoff = new OscMessage("/gateoff");
    osc.send(gateoff, address);
  }
 
 void changeBuf(int v){
   int value = v;
   OscMessage changeBuf = new OscMessage("/changeBuf");
   changeBuf.add(value);
   osc.send(changeBuf, address);
 }

  void oscEvent(OscMessage message) {
    if (message.checkAddrPattern("/color")==true) {
      if (message.checkTypetag("f")) {
        bright = message.get(0).floatValue();
        println(bright);
      }
    }
  }

  float returnBrightness() {
    return bright;
  }
}