boolean matchColor(color c1, color c2) {

  float[] xyz1 = RGBtoXYZ(c1);
  float[] xyz2 = RGBtoXYZ(c2);

  float[] lab1 = toLab(xyz1[0], xyz1[1], xyz1[2]);
  float[] lab2 = toLab(xyz2[0], xyz2[1], xyz2[2]);

  float Diff = DeltaE94(lab1, lab2);

  return true;
}

float[] RGBtoXYZ(color c) {
  //sR, sG and sB (Standard RGB) input range = 0 ÷ 255
  //X, Y and Z output refer to a D65/2° standard illuminant.

  float sR = c >> 16 & 0xFF;
  float sG = c >> 8 & 0xFF;
  float sB = c & 0xFF;

  float var_R = ( sR / 255 );
  float var_G = ( sG / 255 );
  float var_B = ( sB / 255 );

  if ( var_R > 0.04045 ) {
    var_R = pow((( var_R + 0.055 ) / 1.055 ), 2.4);
  } else {
    var_R = var_R / 12.92;
  }
  if ( var_G > 0.04045 ) {
    var_G = pow((( var_G + 0.055 ) / 1.055 ), 2.4);
  } else {
    var_G = var_G / 12.92;
  }
  if ( var_B > 0.04045 ) {
    var_B = pow((( var_B + 0.055 ) / 1.055 ), 2.4);
  } else {
    var_B = var_B / 12.92;
  }

  var_R = var_R * 100;
  var_G = var_G * 100;
  var_B = var_B * 100;

  float X = var_R * 0.4124 + var_G * 0.3576 + var_B * 0.1805;
  float Y = var_R * 0.2126 + var_G * 0.7152 + var_B * 0.0722;
  float Z = var_R * 0.0193 + var_G * 0.1192 + var_B * 0.9505;

  float[] lab = {X, Y, Z};

  return lab;
}

float[] toLab (float X, float Y, float Z) {

  //Reference-X, Y and Z refer to specific illuminants and observers.
  //Common reference values are available below in this same page.
  //Observer= 2°, Illuminant= D65

  float ref_X =  95.047;
  float ref_Y = 100.000;
  float ref_Z = 108.883;

  float var_X = X / ref_X;
  float var_Y = Y / ref_Y;
  float var_Z = Z / ref_Z;

  if ( var_X > 0.008856 ) {
    var_X = pow(var_X, ( 1/3 ));
  } else {                    
    var_X = ( 7.787 * var_X ) + ( 16 / 116 );
  }
  if ( var_Y > 0.008856 ) {
    var_Y = pow(var_Y, ( 1/3 ));
  } else {
    var_Y = ( 7.787 * var_Y ) + ( 16 / 116 );
  }
  if ( var_Z > 0.008856 ) {
    var_Z = pow(var_Z, ( 1/3 ));
  } else {
    var_Z = ( 7.787 * var_Z ) + ( 16 / 116 );
  }

  float CIEL = ( 116 * var_Y ) - 16;
  float CIEA = 500 * ( var_X - var_Y );
  float CIEB = 200 * ( var_Y - var_Z );

  float[] lab = {CIEL, CIEA, CIEB};

  return lab;
}

float DeltaE94(float[] c1, float[] c2) {
  float CIEL1 = c1[0];
  float CIEA1 = c1[1]; 
  float CIEB1 = c1[2];

  //Color #2 CIE-L*ab values
  float CIEL2 = c2[0];
  float CIEA2 = c2[1]; 
  float CIEB2 = c2[2];

  float WHTL = 1; //lightness
  float WHTC = 1; //chroma
  float WHTH = 1; //hue   
  //Weighting factors

  float xC1 = sqrt( ( pow(CIEA1,2) + pow(CIEB1,2) ) );
  float xC2 = sqrt( ( pow(CIEA2,2 ) + pow( CIEB2, 2) ) );
  float xDL = CIEL2 - CIEL1;
  float xDC = xC2 - xC1;
  float xDE = sqrt( ( ( CIEL1 - CIEL2 ) * ( CIEL1 - CIEL2 ) ) + ( ( CIEA1 - CIEA2 ) * ( CIEA1 - CIEA2 ) ) + ( ( CIEB1 - CIEB2 ) * ( CIEB1 - CIEB2 ) ) );
  float xDH = ( xDE * xDE ) - ( xDL * xDL ) - ( xDC * xDC );
  
  if ( xDH > 0 ) {
    xDH = sqrt( xDH );
  } else {
    xDH = 0;
  }
  
  float xSC = 1 + ( 0.045 * xC1 );
  float xSH = 1 + ( 0.015 * xC1 );
  xDL /= WHTL;
  xDC /= WHTC * xSC;
  xDH /= WHTH * xSH;

  float DeltaE94 = sqrt( pow(xDL,2) + pow(xDC,2) + pow(xDH,2) );

  return DeltaE94;
}