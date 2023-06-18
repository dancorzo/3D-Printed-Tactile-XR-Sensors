
/*

This processing code lists available cameras 

Find number of desided camera to use in the AR matrix visualization code

*/

import processing.video.*;

void setup() {
  // Get the list of available cameras
  String[] cameras = Capture.list();

  // Check if any camera is available
  if (cameras == null || cameras.length == 0) {
    println("No cameras found.");
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + ": " + cameras[i]);
    }
  }
}
