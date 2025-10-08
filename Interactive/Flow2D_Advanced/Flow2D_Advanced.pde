/*
-----------------------------------------------------------
              Nonlinear Dynamics and Chaos
    2D Phase Portrait Visualizer - With more Features
    by Siddhartha Mukherjee, IIT Kanpur, 12 Sep 2025
-----------------------------------------------------------
                    
  Interactive Processing sketch to explore 2D dynamical systems
  by integrating particle trajectories in a flow field.
  
  Features:
   - Particle trajectories with bounded history (ring buffer).
   - Vector field visualization with arrowheads.
   - Zoom in/out on the domain.
   - Toggleable overlays for grid, nullclines, and equilibria.
 
  Key Controls:
   [+]   Zoom in (decrease domain range)
   [-]   Zoom out (increase domain range)
   [v]   Toggle vector field visibility
   [g]   Toggle grid visibility
   [n]   Toggle nullclines visibility (dudt=0 and dvdt=0 curves)
   [p]   Toggle view current particle coordinates
   [e]   Toggle equilibrium points (fixed points of the system) !!-- Approximate calculation only!
   [s]   Save current view as image
   [c]   Clear all trajectories
   
  Parameteres:
   Ntot : Total number of points in particle trajectory history
   xmin, xmax, ymin, ymax : Range of the phase-plane
   maglim : Maximum size of the vectors
   step : Steps in pixels between consecutive phase-plane vectors
 
*/

float a11 = -1.0;
float a12 = 1.0;
float a21 = 1.0;
float a22 = 0.0;
//-- Limits of the axes: (xmin, xmax) and (ymin, ymax)
float range = 10.0;
//float xmin = -1, xmax = 4, ymin = -1, ymax = 4;
float xmin = -range, xmax = range, ymin = -range, ymax = range;

float dt = 4.0;      //-- Used for drawing the vector field
float step = 25;
float dtpart = 0.02; //-- Time step for particle evolution
float maglim = 12.0;

float axisdiv = 5;

int Ntot = 200; //-- History length of trajectories
color bg = #000000;
color [] cols = {#ff595e, #ff7655, #ff924c, #ffae43, #ffca3a, #c5ca30, #8ac926, #52a675, #1982c4, #6a4c93, #005f73, #0a9396, #94d2bd, #e9d8a6, #ecba53, #ee9b00, #ca6702, #bb3e03, #ae2012, #9b2226, #2b9348, #80b918, #bfd200, #dddf00, #ffff3f};

boolean symplectic = true;
boolean cfl = false; float cfldx = 20; //-- Reduce for a stronger CFL criterion
boolean showField = true;   
boolean showGrid = false;
boolean showNullclines = false;
boolean showEquilibria = false;
boolean showCoord = false;

ArrayList<Particle> particles;

void setup() {
  smooth();
  size(800,800);
  background(bg);
  drawBoundingBox();

  particles = new ArrayList<Particle>();
  //particles.add(new Particle(random(-range, range), random(-range, range), color(255,0,0)));

  showVecField(); 
}

void draw() {
  background(bg);
  if (showGrid) drawGrid();
  
  if (showField) showVecField();

  for (Particle p : particles) {
    p.update();
    p.render();   // render based on current zoom
  }
  
  if (showNullclines) {
    updateNullclines(range, width);
    if (nullclineLayer != null) {
      image(nullclineLayer, 0, 0);
    }
  }

  maybeUpdateEquilibria(range);
  showfps();
  
}


// Add a new trajectory at the clicked location
void mousePressed() {
  float x = map(mouseX, 0, width, xmin, xmax);
  float y = map(height - mouseY, 0, height, ymin, ymax); //-- Taking the y wrt bottom of the window as 0, then mapped to -range,range
  particles.add(new Particle(x, y, cols[int(random(cols.length))]));
}

void mouseDragged() {
  float x = map(mouseX, 0, width, xmin, xmax);
  float y = map(height - mouseY, 0, height, ymin, ymax); //-- Taking the y wrt bottom of the window as 0, then mapped to -range,range
  particles.add(new Particle(x, y, cols[int(random(cols.length))]));
}

//-- Mapping between simulation coordinates and "viewing window" size
float sx(float x) { return map(x, xmin, xmax, 0, width); }
float sy(float y) { return map(y, ymin, ymax, height, 0); }

void drawBoundingBox() {
  stroke(225); // bluish box in HSB
  strokeWeight(5);
  noFill();
  
  rectMode(CORNERS);
  rect(0,0,width,height);
}

void drawGrid() {
  stroke(175);
  strokeWeight(1);
  fill(255);
  textAlign(CENTER, TOP);
  textSize(20);
  // vertical lines at -range, 0, +range
  for (float x = xmin; x <= xmax; x += (xmax-xmin)/axisdiv) {
    line(sx(x), sy(ymin), sx(x), sy(ymax));
    text(nf(x,1,0), sx(x), sy(0) + 4); // label below axis
  }

  // horizontal lines at -range, 0, +range
  for (float y = ymin; y <= ymax; y += (ymax-ymin)/axisdiv) {
    if(y != 0) line(sx(xmin), sy(y), sx(xmax), sy(y));
    if (y != 0) text(nf(y,1,0), sx(0) + 15, sy(y)-6); // label on side
  }

  // central axes
  stroke(255);
  strokeWeight(2);
  line(sx(xmin), sy(0), sx(xmax), sy(0));  // x-axis
  line(sx(0), sy(ymin), sx(0), sy(ymax));  // y-axis
}
