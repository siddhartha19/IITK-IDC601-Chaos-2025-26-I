/*-------------------------------------------------------------
            Maps: Cobweb Diagram 
 Siddhartha Mukherjee, IIT Kanpur, 17 Oct 2025
 
 Plots the cobweb diagram for the Logistic map. 
 The last 15 steps of the map are shown in red (to highlight periodic orbits).
 
   Controls:
   [a/z]  : Increase/Decrease r
   MouseX : Initial condition
   [3]    : Period 3
   [5]    : Period 5
   [7]    : Period 7
   [+/-]  : Increase/Decrease "nlast" i.e. the number of last orbits to be shown in red.
   
----------------------------------------------------------------*/

float r = 3;         //-- Logistic map parameter
int nIter = 500;     //-- Number of iterations to draw
float x0;            //-- Initial condition
int nlast = 15;

color bg   = #000000;
color tr1  = #ffd166;
color tr2  = #d62828;
color bord = #ffffff;
color par  = #0a9396;

void setup() {
  size(600, 600);
  frameRate(30);
  textFont(createFont("Helvetica", 20));
}

void draw() {
  background(bg);
  translate(50, 50);
  float s = width - 100;
  float h = height - 100;

  //-- Axes + Frame
  stroke(bord);
  noFill();
  fill(#252422);
  rect(0, 0, s, h);

  //-- Plot y = x
  stroke(150);
  line(0, h, s, 0);

  //-- Plot logistic map: y = r * x * (1 - x)
  stroke(par);
  strokeWeight(3);
  noFill();
  beginShape();
  for (int i = 0; i <= 500; i++) {
    float x = i / 500.0;
    float y = r * x * (1 - x);
    vertex(x * s, h - y * h);
  }
  endShape();

  //-- Initial condition from mouseX
  x0 = constrain(map(mouseX, 50, width - 50, 0, 1), 0, 1);
  float x = x0;
  float y = 0;

  //-- Cobweb iteration
  stroke(tr1,200);
  strokeWeight(1.5);
  for (int i = 0; i < nIter; i++) {
    float xn1 = r * x * (1 - x);
    float xpix = x * s;
    float ypix = h - xn1 * h;
    if( i >= nIter - nlast ) {
      stroke(tr2);
      strokeWeight(2.5);
    }
    line(xpix, h - y * h, xpix, ypix);  //--Vertical
    line(xpix, ypix, xn1 * s, ypix);    //--Horizontal
    x = xn1;
    y = xn1;    
  }

  //-- Highlight initial condition
  fill(tr1);
  noStroke();
  ellipse(x0 * s, h, 10, 10);

  //-- Display info
  fill(255);
  text("r = " + nf(r, 1, 3), 10, -15);
  text("Nlast = " + nf(nlast), 200, -15);
  text("Initial x₀ = " + nf(x0, 1, 3), 350, -15);
}

//----------------------------------------------
void keyPressed() {
  if (key == 'a' || key == 'A') r += 0.025;
  if (key == 'z' || key == 'Z') r -= 0.025;
  if (key == '3') r = 3.8284271247461903;
  if (key == '5') r = 3.7381723752659624;
  if (key == '7') r = 3.77414;
  if (key == '+') nlast++;
  if (key == '-') nlast--;
  nlast = constrain( nlast, 0, 15 );
  r = constrain(r, 0, 4);
}
