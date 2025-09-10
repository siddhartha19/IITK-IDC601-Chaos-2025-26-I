void makeinset(){
  if (showInset) {
    //-- Inset (theta1, theta2) phase plot
    inset.beginDraw();
    inset.background(0);
    inset.stroke(255);
    inset.noFill();
    inset.rect(0, 0, inset.width-1, inset.height-1);
    
    //-- Loop over trajectories
    for (Trajectory t : trajectories) {
      inset.stroke(t.col);
      inset.noFill();
      for (int i = 1; i < t.angleHistory.size(); i++) {
        PVector a1 = t.angleHistory.get(i);
        float x1 = map(a1.x, 0, TWO_PI, 0, inset.width);
        float y1 = map(a1.y, 0, TWO_PI, inset.height, 0);
        strokeWeight(2);
        inset.fill(t.col);
        inset.ellipse(x1,y1,4,4);
      }
    }
    inset.endDraw();
  
    //-- Place inset in bottom-right corner of main canvas
    hint(DISABLE_DEPTH_TEST);  //-- Draw 2D overlay on top
    pushMatrix();
    //-- Reset 3D camera and transformations
    camera(); ortho();        
    image(inset, width - inset.width - 20, height - inset.height - 20);
    popMatrix();
    hint(ENABLE_DEPTH_TEST);
  }
}
