
//-- Creates "particles" that will surf on our flow fields
class Particle {
  PVector pos;
  color col;
  boolean alive = true;
  
  PVector[] trail;   // circular buffer
  int head = 0;      // current write index
  int size = 0;      // number of valid points stored

  Particle(float x, float y, color c) {
    pos = new PVector(x, y);
    col = c;
    trail = new PVector[Ntot];
    trail[0] = pos.copy();
    size = 1;
  }

  void update() {
    if (!alive) return;

    // Save current position before moving
    PVector prev = pos.copy();
    float dtp = dtpart;
    if(cfl) {
      float uu = getudot(pos.x, pos.y);
      float vv = getvdot(pos.x, pos.y);
      float umag = pow((uu*uu + vv*vv),0.5);
      dtp = (cfldx/width)/umag;
    }

    if(symplectic) {
      pos.x += getudot(pos.x, pos.y) * dtp;
      pos.y += getvdot(pos.x, pos.y) * dtp;
    } else {
      float x = prev.x;
      float y = prev.y;
      pos.x += getudot(x,y)*dtp;
      pos.y += getvdot(x,y)*dtp;
    }

    if (abs(pos.x) > (xmax-xmin) || abs(pos.y) > (ymax-ymin)) {
      alive = false;
      return;
    }

    // Store new position in circular buffer
    head = (head + 1) % Ntot;
    trail[head] = pos.copy();
    if (size < Ntot) size++;

    // Draw trail
    stroke(col);
    strokeWeight(2);
    noFill();
    for (int i = 1; i < size; i++) {
      int idx1 = (head - i + Ntot) % Ntot;
      int idx2 = (head - i + 1 + Ntot) % Ntot;
      if (trail[idx1] != null && trail[idx2] != null) {
        line(sx(trail[idx1].x), sy(trail[idx1].y),
             sx(trail[idx2].x), sy(trail[idx2].y));
      }
    }

    // Draw particle head
    noStroke();
    fill(col);
    ellipse(sx(pos.x), sy(pos.y), 4, 4);
  }
  
  void render() {
  stroke(col);
  strokeWeight(2);
  noFill();

  if (size > 1) {
    // find the oldest index
    int startIdx;
    if (size == Ntot) {
      startIdx = (head + 1) % Ntot;  // buffer full: oldest is one after head
    } else {
      startIdx = 0;                  // not full yet: oldest is at index 0
    }

    // draw line segments in order
    for (int k = 1; k < size; k++) {
      int i0 = (startIdx + k - 1) % Ntot;
      int i1 = (startIdx + k) % Ntot;
      PVector p0 = trail[i0];
      PVector p1 = trail[i1];
      if (p0 != null && p1 != null) {
        line(sx(p0.x), sy(p0.y), sx(p1.x), sy(p1.y));
      }
    }
  }

  // Draw head point
  noStroke();
  fill(col);
  ellipse(sx(pos.x), sy(pos.y), 4, 4);
  
  if(showCoord){
    //-- Draw current coordinates next to the head
    fill(col);
    textAlign(LEFT, CENTER);
    textSize(15);
    String coords = "(" + nf(pos.x,1,2) + ", " + nf(pos.y,1,2) + ")";
    text(coords, sx(pos.x) + 6, sy(pos.y));
  }
  
  }
}
