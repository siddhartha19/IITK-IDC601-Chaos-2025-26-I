/*--------------------------------------------
            Dynamics on a Torus
 Siddhartha Mukherjee, IIT Kanpur, 7 Sep 2025
 
                  CONTROLS:
 - Mouse click: Start a new trajectory with (theta1, theta2) set by mouse position.
 - 'w' key: Toggle torus (on/off).
 - 'i' key: Toggle inset phase-space plot (on/off) --- NOTE: Best to view the inset briefly, then switch off
 - 'c' key: Clear all trajectories.
 - 'r' key: Toggle rotation (on/off).
 - '+/-': Speed up/Slow down rotation.
 - 'space': Saveframe
 
        See "readme" for more details
----------------------------------------------*/

//-- Parameters to simply "draw" the torus
int nu = 50, nv = 50;     //-- Number of points
float R1 = 150, R2 = 120; //-- Radii

//-- Parameters for dynamics
float a = 2;
float b = PI;
float dt = 0.04;  //-- Integration time step
int Nt = 1000;    //-- Trail length (ring buffer)

ArrayList<Trajectory> trajectories;

boolean showWireframe = true; //-- Toggle variable
boolean showInset = false;    //-- Global flag
boolean rotateTorus = true;   //-- Toggle with a key
float angleY = 0; float angleIncr = 0.01; //-- Current rotation angle

PGraphics inset;
PVector[][] torusGrid;

void setup() {
  size(800, 800, P3D);
  trajectories = new ArrayList<Trajectory>();  
  inset = createGraphics(200, 200);
  
  torusGrid = new PVector[nu][nv];
  for (int i=0; i<nu; i++) {
    float u = map(i,0,nu,0,TWO_PI);
    for (int j=0; j<nv; j++) {
      float v = map(j,0,nv,0,TWO_PI);
      torusGrid[i][j] = torusPoint(u,v);
    }
  }
  
}

void draw() {
  background(0);
  
  lights();
  translate(width/2, height/2, 0);
  rotateX(PI/6);
  if (rotateTorus) angleY += angleIncr;
  rotateY(angleY);

  if (showWireframe) {
    drawTorusPoints();
  }

  for (Trajectory tr : trajectories) {
    tr.update();
    tr.render();
  }
  
  makeinset();
}

void drawTorusWireframe() {
  stroke(100);
  noFill();
  for (int i = 0; i < nu; i++) {
    float u = map(i, 0, nu, 0, TWO_PI);
    beginShape();
    for (int j = 0; j < nv; j++) {
      float v = map(j, 0, nv, 0, TWO_PI);
      PVector p = torusPoint(u, v);
      vertex(p.x, p.y, p.z);
    }
    endShape(CLOSE);
  }
}

void drawTorusPoints() {
  stroke(255);
  strokeWeight(2);
  noFill();

  for (int i=0; i<nu; i++) {
    for (int j=0; j<nv; j++) {
      PVector p = torusGrid[i][j];
      point(p.x, p.y, p.z);
    }
  }
}

PVector torusPoint(float theta1, float theta2) {
  float x = (R1 + R2 * cos(theta2)) * cos(theta1);
  float y = (R1 + R2 * cos(theta2)) * sin(theta1);
  float z = R2 * sin(theta2);
  return new PVector(x, y, z);
}

class Trajectory {
  float theta1, theta2;
  ArrayList<PVector> history = new ArrayList<PVector>();
  ArrayList<PVector> angleHistory = new ArrayList<PVector>();
  color col;

  Trajectory(float th1, float th2) {
    theta1 = th1;
    theta2 = th2;
    col = color(random(80,255), random(80,255), random(80,255));
  }

  void update() {
    //-- Get dynamics
    PVector dth = dynamics(theta1, theta2);

    //-- Euler Step
    theta1 = (theta1 + dth.x * dt) % TWO_PI;
    theta2 = (theta2 + dth.y * dt) % TWO_PI;

    //-- Wrap theta
    if (theta1 < 0) theta1 += TWO_PI;
    if (theta2 < 0) theta2 += TWO_PI;

    //-- Add to History
    history.add(torusPoint(theta1, theta2));
    if (history.size() > Nt) history.remove(0);
    
    angleHistory.add(new PVector(theta1, theta2));
    if (angleHistory.size() > Nt) angleHistory.remove(0);
  }

  void render() {
    stroke(col);
    noFill();
    beginShape();
    strokeWeight(2);
    for (PVector p : history) {
      vertex(p.x, p.y, p.z);
      //point(p.x, p.y, p.z);
    }
    endShape();

    if (!history.isEmpty()) {
      PVector last = history.get(history.size()-1);
      pushMatrix();
      translate(last.x, last.y, last.z);
      noStroke();
      fill(col);
      sphere(7);
      popMatrix();
    }
  }
}

void mousePressed() {
  float th1 = map(mouseX, 0, width, 0, TWO_PI);
  float th2 = map(mouseY, 0, height, 0, TWO_PI);
  trajectories.add(new Trajectory(th1, th2));
}

void keyPressed() {
  if (key == 'i' || key == 'I') showInset = !showInset;  
  if (key == 'w' || key == 'W') showWireframe = !showWireframe;
  if (key == 'c') trajectories.clear();
  if (key == 'r' || key == 'R') rotateTorus = !rotateTorus; 
  if (key == '+') angleIncr *= 1.25;
  if (key == '-') angleIncr *= 0.75;
  if (key == ' ') {
    String timestamp = nf(year(), 4) + nf(month(), 2) + nf(day(), 2) + "_" +
                       nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    String filename = "frame_" + timestamp + ".png";
    saveFrame(filename);
    println("Saved frame: " + filename);
  }
}
