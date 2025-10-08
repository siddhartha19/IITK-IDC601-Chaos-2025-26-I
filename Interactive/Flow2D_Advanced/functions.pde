PGraphics nullclineLayer;
float cachedRange = -1;  // store last used range

void keyPressed() {
  
  if (key == 'c' || key == 'C') {
    background(bg);
    showVecField();
    particles.clear();
    drawBoundingBox();
  }
  
  if (key == '-') {
    xmin *= 1.2;      // zoom out
    xmax *= 1.2;
    ymin *= 1.2;
    ymax *= 1.2;
  } else if (key == '+') {
    xmin /= 1.2;      // zoom out
    xmax /= 1.2;
    ymin /= 1.2;
    ymax /= 1.2;
  }
  
  if (key == 'v' || key == 'V') showField = !showField;
  if (key == 'g' || key == 'G') showGrid = !showGrid;
  if (key == 'n' || key == 'N') showNullclines = !showNullclines;
  if (key == 'e' || key == 'E') showEquilibria = !showEquilibria;
  if (key == 'p' || key == 'P') showCoord = !showCoord;
  if (key == 's' || key == 'S') saveHighRes();
  
}

void updateNullclines(float range, float resval) {
  if (nullclineLayer == null || cachedRange != range) {
    cachedRange = range;
    nullclineLayer = createGraphics(width, height);
    nullclineLayer.beginDraw();
    nullclineLayer.clear();
    nullclineLayer.strokeWeight(1);

    float res = resval;
    float dx = (xmax-xmin) / res;
    float dy = (ymax-ymin) / res;

    for (int i=0; i<res; i++) {
      for (int j=0; j<res; j++) {
        float x0 = xmin + i*dx;
        float y0 = ymin + j*dy;
        float x1 = x0+dx;
        float y1 = y0+dy;

        float f00 = getudot(x0,y0);
        float f10 = getudot(x1,y0);
        float f01 = getudot(x0,y1);
        float f11 = getudot(x1,y1);

        if ((f00*f10<0) || (f01*f11<0) || (f00*f01<0) || (f10*f11<0)) {
          nullclineLayer.stroke(#00afb9); 
          nullclineLayer.strokeWeight(2);
          nullclineLayer.point(sx((x0+x1)/2), sy((y0+y1)/2));
        }

        float g00 = getvdot(x0,y0);
        float g10 = getvdot(x1,y0);
        float g01 = getvdot(x0,y1);
        float g11 = getvdot(x1,y1);

        if ((g00*g10<0) || (g01*g11<0) || (g00*g01<0) || (g10*g11<0)) {
          nullclineLayer.stroke(#ff0054); 
          nullclineLayer.strokeWeight(2);
          nullclineLayer.point(sx((x0+x1)/2), sy((y0+y1)/2));
        }
      }
    }
    
    // --- Legend settings ---
    nullclineLayer.textAlign(LEFT, TOP);
    nullclineLayer.textSize(18);   // increase text size
    int margin = 15;
    int legendW = 100;
    int legendH = 50;
    int xLegend = width - legendW - margin;
    int yLegend = margin;

    // --- Draw background rectangle (with some transparency) ---
    nullclineLayer.noStroke();
    nullclineLayer.fill(0, 180); // black with alpha
    nullclineLayer.rect(xLegend, yLegend, legendW, legendH, 8);

    // --- Draw legend entries ---
    int lineX1 = xLegend + 10;
    int lineX2 = xLegend + 30;

    nullclineLayer.stroke(#00afb9);
    nullclineLayer.strokeWeight(3);
    nullclineLayer.line(lineX1, yLegend + 15, lineX2, yLegend + 15);
    nullclineLayer.noStroke();
    nullclineLayer.fill(255);
    nullclineLayer.text("ẋ = 0", lineX2 + 5, yLegend + 8);

    nullclineLayer.stroke(#ff0054);
    nullclineLayer.strokeWeight(3);
    nullclineLayer.line(lineX1, yLegend + 35, lineX2, yLegend + 35);
    nullclineLayer.noStroke();
    nullclineLayer.fill(255);
    nullclineLayer.text("ẏ = 0", lineX2 + 5, yLegend + 28);

    nullclineLayer.endDraw();
  }
}

// Function to save with timestamp
void saveHighRes() {
  String timestamp = nf(year(),4) + nf(month(),2) + nf(day(),2) + "_" +
                     nf(hour(),2) + nf(minute(),2) + nf(second(),2) +
                     nf(millis(),3); 
  String filename = "Flow_" + timestamp + ".png";
  saveFrame(filename);
  println("Saved: " + filename);
}
