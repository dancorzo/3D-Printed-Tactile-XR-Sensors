
/**
This code is used to read pressure information from the 3D printed e-skin devices through serial
and display it as augmented reality on top of a defined marker. 

It utilizes the NyARToolkit for processing and a predefined marker set in the folder
where this sketch is saved. 

(c)2023 
Sourced with Love by Daniel Corzo
*/


import processing.video.*;
import jp.nyatla.nyar4psg.*;
import processing.serial.*;



//Define the capture and multimarker functions
Capture cam;
MultiMarker nya;

//Define variables for ObjLoader
PShape rocket;
PShape CNF;
PShape Hand;
float ry;


// Define size of matrix of boxes for data display
int matrixSize = 6; // Define the size of the matrix (number of boxes per row/column)
int boxSize = 15; // Define the size of each box

// Define variables for Serial communication
Serial myPort;  // Create object from Serial class
String serialStringVal = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"; // Data received from the serial port
float[] valArray = {10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10}; // Define array of values with initial values to avoid empty array

void setup() {
  // Define Settings for Serial Communication
  // printArray(Serial.list()); // Lists available ports
  
  
  String portName = Serial.list()[3]; // Change the index to match your port
  myPort = new Serial(this, portName, 19200);
  
  // Define Settings for Camera communication
  // printArray(Capture.list()); // Lists available cameras
  if (isCameraAvailable()) {
    //size(1280, 720, P3D); // Choose Camera Resolution
    colorMode(RGB, 100); 
    cam = new Capture(this, width, height, Capture.list()[0], 30);//"pipeline:avfvideosrc device-index=1"); // Defines Camera // Capture.list()[0], 30);//
    cam.start();
    
  //define shapes
  rocket = loadShape("../../data/rocket.obj");
  CNF = loadShape("../../data/O-IDTBR.obj");
  Hand = loadShape("hand1.obj");
  //Hand.enableStyle();
  Hand.setFill(color(255, 255, 255)); //white color
  //CNF.setFill(color(97, 42, 163));
    
  } else {
 
  }
  
  size(1280, 720, P3D); // Choose Camera Resolution
  
  println(MultiMarker.VERSION);
  nya = new MultiMarker(this, width, height, "../../data/camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  
  // Define marker Images
  nya.addARMarker("../../data/KAUST-Name.patt", 80); // Defines KAUST Marker
  nya.addARMarker("../../data/square.patt", 80); //Defines Second Marker "i"
  //nya.addARMarker("../../data/patt.hiro", 80); // Defines Third Marker Image "Hiro"
  
}

void draw() {
  
  readSerialData(); // Read data from the serial port
  
  if (cam != null && cam.available() != true) {
    return;
  }
  
  if (cam != null) {
    cam.read();
    nya.detect(cam);
    background(0);
    nya.drawBackground(cam); // Frustumを考慮した背景描画
  } else {
    background(0);
  }
  

//Define what happens when markers are available 
  
  if (nya.isExist(0)) {
    
    nya.beginTransform(0);

    // Set stroke values to numbers read from array received from Serial
    for (int i = 0; i < valArray.length; i++) {
      if (serialStringVal != null) {
        valArray[i] = float(serialStringVal.split(",")[i]);
      }
    }
    
    //Draws Matrix 
    drawBoxMatrix();
    
    //Draw Hand
    lights();
    translate(-25, 0, -150);
    //rotateZ(ry);
    rotateX(PI/2);
    //rotateY(-PI/8);
    scale(13);
    shape(Hand);
    ry += 0.02;
    
    
    nya.endTransform();
  }
  
  if (nya.isExist(1)) {  // If you want to add more funcitonality to marker 1

   nya.beginTransform(1);
    lights();
    translate(0, 0, 50);
    //rotateZ(ry);
    rotateX(PI/2);
    //rotateY(-PI/8);
    scale(13);
    shape(CNF);  //Adds Second Shape
    ry += 0.02;
   nya.endTransform();
  
  }
  
  //if (nya.isExist(2)) {    // If you want to add more funcitonality to marker 2
  //nya.beginTransform(2);
  //nya.endTransform(); 
  //}
  

}

void drawBoxMatrix() {
  translate(0, 0, 180); // Center the matrix in the sketch
  for (int i = 0; i < matrixSize; i++) {
    for (int j = 0; j < matrixSize; j++) {
      float x = (i - matrixSize/2) * boxSize; // Calculate the x position of the box
      float y = (j - matrixSize/2) * boxSize; // Calculate the y position of the box
      float z = 0.2*valArray[i * matrixSize + j];  // values received are 255
      //float z = random(0, 100); //calculate the z position of the box
      float boxHeight = map(z, 0, 50, 0, 1); // 255, 0); // Map the z-coordinate to a color range
   
      color boxColor = lerpColor(color(255, 192, 203), color(128, 0, 128), boxHeight); // Generate a color between pink and purple
      
      
      pushMatrix();
      translate(x, y, z/2); // z/2 levels all boxes at the same height
      fill(boxColor); //colors the boxes according to the color range 
      box(boxSize, boxSize, z);  //valArray[i * matrixSize + j]); // Set the height of the box based on the external input
      popMatrix();
    }
  }
}

void readSerialData() {
  while (myPort.available() > 0) { // Read all available data
    serialStringVal = myPort.readStringUntil('\n');
    if (serialStringVal != null) {
      serialStringVal = serialStringVal.trim();
    // Handle the received data as needed
    println("Received data: " + serialStringVal);
      
    }
  }
}

boolean isCameraAvailable() {
  String[] cameras = Capture.list();
  return cameras.length > 0;
}
