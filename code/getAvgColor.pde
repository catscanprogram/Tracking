color getAvgColor(Capture webcam) {
  int rArea =rWidth * rWidth;
  bg_img.loadPixels();
  int r = 0, g = 0, b = 0;
  int i;

  for (int x = 50; x <= 150; x++) {
    for (int y = 50; y <= 150; y++) {
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