/*------------------------------------------------------------------------------------------
          Visualizing the transformation z -> z^n
         Siddhartha Mukherjee, IIT Kanpur, Aug 2025

Visualizes the transformation of the complex plane under z -> z^n
The origin, (0,0) coincides with the center of the screen. 
Two lines have been shown in red to track their final forms distinctly.
"Evolution" is simulated by uniformly varying n from 1 to its chosen value in "nsteps". 
      
Interactions and Parameters:
    - Click : Restart evolution
    - n : Change n below for z -> z^n
    - nsteps : Number of steps in the evolution of 1 to "n"
    - xrange, yrange : The complex plane is shown from (-xrange,xrange) in x, similarly in y
    
-------------------------------------------------------------------------------------------*/

float n = -2.0; //-- Transformation is z^n

float xrange = 5;
float yrange = 5;

int iter = 0;
float nsteps = 160;

int step = 25;        //-- Spacing between grid lines
int N    = 200;       //-- Number of points per line
ArrayList<Line> gridLines = new ArrayList<Line>();
ArrayList<Line> gridLinesFinal = new ArrayList<Line>();

color c1 = #03045e;
color c2 = #ade8f4;
color c3 = #d9ed92;
color c4 = #ff6700;
color bg = #0a0908;

float ntemp;

void setup() {
  size(800,800);
  smooth();
  pixelDensity(displayDensity());
  background(bg);

  createGridLines();
}

void draw() {
  noStroke();
  fill(bg,175);
  rect(0,0,width,height);
  if(iter<=nsteps) {
    ntemp = 1.0 + (n-1.0)*iter/nsteps;
    transform(ntemp);
  }
  drawGridLines();
  //drawVect();
  label();
  iter++;
}

void label() {
  noStroke();
  fill(bg, 175);
  rect(30,25,120,40);
  stroke(255);
  fill(255);
  String lab = "n = " + nf(ntemp, 1, 2);
  textSize(24);
  text(lab, 50, 50);
}

void createGridLines() {
    int nCols = width / step + 1;
    int nRows = height / step + 1;

  // Vertical lines
    for (int i = 0; i < nCols; i++) {
      float x = i * step;
      float[] xs = new float[N];
      float[] ys = new float[N];
      for (int j = 0; j < N; j++) {
        xs[j] = x;
        ys[j] = map(j, 0, N-1, 0, height);
      }

      Line l = new Line(N, xs, ys);
      float t = map(i, 0, nCols - 1, 0, 1);
      l.col = lerpColor(c1, c2, t);
      if(i==17) l.col = #ff0054;
      gridLines.add(l);
      gridLinesFinal.add(l.copy());
    }


  // Horizontal lines
    for (int j = 0; j < nRows; j++) {
      float y = j * step;
      float[] xs = new float[N];
      float[] ys = new float[N];
      for (int i = 0; i < N; i++) {
        xs[i] = map(i, 0, N-1, 0, width);
        ys[i] = y;
      }

      Line l = new Line(N, xs, ys);
      float t = map(j, 0, nRows - 1, 0, 1);
      l.col = lerpColor(c3, c4, t);
      if(j==10) l.col = #d00000;
      gridLines.add(l);
      gridLinesFinal.add(l.copy());
    }
}

void drawGridLines() {
  for (Line l : gridLinesFinal) {
    l.drawPoints();
  }
}

void drawGridLinesBase() {
  for (Line l : gridLines) {
    l.drawPoints();
  }
}

class Line {
  int N;
  float[] x;
  float[] y;
  color col;

  Line(int np, float[] xvals, float[] yvals) {
    N = np;
    x = xvals;
    y = yvals;
  }
  
  //-- Draw 
  void drawCurve() {
    int N = x.length;

    noFill();
    stroke(col);
    strokeWeight(2);

    beginShape();
    // Start point duplicated for curve continuity
    curveVertex(x[0], y[0]);
    for (int i = 0; i < N; i++) {
    curveVertex(x[i], y[i]);
    }
    // End point duplicated for curve continuity
    curveVertex(x[N - 1], y[N - 1]);
    endShape();
  }

  void drawPoints() {
    
    int N = x.length;

    stroke(col);
    strokeWeight(4);
    
    for (int i = 0; i < N; i++) {
      point(x[i], y[i]);
    }

  }

  Line copy() {
    float[] xCopy = new float[x.length];
    float[] yCopy = new float[y.length];
    arrayCopy(x, xCopy);
    arrayCopy(y, yCopy);
    Line newLine = new Line(N, xCopy, yCopy);
    newLine.col = col;
    return newLine;
  }
}

void transform( float pow ) { 
  for (int j = 0; j < gridLinesFinal.size(); j++) {
    Line l = gridLines.get(j);
    Line lf = gridLinesFinal.get(j);
    for (int i = 0; i < lf.N; i++) {
      float[] pt = complexFunc(l.x[i], l.y[i], pow);
      lf.x[i] = pt[0];
      lf.y[i] = pt[1];
    }
  }
}

void mousePressed() {
  reset();
}

void drawVect() {
    int ypp = int(step*0.75);
    int xpp = int(N*0.4);
    Line lf = gridLinesFinal.get(ypp);
    
    stroke(255);
    strokeWeight(2);
    line( width/2, height/2, lf.x[xpp], lf.y[xpp] );
}

void reset() {
  for (int j = 0; j < gridLines.size(); j++) {
    Line l = gridLines.get(j);
    Line lf = gridLinesFinal.get(j);
    for (int i = 0; i < l.N; i++) {
      lf.x[i] = l.x[i];
      lf.y[i] = l.y[i];
    }
  }
  iter = 0;
}

float[] complexFunc( float xg, float yg, float n ) {
  float x = map(xg, 0, width, -xrange, xrange);
  float y = map(yg, 0, height, -yrange, yrange);

  //-- General power
   float amp = dist(x,y,0,0);
   float ang = atan2(y,x);
   float re = pow(amp,n) * cos( ang*n );
   float im = pow(amp,n) * sin( ang*n );

  return new float[]{ map(re,-xrange,xrange,0,width), map(im,-yrange,yrange,0,height) };
}
