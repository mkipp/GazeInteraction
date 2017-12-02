/**
 * Start GazeTrackEyeXGazeStream.exe first 
 * => You should see a shell with gaze data
 *
 * Now you can start this sketch to collect and visualize the data.
 *
 * (c) 2017 Michael Kipp
 *
 * http://interaction.hs-augsburg.de
 */

import hypermedia.net.*;

UDP udp;
boolean isPresent = false;
float x = 0;
float y = 0;
float smooth = .5;

void setup() {
  //size(1900,1200);
  fullScreen();
  udp = new UDP(this, 11000);
  udp.listen(true);
  textAlign(CENTER);
}

void draw() {
  background(0);
  fill(200);
  textSize(40);
  text("Listening to Eyetracker", width/2, 60);
  textSize(25);
  text("Press ESC to exit", width/2, height-60);
  text("smooth = " + nf(smooth, 1,1) + " (UP/DOWN)", width-200, 60);
  
  fill(255);
  ellipse(x, y, 30,30);
  fill(0);
  ellipse(x, y, 5, 5);
  
  println(x, y);
}

void receive(byte[] data) {
  String message = new String(subset(data, 0, data.length-2));
  println(message);

  int pos = message.indexOf(";");
  if (pos > -1) {
    String[] xs = message.substring(0, pos).split(",");
    String[] ys = message.substring(pos+1).split(",");
    x = smooth * x + (1-smooth) * Float.parseFloat(xs[0]);
    y = smooth * y + (1-smooth) * Float.parseFloat(ys[0]);
  }
  if (message.startsWith("Pres")) {
    isPresent = true;
  }
  if (message.startsWith("NotPres")) {
    isPresent = false;
  }
}

void keyPressed() {
  if (keyCode == UP) {
    smooth += .1;
  }
  if (keyCode == DOWN) {
    smooth -= .1;
  }
  smooth = constrain(smooth, 0, .9);
}