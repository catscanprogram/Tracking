//avg color found here:
//https://forum.processing.org/two/discussion/15573/get-the-average-rgb-from-pixels
color getBGColor(PImage bg_img) {
  int rArea =rWidth * rWidth;
  bg_img.loadPixels();
  int r = 0, g = 0, b = 0;

  //get avg color
  int i;
  for (int x = 50; x <= 150; x++) {
    for (int y = 50; y <= 150; y++) {
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
  return color(r, g, b);
}