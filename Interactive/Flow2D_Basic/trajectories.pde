//-- Creates "particles" that will surf on our flow fields
class Particle {
  PVector pos;
  color col;
  boolean alive = true;

  Particle(float x, float y, color c) {
    pos = new PVector(x, y);
    col = c;
  }

  void update() {
    if (!alive) return;
    //-- Store previous position to draw the segment
    PVector prev = pos.copy();

    if(symplectic) {
      //-- Symplectic -- Conserved energy, Jacobian conserved
      float dtp = dtpart;
      
      if(cfl) {
        float uu = getudot(pos.x, pos.y);
        float vv = getvdot(pos.x, pos.y);
        float umag = pow((uu*uu + vv*vv),0.5);
        dtp = (cfldx/width)/umag;
      }
      
      pos.x += getudot(pos.x, pos.y) * dtp;
      pos.y += getvdot(pos.x, pos.y) * dtp;
    } else {
      //-- Simple Euler explicit integration. You can modify these maybe to higher order schemes.
      float x = prev.x;
      float y = prev.y;
      pos.x += getudot(x,y)*dtpart;
      pos.y += getvdot(x,y)*dtpart;
    }

    //-- Check bounding box: stop if outside 2*range
    if (abs(pos.x) > 2*range || abs(pos.y) > 2*range) {
      alive = false;
      return;
    }

    //-- Draw Trajectory
    stroke(col);
    strokeWeight(2.5);
    line(sx(prev.x), sy(prev.y), sx(pos.x), sy(pos.y));
    //-- Draw point
    noStroke();
    fill(col);
    ellipse(sx(pos.x), sy(pos.y), 4, 4);
  }
}

PVector lastDragged = null;

void mouseDragged() {
  if(dragged) {
    float x = map(mouseX, 0, width, -range, range);
    float y = map(height - mouseY, 0, height, -range, range);
    PVector now = new PVector(x, y);
    
    if (lastDragged == null || PVector.dist(now, lastDragged) > 0.1) { // threshold in system units
      particles.add(new Particle(x, y, cols[int(random(cols.length))]));
      lastDragged = now.copy();
    }
  }
}
