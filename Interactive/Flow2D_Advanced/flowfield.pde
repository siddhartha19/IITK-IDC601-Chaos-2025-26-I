float getudot(float irel, float jrel){
   //return a11*irel + a12*jrel;
   return irel*(3.0 - irel - 2.0*jrel);
   //return jrel;
  //return sin(2.0*jrel);
}

float getvdot(float irel, float jrel){
   //return -1 * jrel * (irel*irel-1) - irel;
   //return a21*irel + a22*jrel;
   return jrel*(2.0 - irel - jrel);

  //return 0.5*(1.0-irel*irel)*jrel - irel;
}


//=====================================================================================

void showVecField() {
  color cc = #bcb8b1;//#fdf0d5;
  stroke(cc);
  strokeWeight(1.5);
  noFill();
  float x1, y1, x2, y2, angle, ahSize, angle1, angle2;
  for (float i = 0; i <= width; i += step) {
    for (float j = 0; j <= height; j += step) {
      float irel = map(i, 0, width, xmin, xmax);
      float jrel = map(j, 0, height, ymax, ymin); //-- Again flipping y to set y=0 to the bottom of the screen i.e. to be mapped to -range
      float udot = getudot(irel, jrel);
      float vdot = -getvdot(irel, jrel); //-- Taking -vdot since y-direction in Processing points downwards
      float mag = sqrt(udot*udot + vdot*vdot);
      if (mag > maglim) {
        udot = udot * maglim / mag;
        vdot = vdot * maglim / mag;
      }
      
      float brightness = constrain(mag / maglim, 0, 1);

      stroke(cc, brightness*200);
      x1 = i; y1 = j;
      x2 = i + udot*dt; y2 = j + vdot*dt;
      
      line(x1, y1, x2, y2);
      angle = atan2(y2 - y1, x2 - x1);
      ahSize = 6; // arrowhead size
      angle1 = angle + PI/8;
      angle2 = angle - PI/8;
      line(x2, y2, x2 - ahSize*cos(angle1), y2 - ahSize*sin(angle1));
      line(x2, y2, x2 - ahSize*cos(angle2), y2 - ahSize*sin(angle2));
    }
  }

  //-- Axes
  stroke(250);
  strokeWeight(2);

  //-- Vertical axis (x=0)
  float x0 = sx(0);
  line(x0, 0, x0, height);

  //-- Horizontal axis (y=0)
  float y0 = sy(0);
  line(0, y0, width, y0);

}
