/*
-----------------------------------------------------------
              Nonlinear Dynamics and Chaos
             Mandelbrot Set Visualization
    by Siddhartha Mukherjee, IIT Kanpur, 6 Nov 2025
-----------------------------------------------------------
                    
  Interactive Processing sketch to visualize the Mandelbrot set, using Shaders (GLSL).
  
  Key Controls:
   [a,s,w,d]   Navigation
   [+/-]       Zoom in and out
*/

PShader mandel;
float zoom = 0.25;
float offsetX = -0.5, offsetY = 0.0;

void setup() {
  size(800, 800, P2D);
  mandel = loadShader("mandel.glsl");
}

void draw() {
  mandel.set("uResolution", float(width), float(height));
  mandel.set("uZoom", zoom);
  mandel.set("uOffset", offsetX, offsetY);
  mandel.set("uTime", millis() * 0.01);
  shader(mandel);
  rect(0, 0, width, height);
}

void keyPressed() {
  if (key == 's') offsetY -= 0.05/zoom;
  if (key == 'w') offsetY += 0.05/zoom;
  if (key == 'a') offsetX -= 0.05/zoom;
  if (key == 'd') offsetX += 0.05/zoom;
  if (key == '=') zoom *= 1.2;
  if (key == '-') zoom /= 1.2;
}
