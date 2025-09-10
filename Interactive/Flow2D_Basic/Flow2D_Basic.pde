/**
-----------------------------------------------------------
              Nonlinear Dynamics and Chaos
      2D Phase Portrait Visualizer - Basic Version
    by Siddhartha Mukherjee, IIT Kanpur, 31 Aug 2025
-----------------------------------------------------------
                    
Interactive Processing sketch to explore 2D dynamical systems
by integrating particle trajectories in a flow field.

Features:
  * Vector field visualization -- The length and opacity of the vectors reflects their magnitude

Interactions:
  [Click]  Spawn a new trajectory at the clicked position
  [c]      Clear all trajectories
  [s]      Save a "png" image of the current state
*/

float a11 = 1, a12 = 0, a21 = 0, a22 = -2;
float range = 5.0;   //-- Range of the axes 
float dt = 5.0;      //-- Used for drawing the vector field
float step = 25;     //-- Distance between vectors in pixel-based grid spacing
float dtpart = 0.01; //-- Time step for trajectory evolution (should be small!)
float maglim = 12.0; //-- Limit the visual size of the largest vectors to avoid clutter.

color bg = #000000;
//-- Colours for trajectories: You can replace these with what you like. Some inspiration can be found at https://coolors.co/ ("Explore palettes")
color [] cols = {#ff595e, #ff7655, #ff924c, #ffae43, #ffca3a, #c5ca30, #8ac926, #52a675, #1982c4, #6a4c93, #005f73, #0a9396, #94d2bd, #e9d8a6, #ecba53, #ee9b00, #ca6702, #bb3e03, #ae2012, #9b2226, #2b9348, #80b918, #bfd200, #dddf00, #ffff3f};

boolean symplectic = true;
boolean cfl = false; float cfldx = 20;
ArrayList<Particle> particles;

boolean dragged = false;

void setup() {
  smooth();
  size(800,800);
  background(bg);
  drawBoundingBox();

  particles = new ArrayList<Particle>();
  showVecField(); 
}

void draw() {
  for (Particle p : particles) {
    p.update();
  }
}

//-- Add a new trajectory at the clicked location
void mousePressed() {
  float x = map(mouseX, 0, width, -range, range);
  float y = map(height - mouseY, 0, height, -range, range); //-- Taking the y wrt bottom of the window as 0, then mapped to -range,range
  particles.add(new Particle(x, y, cols[int(random(cols.length))]));
}

//-- Press 'c' to clear trails and redraw the vector field
void keyPressed() {
  if (key == 'c' || key == 'C') {
    background(bg);
    showVecField();
    particles.clear();
    drawBoundingBox();
  }

  if (key == 's' || key == 'S') {
    saveHighRes();
  }
}

//-- Mapping between simulation coordinates and "viewing window" size
float sx(float x) { return map(x, -range, range, 0, width); }
float sy(float y) { return map(y, -range, range, height, 0); }

void drawBoundingBox() {
  stroke(225); // bluish box in HSB
  strokeWeight(5);
  noFill();
  
  rectMode(CORNERS);
  rect(0,0,width,height);
}
