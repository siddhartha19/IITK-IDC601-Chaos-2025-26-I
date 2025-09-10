/**
Simulation Parameters
---------------------
Global constants and tunable parameters controlling the flow field
visualization and trajectory evolution.

Linear system coefficients:
  [ a11  a12 ]
  [ a21  a22 ]

These define the vector field:
  dudt = a11 * x + a12 * y
  dvdt = a21 * x + a22 * y

Parameters:
  range   : Half-width of the domain (plots cover [-range, +range])
  dt      : Step size for background vector field generation (for visualization only)
  step    : Grid spacing (in pixels) between drawn vectors 
  dtpart  : Time step for particle integration (smaller = smoother)
  maglim  : Maximum allowed arrow length for vectors (for clarity)
  
Integration options:
  symplectic : If true, use symplectic Euler scheme (better for Hamiltonian-like flows).
               If false, use standard Euler integration.
  cfl        : If true, enforce a CFL-like condition for adaptive time-stepping
               (prevents particles from skipping across vectors).
  cfldx      : Spatial resolution parameter used in CFL condition. 
               Smaller cfldx → smaller adaptive timestep for stability.
               
Try:
  * Change the linear flow field to get a Stable/Unstable Node, Spiral, Center and Saddle
  * Change the eigenvalues in the above to find fast and slow directions
  * Find cases with degenerate fixed points
  * Systems with Homoclinic and Heteroclinic orbits
  * Glycolysis example with stable fixed point and limit cycle (revisit the ``trapping region'')
  * Van der Pol Oscillator
*/
