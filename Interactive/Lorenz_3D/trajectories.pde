//-- Trajectory class with ring buffer
class Trajectory {
  int xsign;
  float x, y, z, t;
  color col;

  Trajectory(float x0, float y0, float z0, color c) {
    x = x0; y = y0; z = z0; t = 0; col = c; xsign = 0;
  }

  void stepRK4() {
    for (int i = 0; i < stepsPerFrame; i++) {
      float[] k1 = lorenz(x, y, z);
      float[] k2 = lorenz(x + 0.5*dt*k1[0], y + 0.5*dt*k1[1], z + 0.5*dt*k1[2]);
      float[] k3 = lorenz(x + 0.5*dt*k2[0], y + 0.5*dt*k2[1], z + 0.5*dt*k2[2]);
      float[] k4 = lorenz(x + dt*k3[0], y + dt*k3[1], z + dt*k3[2]);
      
      x += dt/6.0 * (k1[0] + 2*k2[0] + 2*k3[0] + k4[0]);
      y += dt/6.0 * (k1[1] + 2*k2[1] + 2*k3[1] + k4[1]);
      z += dt/6.0 * (k1[2] + 2*k2[2] + 2*k3[2] + k4[2]);
      t += dt;
    }
    xsign = x > 0 ? 1 : -1;
  }

  void drawTrajPoint() {
    stroke(col,255);
    strokeWeight(3);
    point(x*scale,zoff-z*scale,y*scale);
  }
}

float[] lorenz(float xx, float yy, float zz) {
  float dx = sigma * (yy - xx);
  float dy = xx * (rho - zz) - yy;
  float dz = xx*yy - beta*zz;
  return new float[]{dx, dy, dz};
}

//-- Trajectory class with ring buffer
class Attractor {
  int N = nattr;
  float[] x = new float[N];
  float[] y = new float[N];
  float[] z = new float[N];
  float[] tt = new float[N];
  color col;
  
  float x0 = 5.0, y0 = 5.0, z0 = 5.0;

  Attractor(color c) {
    col = c; 
  }
  
  void genAttractor() {
    //-- First get to the attractor
    for(int i=0; i<5000; ++i) {
      float [] xv = stepRK4Single( x0, y0, z0 );
      x0 = xv[0]; y0 = xv[1]; z0 = xv[2];
    }
    println(x0,y0,z0);
    //-- Now generate attractor points
    for(int i=0; i<N; ++i) {
       for(int n=0; n<stepsLocal; ++n) { 
         float [] xv = stepRK4Single( x0, y0, z0 );
         x0 = xv[0]; y0 = xv[1]; z0 = xv[2];         
       }
       x[i] = x0; y[i] = y0; z[i] = z0;
       tt[i] = i*dt;
      }
   }

  float[] stepRK4Single(float x_, float y_, float z_) {
    float[] k1 = lorenz(x_, y_, z_);
    float[] k2 = lorenz(x_ + 0.5*dt*k1[0], y_ + 0.5*dt*k1[1], z_ + 0.5*dt*k1[2]);
    float[] k3 = lorenz(x_ + 0.5*dt*k2[0], y_ + 0.5*dt*k2[1], z_ + 0.5*dt*k2[2]);
    float[] k4 = lorenz(x_ + dt*k3[0], y_ + dt*k3[1], z_ + dt*k3[2]);
    
    x_ += dt/6.0 * (k1[0] + 2*k2[0] + 2*k3[0] + k4[0]);
    y_ += dt/6.0 * (k1[1] + 2*k2[1] + 2*k3[1] + k4[1]);
    z_ += dt/6.0 * (k1[2] + 2*k2[2] + 2*k3[2] + k4[2]);
    
    return new float[]{x_, y_, z_};
  }

  void drawAttractor() {
    stroke(col,255);
    strokeWeight(2);
    for(int i=0; i<N; i+=1) {
      point(x[i]*scale,zoff-z[i]*scale,y[i]*scale);
    }
  }
}
