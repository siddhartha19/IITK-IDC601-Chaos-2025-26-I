/*================================================================================================

                            Nonlinear Dynamics and Chaos
                          Fractals: Julia Set Visualization
                  by Siddhartha Mukherjee, IIT Kanpur, 6 Nov 2025

   This sketch visualizes Julia sets for different complex parameters 'c', selectable 
   via numeric keys. You can navigate the complex plane and zoom in/out to explore the 
   intricate structure of each set.

   ────────────────────────────────────────────────────────────────────────────────
   CONTROLS
   ────────────────────────────────────────────────────────────────────────────────
   [W/S]    : Move up / down in the complex plane
   [A/D]    : Move left / right in the complex plane
   [+/-]    : Zoom in / out (centered on the current view)
   
   [1]      : The constant 'c' is mapped to MouseLocation, move the mouse to explore various sets
   [2–9]      → Select among preset Julia set parameter values (method = 1...8)
              Each corresponds to a different complex constant 'c', producing 
              distinct fractal structures. A small animation loop is made to visualize the neighbourhood of 'c' 

   [.] (period) : Increase animation rate (tincr *= 1.5)
   [/] (slash)  : Decrease animation rate (tincr /= 1.5)

   [Space] : Save a high-resolution image of the current view

   ────────────────────────────────────────────────────────────────────────────────
   NOTES
   ────────────────────────────────────────────────────────────────────────────────
   • Zoom and pan to inspect fine fractal details.
   • High zoom levels may require higher iteration limits for accuracy.
   • When using Method 1 - the MouseLocation is printed on the screen. If you like a particular point in C,
     you can note down these coordinates and plug them into "Method 9" or any other method, to snap to this location.
  
================================================================================================ */

int method = 1;

PShader mandel;
float zoom = 0.75;
float offsetX = -0.0, offsetY = 0.0;

float xv = -0.5251993;
float yv = -0.5251993;
float time = 0.0;
float tincr = 0.001;

float xx, yy, x1, y1;

void setup() {
  size(800, 800, P2D);
  pixelDensity(2);
  mandel = loadShader("mandel.glsl");
}

void draw() {
  
  switch(method) {
    case 1:
      yy = mouseY-height/2;
      xx = mouseX-width/2;
      break;
      
    case 2:
      x1 = 301;
      y1 = 505;
      x1 -= width/2; y1 -= height/2;
      xx = x1 + sin(time);
      yy = y1 + sin(2 + time);
      break;
      
    case 3:
      x1 = 301;
      y1 = 505;
      x1 -= width/2; y1 -= height/2;
      xx = x1 + sin(time);
      yy = y1;
      break;
      
    case 4:
      x1 = 394;
      y1 = 556;
      x1 -= width/2; y1 -= height/2;
      xx = x1 + 2.0*sin(time);
      yy = y1 + cos(time);;
      break;
      
    case 5:
      x1 = 290;
      y1 = 500;
      x1 -= width/2; y1 -= height/2;
      xx = x1 + 2*sin(time);
      yy = y1 + 3*cos(time);;
      break;
      
    case 6:
      x1 = 360;
      y1 = 530;
      x1 -= width/2; y1 -= height/2;
      xx = x1 + 2*sin(time);
      yy = y1 + 3*cos(time);;
      break;
      
    case 7:
      x1 = 354;
      y1 = 237;
      x1 -= width/2; y1 -= height/2;
      xx = x1 + 2*sin(time);
      yy = y1 + 3*cos(time);;
      break;
      
    case 8: 
      //x1 = 315;
      //y1 = 285;
      
      x1 = 265;
      y1 = 331;
      
      x1 -= width/2; y1 -= height/2;
      xx = x1 + 2.0*sin(time);
      yy = y1 + 2.0*cos(time*1.5  );
      break;
      
    case 9: 
      x1 = 315;
      y1 = 285;
      x1 -= width/2; y1 -= height/2;
      xx = x1 + 4*sin(time);
      yy = y1 + 3*cos(time);;
      break;
      
  }
  
  float th = atan2( yy, xx );
  float rr = map(pow(xx*xx + yy*yy,0.5), 0, width/2, 0.0, 2);
  xv = rr*cos(th);
  yv = rr*sin(th);
  
  mandel.set("uResolution", float(width), float(height));
  mandel.set("uZoom", zoom);
  mandel.set("uOffset", offsetX, offsetY);
  mandel.set("uTime", millis() * 0.01);
  mandel.set("uxv", xv);
  mandel.set("uyv", yv);
  shader(mandel);
  rect(0, 0, width, height);
  
  println(mouseX,mouseY);
  
  time += tincr;
}

void keyPressed() {
  if (key == 's') offsetY -= 0.05/zoom;
  if (key == 'w') offsetY += 0.05/zoom;
  if (key == 'a') offsetX -= 0.05/zoom;
  if (key == 'd') offsetX += 0.05/zoom;
  if (key == '=') zoom *= 1.2;
  if (key == '-') zoom /= 1.2;
  if (key == '.') tincr *= 1.5;
  if (key == '/') tincr /= 1.5;
  
  if (key == '1') method = 1;
  if (key == '2') method = 2;
  if (key == '3') method = 3;
  if (key == '4') method = 4;
  if (key == '5') method = 5;
  if (key == '6') method = 6;
  if (key == '7') method = 7;
  if (key == '8') method = 8;
  if (key == '9') method = 9;
  if (key == ' ') saveHighRes();
}

// Function to save with timestamp
void saveHighRes() {
  String timestamp = nf(year(),4) + nf(month(),2) + nf(day(),2) + "_" +
                     nf(hour(),2) + nf(minute(),2) + nf(second(),2) +
                     nf(millis(),3); 
  String filename = "Julia_" + timestamp + ".png";
  saveFrame(filename);
  println("Saved: " + filename);
}
