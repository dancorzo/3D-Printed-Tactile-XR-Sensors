/*

This processing code lists available serial ports 

Find number of desided port for the arduino or desired microprocessor to use in the AR matrix visualization code
*/


import processing.serial.*;

void setup() {
  // Print the available serial ports
  listSerialPorts();
}

void listSerialPorts() {
  println("Available serial ports:");
  
  // Get the list of available serial ports
  String[] portList = Serial.list();
  
  // Print each port's name
  for (int i = 0; i < portList.length; i++) {
    println(i + ": " + portList[i]);
  }
}
