import processing.video.*;

Capture webcam;
Capture cap;

boolean screenshotFlag = false;
boolean duotoneFlag = false;
boolean bgFlag = true;

PImage snapshot;
PImage bg_img;

color bg = color(0, 0, 0);

color newColor = color(0, 0, 0);   // start random
color prev = color(0, 0, 0);

int rMargin = 50;
int rWidth = 100;

color currAvg = color(0, 0, 0);
color background = color(255, 255, 255);
int tolerance = 20;

void setup() {
  size(1280, 720);

  // start the webcam
  String[] inputs = Capture.list();
  if (inputs.length == 0) {
    println("Couldn't detect any webcams connected!");
    exit();
  }
  webcam = new Capture(this, inputs[0]);
  //colorCam = new Capture(this, inputs[0]);
  //colorCam = createImage(webcam.width, webcam.height, RGB);

  webcam.start();
}


void draw() {
  if (webcam.available()) {
    webcam.read();
    image(webcam, 0, 0);
    webcam.loadPixels();

    //Get initial screenshot to identify bg color
    if (screenshotFlag == false && frameCount >= 160) {  
      saveFrame("background.jpg");
      bg_img = loadImage("background.jpg");
      //get average color of the background based on inital screenshot
      bg = getBGColor(bg_img);
      screenshotFlag = true;
    }

    //if you have the image, proceed with the code
    if (screenshotFlag == true) {

      //get the current average color of the webcam
      currAvg = getAvgColor(webcam);

      if (bgFlag) {
        if (sameColor(currAvg, bg)) {
          println("new color!");
          prev = newColor;
          newColor = currAvg;
          duotoneFlag = true;
          bgFlag = false;
        } else {
          //do nothing
          println("bg");
        }
      }

      if (sameColor(currAvg, bg) && sameColor(currAvg, newColor)) {
        println("new color!");
        prev = newColor;
        newColor = currAvg;
      }

      if (duotoneFlag) {
        Duotone(webcam, prev, newColor);
        webcam.updatePixels();
        image(webcam, 0, 0);
      }
      
      //set up rectangle
      fill(currAvg);
      strokeWeight(2);
      stroke(255, 255, 255);
      rect(rMargin, rMargin, rWidth, rWidth);
      // rectMode(CENTER);
      
    }
  }
} //end of draw

boolean sameColor(color c1, color c2) {

  //color info for c1
  float r1 = c1 >> 16 & 0xFF;
  float g1 = c1 >> 8 & 0xFF;
  float b1 = c1 & 0xFF;

  //color info c2
  float r2 = c2 >> 16 & 0xFF;
  float g2 = c2 >> 8 & 0xFF;
  float b2 = c2 & 0xFF;

  //compare them
  if ((r1 <= r2-tolerance || r1 >= r2+tolerance) && 
    (g1 <= g2-tolerance || g1 >= g2+tolerance) && 
    (b1 <= b2-tolerance || b1 >= b2+tolerance)) {
    return true;
  } else {
    return false;
  }
}