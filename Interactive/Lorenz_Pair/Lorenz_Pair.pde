/*
-----------------------------------------------------------
              Nonlinear Dynamics and Chaos
    Lorenz Attractor - A pair of nearby trajectories
    by Siddhartha Mukherjee, IIT Kanpur, 7 Oct 2025
-----------------------------------------------------------
                    
  Interactive Processing sketch to visualize evolution of
  a pair of nearby trajectories under the Lorenz equations.
  
  Features:
   - Particle trajectories with bounded history (ring buffer).
   - Toggleable visualizations
   - Basic "Symbolic Dynamics" visualizer
 
  Key Controls:
   [p]   Show/Hide phase-plane projections
   [t]   Show/Hide trajectories in phase-plane
   [l]   Show/Hide line connecting the pair of points in phase-plane. Useful to visualize separation "on" the attractor, i.e with the above "t".
   [s]   Show symbolically whether trajectory is at x>0 or x<0
   [r]   Restart trajectories from random initial conditions
   [click] To Pause/Play
   [space] Saveframe
   
  Parameters:
   sigma, beta: Lorenz model parameters
   rho        : Lorenz model parameter - Rayleigh Number. Try changing to 15, observe the stable C+ and C- fixed points 
                which undergo a subcritical Hopf bifurcation leading to Chaos
   eps        : Initial separation
   trajSkip   : To plot only a sampling of points along trajectory in phase plane, for efficiency. Can reduce from 10 to 5 or 2 depending on your PC
   rfac       : Range of random initial conditions
   x0,y0,z0   : Initial condition
   
   
   Inside setup(), uncomment the last line to add a third trajectory.
 
*/

//-- Lorenz model parameters
float sigma = 10.0;
float rho   = 28.0;  
float beta  = 8.0/3.0;
float dt = 0.001;
int stepsPerFrame = 50;
float eps = 0.001;        //-- Initial separation between trajectories
//-- Initial conditions 1
float x0 = 5.0;
float y0 = 5.0;
float z0 = 5.0;

float rfac = 5.0; //-- Range allowed for random initial conditions in x,y,z

boolean toLoop = true;
boolean showSym = false;
boolean showPhase = false;
boolean showPhaseTraj = true;
boolean showLine = false;

float Twindow = 10.0;
int N = int(Twindow / dt);

int W = 900, H = 600;
float margin = 40;

