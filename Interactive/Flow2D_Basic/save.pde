// Function to save with timestamp
void saveHighRes() {
  String timestamp = nf(year(),4) + nf(month(),2) + nf(day(),2) + "_" +
                     nf(hour(),2) + nf(minute(),2) + nf(second(),2) +
                     nf(millis(),3); 
  String filename = "Flow_" + timestamp + ".png";
  saveFrame(filename);
  println("Saved: " + filename);
}
