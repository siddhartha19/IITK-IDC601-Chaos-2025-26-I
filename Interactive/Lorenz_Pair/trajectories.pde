//-- Trajectory class with ring buffer
class Trajectory {
  float[] x = new float[N];
  float[] y = new float[N];
  float[] z = new float[N];
  float[] tt = new float[N];
  int head = 0;
  boolean filled = false;
  int xsign;

  float xcur, ycur, zcur, tcur;
  color col;

  Trajectory(float x0, float y0, float z0, color c) {
    xcur = x0;
    ycur = y0;
    zcur = z0;
    tcur = 0;
    col = c;
    xsign = 0;
  }

  void stepRK4() {
    for (int i = 0; i < stepsPerFrame; i++) {
      float[] k1 = lorenz(xcur, ycur, zcur);
      float[] k2 = lorenz(xcur + 0.5*dt*k1[0], ycur + 0.5*dt*k1[1], zcur + 0.5*dt*k1[2]);
      float[] k3 = lorenz(xcur + 0.5*dt*k2[0], ycur + 0.5*dt*k2[1], zcur + 0.5*dt*k2[2]);
      float[] k4 = lorenz(xcur + dt*k3[0], ycur + dt*k3[1], zcur + dt*k3[2]);
      
      xcur += dt/6.0 * (k1[0] + 2*k2[0] + 2*k3[0] + k4[0]);
      ycur += dt/6.0 * (k1[1] + 2*k2[1] + 2*k3[1] + k4[1]);
      zcur += dt/6.0 * (k1[2] + 2*k2[2] + 2*k3[2] + k4[2]);
      tcur += dt;
      storePoint();
      xsign = xcur > 0 ? 1 : -1;
    }
  }

  void storePoint() {
    x[head] = xcur;
    y[head] = ycur;
    z[head] = zcur;
    tt[head] = tcur;
    head = (head + 1) % N;
    if (head == 0) filled = true;
  }

  void drawTimeSeries(float left, float right, float top, float bottom, float t) {
    stroke(col);
    noFill();
    strokeWeight(2);

    int count = filled ? N : head;
    float tmin = t - Twindow;
    float ypfac = (bottom-top)/50.0;
    float ypcent = top + (bottom-top)*0.5;


    for (int k = 0; k < count; k++) {
      int idx = filled ? (head + k) % N : k;
      float tt0 = tt[idx];
      if (tt0 >= tmin) {

        float xp = map(tt0, tmin, t, left, right);
        // float yp = map(x[idx], -25, 25, bottom, top);
        float yp = ypcent - x[idx]*ypfac;
        point(xp, yp);        
      }
    }
    
    //-- Highlight current point
    int idx = filled ? (head + count - 1) % N : count - 1;
    float xp = right;//map(1, tmin, t, left, right);
    float yp = map(x[idx], -25, 25, bottom, top);
    fill(col);
    noStroke();
    ellipse(xp, yp, 8, 8);
   
  }

  void drawProjectionSimple() {
    stroke(col,150);
    strokeWeight(1.5);
    noFill();
    int count = filled ? N : head;

    float boxSize = (width - 4*margin) / 3.0;
    float top = height/2;
    float xp_h, yp_v, yp_h, zp_v;
    int idx;

    if(showPhaseTraj){
      for (int k = 0; k < count; k+=trajskip) {
        idx = filled ? (head + k) % N : k;
        //-- x wrt 1st box
        xp_h = map(x[idx], -25, 25, margin, margin+boxSize);
        //-- y wrt 1st box
        yp_v = map(y[idx], -35, 35, top+boxSize, top);
        yp_h = map(y[idx], -35, 35, margin, margin+boxSize);
        //-- z wrt 1st box
        zp_v = map(z[idx], -5, 55, top+boxSize, top);

        // point(xp_h, yp_v);
        // point(margin+boxSize+xp_h, zp_v);
        // point(2*margin+2*boxSize+yp_h, zp_v);

        fill(col, 150);
        noStroke();
        float rr = 1.5;
        ellipse(xp_h, yp_v, rr, rr);
        ellipse(margin+boxSize+xp_h, zp_v, rr, rr);
        ellipse(2*margin+2*boxSize+yp_h, zp_v, rr, rr);
      }
    }

    idx = filled ? (head + count - 1) % N : count - 1;
    //-- Highlight current point
    xp_h = map(x[idx], -25, 25, margin, margin+boxSize);
    yp_v = map(y[idx], -35, 35, top+boxSize, top);
    yp_h = map(y[idx], -35, 35, margin, margin+boxSize);
    zp_v = map(z[idx], -5, 55, top+boxSize, top);

    fill(col);
    noStroke();
    stroke(255);
    strokeWeight(0.5);
    float rr = 6;
    ellipse(xp_h, yp_v, rr, rr);
    ellipse(margin+boxSize+xp_h, zp_v, rr, rr);
    ellipse(2*margin+2*boxSize+yp_h, zp_v, rr, rr);

  }

  float getVal(int idx, String ax) {
    if (ax.equals("x")) return x[idx];
    if (ax.equals("y")) return y[idx];
    if (ax.equals("z")) return z[idx];
    return 0;
  }
}
