/*--------------------------------------------
            	Lorenz 3D
 Siddhartha Mukherjee, IIT Kanpur, 15 Oct 2025
 
   Keyboard Controls:
   [T]  : Toggle display of the trajectories
   [E]  : Toggle evolution (pause/resume integration) of all trajectories
   [+]  : Increase camera rotation speed 
   [-]  : Decrease camera rotation speed 
   [Click] : Toggle rotation on/off
   [R]  : Reset the trajectories with random initial conditions in a cube of edge = 2 X eps
   [A]  : Toggle display of the underlying attractor
   [C]  : Colour trajectories by their x-location, reset simulation

   Notes:
   - The 'e' toggle pauses numerical integration without resetting time.
   - '+' and '-' let you smoothly adjust the rotational motion for viewing.
   - The attractor and trajectory toggles allow isolating visual elements.
   
   Demo:
   You can start by running the code to see the attractor alone. Now press "T" to display the initial location of the trajectories. 
   Press "E" to evolve them/pause evolution (you can pause rapidly to see the dimensionality reduction in the initial conditions cloud).
   Try this for various initial conditions. After a long meditation on the key features of evolution under Lorenz dynamics (presence of
   the saddle at the origin, two unstable cycles around C+ and C-, sensitive dependence on IC etc), you can explore chaotic mixing.  
   For this, reset the simulation by pressing "C" which will colour initial conditions by their x-location. Increase the number of trajectories to 10000 or more, 
   toggle off the attractor view, and observe an essential feature of chaotic dynamics - "stretching and folding", which can rapidly
   separate nearby trajectories in phase-space. 
   
   You can also restart the simulation with a very large "eps" value, to see how a very large set of initial conditions is attracted, 
   the early stages of approach to the attractor is an interesting phase, where trajectories are "folded up" by the "spiral arms" and 
   drawn into the attractor. 
                   
----------------------------------------------*/

//-- Lorenz model parameters
float sigma = 10.0;
float rho   = 28.0;  
float beta  = 8.0/3.0;
float dt = 0.001;

int stepsPerFrame = 5; //-- For trajectories
int stepsLocal = 15;   //-- For attractor

float eps = 2;  //-- Initial separation between trajectories
//-- Initial conditions 1
float x0 = 5.0;
float y0 = 5.0;
float z0 = 5.0;

boolean evolTraj = false;       //-- [e]
boolean toggleRotation = true;  //-- [Click]
boolean showAttr = true;        //-- [a]
boolean showTraj = false;       //-- [t]

int ncloud = 50000;
int nattr = 10000;

boolean rotate = true;   //-- Toggle with a key
float angleY = 0; 
float angleIncr = 0.02;
float zoff = 200;
float scale = 8;

ArrayList<Trajectory> trajs = new ArrayList<Trajectory>();
color[] cols = {#ffb703, #219ebc, #e63946, #a1c181};
Attractor attr;

color c1 = #ffbe0b;
color c2 = c1; 

void setup() {
  size(800, 800, P3D);
  
  for(int i=0; i<ncloud; ++i){
    float xr = random(-eps,eps);
    trajs.add(new Trajectory(x0+xr, y0+random(-eps,eps), z0+random(-eps,eps), lerpColor(c1,c2,(xr+eps)/(2*eps))) );
  }
  
  attr = new Attractor( #00b4d8 );
  attr.genAttractor();
}

void draw() {
  background(0);
  lights();

  pushMatrix();
  translate(width/2, height/2, 0);
  if (toggleRotation) angleY += angleIncr;
  rotateY(angleY);
  
  if(showTraj) {
    for (Trajectory tr : trajs) {
      if(evolTraj) tr.stepRK4();
      tr.drawTrajPoint();
    }
  }
  
  if(showAttr) attr.drawAttractor();

  popMatrix();
}

void keyPressed() {
  if(key=='e' || key == 'E') evolTraj = !evolTraj;
  if (key == '+') angleIncr *= 1.25;
  if (key == '-') angleIncr *= 0.75;
  if(key=='r' || key == 'R') reset();
  if(key=='a' || key == 'A') showAttr = !showAttr;
  if(key=='t' || key == 'T') showTraj = !showTraj;
  
  if(key=='c' || key=='C') {c2 = #ff006e; reset();}

  if(key=='s' || key=='S') {
    String timestamp = nf(year(), 4) + nf(month(), 2) + nf(day(), 2) + "_" +
                       nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    String filename = "frame_" + timestamp + ".png";
    saveFrame(filename);
    println("Saved frame: " + filename);
  }

}

void reset() {
  evolTraj = false;
  trajs.clear();
  float x1 = random(-25,25);
  float y1 = random(-35,35);
  float z1 = random(-5,50);
  
  for(int i=0; i<ncloud; ++i){
    float xr = random(-eps,eps);
    trajs.add(new Trajectory(x1+xr, y1+random(-eps,eps), z1+random(-eps,eps), lerpColor(c1,c2,(xr+eps)/(2*eps))) );
  }
  
}

void mousePressed() {
  toggleRotation = !toggleRotation;
}
