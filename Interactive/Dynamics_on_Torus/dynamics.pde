// ------- Define your dynamics here ------------
PVector dynamics(float theta1, float theta2) {
  
  //return new PVector(a, b); //-- Constant velocities
  
  return new PVector( theta1*(1-theta1), b); //-- Logistic in theta1
  
  ////-- General:
   //float f1 = a + sin(theta2-theta1);
   //float f2 = b + sin(theta1-theta2);
   //return new PVector( f1,f2 ); //-- Return the function evaluation as a PVector
}
// ----------------------------------------------
