void Duotone(Capture webcam, color prev, color newColor) {

  // iterate through all pixels in the image
  webcam.loadPixels();
  
  
  
  for (int i=0; i<webcam.pixels.length; i++) {

    // get the brightness of the current pixel (the red value)
    float bright = webcam.pixels[i] >> 16 & 0xFF;

    // lerpColor wants values 0-1, so divide by 255
    bright /= 255.0;

    // create a new color for the pixel that's somewhere between
    // the two colors we specified
    color lc = lerpColor(prev, newColor, bright);

    // set the current pixel
    webcam.pixels[i] = lc;
  }
  //webcam.updatePixels();
  //image(webcam, 0, 0);

  //prev = curr;
}