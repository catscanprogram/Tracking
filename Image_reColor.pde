import processing.video.*;

Capture webcam;
Capture cap;

boolean screenshot = false;

PImage snapshot;
PImage bg_img;

color avgBG = color(0, 0, 0);

color colorToMatch = color(random(255),random(255), random(255));   // start random
color prev = color(random(255),random(255), random(255));

int rMargin = 50;
int rWidth = 100;

color currAvg = color(0, 0, 0);
color background = color(255, 255, 255);
int tolerance = 20;

void setup() {
  size(1280,720);

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
    
    // read from the webcam
    webcam.read();

    //setColor(colorCam, prev, colorToMatch);
    image(webcam, 0,0);
    webcam.loadPixels();
  
    //Get initial screenshot to identify BG color
    if (screenshot == false && frameCount >= 160) {  
      saveFrame("background.jpg");
      screenshot = true;
    }
    
    //if you have the image, proceed with the code
    if ( screenshot == true && millis() >= 5000) {
      bg_img = loadImage("background.jpg");

    //get average color of the background based on inital screenshot
    avgBG = getBGColor(bg_img);
        //GET THE CURRENT AVG COLOR
    currAvg = getAvgColor(webcam);
    
    //initialize rectangle
    fill(currAvg);
    strokeWeight(2);
    stroke(255,255, 255);
    rect(rMargin, rMargin, rWidth, rWidth);
    int yCenter = (rWidth/2) + rMargin;
    int xCenter = (rWidth/2) + rMargin;
    // rectMode(CENTER);
    int rectCenterIndex = (width* yCenter) + xCenter;
    
    //now check if the current color is off from the bg:
    //get avg rgb for current color:
    float cr = currAvg >> 16 & 0xFF;
    //println(cr);
    float cg = currAvg >> 8 & 0xFF;
    float cb = currAvg & 0xFF;
    
    //get avg rgb for bg color:
    float br = avgBG >> 16 & 0xFF;
    //println(br);
    float bg = avgBG >> 8 & 0xFF;
    float bb = avgBG & 0xFF;
    
    //if the current color is outside the tolerance
    if ((cr <= br-tolerance || cr >= br+tolerance) && 
        (cg <= bg-tolerance || cg >= bg+tolerance) && 
        (cb <= bb-tolerance || cb >= bb+tolerance)){
      //we have a new color
      println("new color");
         //println(colorToMatch);
         //call the lerpinator!
         setColor(webcam, prev, colorToMatch);
         //webcam.updatePixels();
    } else {
    //do nothing, just the bg going on here!
    println("background");
    }
    
    //if (checkBackground(avgBG, rectCenterIndex) != -1){
    //  input = checkBackground(avgBG, rectCenterIndex);
    //  println("new color!");
    //} else {
    //  println("no change");
    //}
  
      //webcam.updatePixels();
    }
  }
}



//avg color found here:
//https://forum.processing.org/two/discussion/15573/get-the-average-rgb-from-pixels
color getBGColor(PImage bg_img){
  int rArea =rWidth * rWidth;
  bg_img.loadPixels();
  int r = 0, g = 0, b = 0;
    
    ///CALCULATE AVG COLOR:
    int i;
for(int x = 50; x <= 150; x++){
   for(int y = 50; y <= 150; y++){
           i = (width*y) + x;
           color c = bg_img.pixels[i];
           r += c>>16&0xFF;
           g += c>>8&0xFF;
           b += c&0xFF;
       }
    }
    r /= rArea;
    g /= rArea;
    b /= rArea;
    println(r + " " + g + " " + b);
    return color(r,g,b);
}

//CALCULATE AVG COLOR:
color getAvgColor(Capture webcam) {
  int rArea =rWidth * rWidth;
  bg_img.loadPixels();
  int r = 0, g = 0, b = 0;
  int i;
  
for(int x = 50; x <= 150; x++){
   for(int y = 50; y <= 150; y++){
           i = (width*y) + x;
           color c = webcam.pixels[i];
           r += c>>16&0xFF;
           g += c>>8&0xFF;
           b += c&0xFF;
       }
    }
    r /= rArea;
    g /= rArea;
    b /= rArea;
    
    println(r + " " + g + " " + b);
    return color(r, g, b);
}


//color checkBackground(color background, int pixelIndex){
//  color currColor = webcam.pixels[pixelIndex];
  
//  //color info for original
//  float matchR = background >> 16 & 0xFF;
//  float matchG = background >> 8 & 0xFF;
//  float matchB = background & 0xFF;
  
//  //color info for current
//  float r = currColor >> 16 & 0xFF;
//  float g = currColor >> 8 & 0xFF;
//  float b = currColor & 0xFF;
 
//  if (r >= matchR-tolerance && r <=matchR+tolerance &&
//          g >= matchG-tolerance && g <=matchG+tolerance &&
//          b >= matchB-tolerance && b <=matchB+tolerance) {
          
//            // if any match was detected, return the location
//            // immediately (to avoid iterating the rest of 
//            // the pixels unecessarily)
//            return currColor;
//      } else {
//  return -1;
//  }
//}


void setColor(Capture webcam, color prev, color colorToMatch) {
 // iterate through all pixels in the image
  webcam.loadPixels();
  
  prev = avgBG;
  colorToMatch = currAvg;
  for (int i=0; i<webcam.pixels.length; i++) {
    
    // get the brightness of the current pixel (the red value)
    float bright = webcam.pixels[i] >> 16 & 0xFF;
    
    // lerpColor wants values 0-1, so divide by 255
    bright /= 255.0;
    
    // create a new color for the pixel that's somewhere between
    // the two colors we specified
    color newColor = lerpColor(prev, colorToMatch, bright);
    
    // set the current pixel
    webcam.pixels[i] = newColor;
  }
      webcam.updatePixels();
      image(webcam, 0, 0);
  }