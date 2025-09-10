/*--------------------------------------------
       Dynamics on a Torus
 Siddhartha Mukherjee, IIT Kanpur, 7 Sep 2025
 ---------------------------------------------
 This sketch visualizes trajectories of a simple dynamical system 
 evolving on a 2D torus. Both variables must be 2pi periodic.
 The torus is embedded in 3D space and the system evolves according to:

     dtheta1/dt = a (or some other function)
     dtheta2/dt = b (or some other function)
 
 For a more general system, modify the "dynamics() function.
 
 Features:
   - Euler integration is used to advance (θ1, θ2) in time.
   - The system's state (theta1, theta2) is mapped onto the torus surface.
   - Each trajectory leaves a trail showing its evolution, for upto Nt points of history (for memory efficiency - you     can increase or decrease these as needed).
   - A toggle-able inset (2D phase plot) shows trajectories in flat (theta1, theta2) space. 
 
 Controls:
   - Mouse click: Start a new trajectory with (theta1, theta2) set by mouse position.
   - 'w' key: Toggle torus (on/off).
   - 'i' key: Toggle inset phase-space plot (on/off) --- NOTE: Best to view the inset briefly, due to large memory        overheads of rendering 2D graphics on top of 3D graphics!
   - 'c' key: Clear all trajectories.
   - 'r' key: Toggle rotation (on/off).
   - '+/-': Speed up/Slow down rotation.
 
 Parameters:
   - a, b: Constant angular velocities.
   - dt: Integration time step.
   - Nt: Maximum trail length.

 Dynamics:
   - a, b: Coprime integers will produce a (a,b) Torus 
   - a, 1: Spirals
   - a, b: Either or both irrational - Dense trajectories on Torus - Quasiperiodicity
   - a + sin(theta2-theta1), b + 0.2*sin(theta1-theta2): Synchronization
*/
