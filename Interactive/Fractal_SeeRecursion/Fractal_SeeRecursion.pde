/*
-----------------------------------------------------------
              Nonlinear Dynamics and Chaos
                 Visualizing Recursion
    by Siddhartha Mukherjee, IIT Kanpur, 6 Nov 2025
-----------------------------------------------------------
                    
  Visualizing the recursion algorithm for drawing the fractal trees
*/


float thp = 0.0, thm = 0.0;

//-- ArrayLists are similar to Python lists in that they are dynamic, you can "add" and "delete" elements, unlike from an array
ArrayList<Float> ptsX = new ArrayList<Float>();
ArrayList<Float> ptsY = new ArrayList<Float>();

int indx=0;

void setup() {
  size(800,800);
  background(0);

  thp = width*0.1;//0.25;//0.1;
  thm = height*0.25;//0.8;//0.25;
  drawBranch( width*0.5, height*0.9, 320, PI/2, 3 );
 
}

void drawBranch( float x, float y, float len, float theta, float stwt ) {
  stroke(0);
  strokeWeight(stwt);
  
  float x2 = x+len*cos(theta);
  float y2 = y-len*sin(theta);

  ptsX.add(x); ptsX.add(x2);
  ptsY.add(y); ptsY.add(y2);
  
  strokeWeight(stwt);
  stroke(255,50);
  line(x,y,x2,y2);
  
  if( len>5 ) {
    drawBranch( x2, y2, len*0.6, theta+thp, stwt*0.9);
    drawBranch( x2, y2, len*0.6, theta-thm, stwt*0.9);
    // drawBranch( x2, y2, len*0.6, theta-2*thm, stwt*0.9);
  } else {
    // ellipse( x2, y2, 5, 5 );  
  }
}

void draw() {

  stroke(255);
  if(indx<ptsX.size()) {
    line(ptsX.get(indx),ptsY.get(indx),ptsX.get(indx+1),ptsY.get(indx+1));
    indx += 2;
  }
}
