/*
-----------------------------------------------------------
              Nonlinear Dynamics and Chaos
               Fractal Tree Visualization
    by Siddhartha Mukherjee, IIT Kanpur, 6 Nov 2025
-----------------------------------------------------------
                    
  Move the mouse around to change parameters for the fractal tree. 
*/

float thp = 0.0, thm = 0.0;
float time = 0;

int cindx = 0;
int iter = 0;
int saveIndx = 0;

color [] cols = {#003049, #d62828, #f77f00, #fcbf49, #eae2b7};
color bgcol = #001219;

void setup() {
  size(800,800);
  background(bgcol);
}

void drawBranch( float x, float y, float len, float theta, float stwt, int cindx, int gen ) {
  
  float x2 = x+len*cos(theta);
  float y2 = y-len*sin(theta);
  
  stroke(cols[cindx]);
  strokeWeight(stwt);
  
  //-- By using a "generation" number for each recursive branch call, I can draw only a particular generation, or use it as a lower/upper cutoff
  if( gen>=0) {
   line(x,y,x2,y2);
   //strokeWeight(2); point(x,y); point(x2,y2); //-- To visualize only the set of points
  }
  
  if( len>5 ) {
    drawBranch( x2, y2, len*0.7, theta+thp, stwt*0.9, (cindx+gen)%cols.length, gen+1 );
    drawBranch( x2, y2, len*0.7, theta-thm, stwt*0.9, (cindx+2*gen)%cols.length, gen+1 );
  } else {
    ellipse( x2, y2, 5, 5 );  
  }
}

void draw() {
   noStroke();
   //-- Change the alpha value to something smaller, to add trails
   fill(bgcol,200);
   rect(0,0,width,height);
   
   //-- Uncomment the thp, thm below to set the angles of the branches with mouse position
   thp = mouseX*PI/width;
   thm = thp;
   //thm = mouseY*PI/height;
   float len = 100 + mouseY*200/height;
   
   //-- Uncomment the incremental version to automate varying angles
   //thp = (width*0.5 + 450*cos(time))*TWO_PI/width;
   //thm = (height*0.5 + 450*sin(time))*TWO_PI/height;
   
   drawBranch( width*0.5, height*0.8, len, PI/2, 4, 0, 0);
   
   //-- Uncomment below to save frames for movie
   
   /* Note that we are incrementing time, which is acting as an angle by 0.002
      So the total number of frames that will complete the roation of TWO_PI is TWO_PI/0.002, which is 3140
      That's a lot of frames, so for a 30 fps movie, we can save every 10th frame, to make a perfect loop of about 10 seconds
      You can then stitch this movie using the MovieMaker option in the Tools menu, or use ffmpeg or such, to stitch the frames */
   
   if( (iter%10==0)&&(saveIndx<314) ) {
     //save("FractalTree-" + nf(saveIndx,3) + ".png");     
     //saveIndx++;          
   }
   
   time += 0.002;
   iter++;
}