color[] colors = {#ffb703, #219ebc, #e63946, #a1c181};

float tglob = 0.0;
ArrayList<Trajectory> trajs = new ArrayList<Trajectory>();

float x1, y1, z1, x2, y2, z2; 
int trajskip = 10; //-- Show every nth point in trajectory history, for efficiency

void setup() {
  size(900, 600);
  frameRate(30);
  background(0);
  strokeWeight(1.5);

  //-- Initial trajectory
  trajs.add(new Trajectory(x0, y0, z0, colors[0]));
  trajs.add(new Trajectory(x0+eps, y0+eps, z0+eps, colors[1]));
  //trajs.add(new Trajectory(x0-eps, y0+eps, z0+eps, colors[2]));

}

void draw() {
  //-- Top
  fill(0);
  noStroke();
  rect(0,0,width-margin, height/2);
  
  //-- Bottom
  fill(0);
  noStroke();
  rect(0,height/2-25,width, height/2+25);
  
  //-- Right Sym
  fill(0,50);
  noStroke();
  rect(width-margin,0,margin, height);

  //-- Integrate all trajectories
  for (Trajectory tr : trajs) tr.stepRK4();

  Trajectory ref = trajs.get(0);
  drawTimeSeries(ref.tcur);
  
  if(showPhase) {
    drawPhasePortraits();
    if(showLine) drawLine();
  }
  
  text("t = " + String.format("%.3f", tglob), width/2 - 30, 25);  
  tglob += stepsPerFrame*dt;

}

void drawLine() {
  Trajectory ref = trajs.get(0);
  int count = ref.filled ? N : ref.head;
  int idx = ref.filled ? (ref.head + count - 1) % N : count - 1;

  x1 = ref.x[idx];
  y1 = ref.y[idx];
  z1 = ref.z[idx];
  ref = trajs.get(1);
  count = ref.filled ? N : ref.head;
  idx = ref.filled ? (ref.head + count - 1) % N : count - 1;
  x2 = ref.x[idx];
  y2 = ref.y[idx];
  z2 = ref.z[idx];

  float boxSize = (width - 4*margin) / 3.0;
  float top = height/2;
  float x1_h, y1_v, y1_h, z1_v;
  float x2_h, y2_v, y2_h, z2_v;

  x1_h = map(x1, -25, 25, margin, margin+boxSize);
  x2_h = map(x2, -25, 25, margin, margin+boxSize);
  y1_v = map(y1, -35, 35, top+boxSize, top);
  y1_h = map(y1, -35, 35, margin, margin+boxSize);
  y2_v = map(y2, -35, 35, top+boxSize, top);
  y2_h = map(y2, -35, 35, margin, margin+boxSize);
  z1_v = map(z1, -5, 55, top+boxSize, top);
  z2_v = map(z2, -5, 55, top+boxSize, top);

  fill(255);
  stroke(255);
  strokeWeight(1);
  line(x1_h, y1_v, x2_h, y2_v);
  line(margin+boxSize+x1_h, z1_v, margin+boxSize+x2_h, z2_v);
  line(2*margin+2*boxSize+y1_h, z1_v,2*margin+2*boxSize+y2_h, z2_v);
}

float[] lorenz(float xx, float yy, float zz) {
  float dx = sigma * (yy - xx);
  float dy = xx * (rho - zz) - yy;
  float dz = xx*yy - beta*zz;
  return new float[]{dx, dy, dz};
}

//-- Drawing Panels
void drawTimeSeries(float t) {
  float left = margin;
  float right = width - margin;
  float top = margin;
  float bottom = height/2 - margin;

  if(showPhase) {
    stroke(155);
    strokeWeight(2.0);
  } else {
    stroke(255);
    strokeWeight(2);
  }

  noFill();
  rect(left, top, right-left, bottom-top);
  
  strokeWeight(2);
  line(left-5, top+(bottom-top)/2, left+5, top+(bottom-top)/2);

  for (Trajectory tr : trajs) {
    tr.drawTimeSeries(left, right, top, bottom, t);

    if(showSym){
      if(tr.xsign>0) {
        noStroke();
        fill(tr.col);
        rect(right + 10, top, 10, (bottom-top)/2);
      } else {
        noStroke();
        fill(tr.col);
        rect(right + 10, top + (bottom-top)/2, 10, (bottom-top)/2);
      }
    }
  }

  fill(255);
  textSize(20);
  text("x(t)", left+10, top+25);
}

void drawPhasePortraits() {
  float boxSize = (width - 4*margin) / 3.0;
  float top = height/2;

  drawProjection(margin, top, boxSize, "x", "y");
  drawProjection(2*margin + boxSize, top, boxSize, "x", "z");
  drawProjection(3*margin + 2*boxSize, top, boxSize, "y", "z");
}

void drawProjection(float x0, float y0, float s, String ax1, String ax2) {
  stroke(255);
  strokeWeight(2);
  noFill();
  rect(x0, y0, s, s);
  for (Trajectory tr : trajs) {
    tr.drawProjectionSimple();
  }
  fill(255);
  text(ax1 + "-" + ax2, x0+5, y0+15);
}

//-- Interaction

 void mousePressed() {
   toLoop = !toLoop;
   if(toLoop){
     loop();
   }
   else {
     noLoop();
   }
 }

void keyPressed() {
  if (key == 'c' || key == 'C') {
    Trajectory ref = trajs.get(0);
    trajs.clear();
    trajs.add(ref);
  }
  
  if (key == 'r' || key == 'R') {
    trajs.clear();
    float x0 = random(-1,1)*rfac;
    float y0 = random(-1,1)*rfac;
    float z0 = random(-1,1)*rfac;
    trajs.add(new Trajectory(x0, y0, z0, colors[0]));
    trajs.add(new Trajectory(x0+eps, y0+eps, z0+eps, colors[1]));
    tglob = 0.0;
  }  
  
  if(key=='p' || key == 'P') showPhase = !showPhase;
  if(key=='l' || key == 'L') showLine = !showLine;
  if(key=='t' || key == 'T') showPhaseTraj = !showPhaseTraj;
  if(key=='s' || key == 'S') showSym = !showSym;
  
  if (key == ' ') {
    String timestamp = nf(year(), 4) + nf(month(), 2) + nf(day(), 2) + "_" +
                       nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    String filename = "frame_" + timestamp + ".png";
    saveFrame(filename);
    println("Saved frame: " + filename);
  }
  
}
