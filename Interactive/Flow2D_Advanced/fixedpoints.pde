ArrayList<Equilibrium> equilibria = new ArrayList<>();

class Equilibrium {
  PVector pos;
  boolean stable;
  Equilibrium(float x, float y, boolean stable) {
    this.pos = new PVector(x,y);
    this.stable = stable;
  }
}

void updateEquilibria(float range) {
  equilibria.clear();
  int res = 2000;  // resolution of search
  float dx = (xmax-xmin)/res;
  float dy = (ymax-ymin)/res;

  ArrayList<Equilibrium> rawEqs = new ArrayList<>();

  // brute-force search for approximate equilibria
  for (int i=0; i<res; i++) {
    for (int j=0; j<res; j++) {
      float x = xmin + i*dx;
      float y = ymin + j*dy;
      float u = getudot(x,y);
      float v = getvdot(x,y);
      if (abs(u) < 1e-2 && abs(v) < 1e-2) {
        boolean stab = isStable(x,y);
        rawEqs.add(new Equilibrium(x,y, stab));
      }
    }
  }

  // filter duplicates: keep only one representative per cluster
  float tol = 0.5; // distance threshold for "closeby" equilibria
  for (Equilibrium cand : rawEqs) {
    boolean merged = false;
    for (int k=0; k<equilibria.size(); k++) {
      Equilibrium existing = equilibria.get(k);
      if (PVector.dist(cand.pos, existing.pos) < tol) {
        // pick the one with smaller (u^2+v^2), i.e. closer to exact eq
        float eu1 = sq(getudot(existing.pos.x, existing.pos.y)) 
                  + sq(getvdot(existing.pos.x, existing.pos.y));
        float eu2 = sq(getudot(cand.pos.x, cand.pos.y)) 
                  + sq(getvdot(cand.pos.x, cand.pos.y));
        if (eu2 < eu1) {
          equilibria.set(k, cand);  // replace with better candidate
        }
        merged = true;
        break;
      }
    }
    if (!merged) {
      equilibria.add(cand);
    }
  }
}

boolean isStable(float x, float y) {
  float eps = 1e-3;
  float du_dx = (getudot(x+eps,y)-getudot(x-eps,y))/(2*eps);
  float du_dy = (getudot(x,y+eps)-getudot(x,y-eps))/(2*eps);
  float dv_dx = (getvdot(x+eps,y)-getvdot(x-eps,y))/(2*eps);
  float dv_dy = (getvdot(x,y+eps)-getvdot(x,y-eps))/(2*eps);

  // Eigenvalues of Jacobian
  float tr = du_dx + dv_dy;
  float det = du_dx*dv_dy - du_dy*dv_dx;
  float disc = tr*tr - 4*det;

  if (disc >= 0) {
    float l1 = (tr + sqrt(disc))/2.0;
    float l2 = (tr - sqrt(disc))/2.0;
    return (l1 < 0 && l2 < 0);  // stable if both negative
  } else {
    return (tr < 0);  // stable spiral if trace < 0
  }
}

void showfps() {
  if (showEquilibria) {
    for (Equilibrium e : equilibria) {
      if (e.stable) {
        fill(#219ebc); 
        noStroke();
        ellipse(sx(e.pos.x), sy(e.pos.y), 10, 10);
      } else {
        noFill();
        stroke(#e63946);
        strokeWeight(2);
        ellipse(sx(e.pos.x), sy(e.pos.y), 10, 10);
      }
    }
  }
}

void maybeUpdateEquilibria(float range) {
  if (range != cachedRange) {
    updateEquilibria(range);
    cachedRange = range;
  }
}
