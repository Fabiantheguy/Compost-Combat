import processing.sound.*;
import java.awt.Rectangle;
Ground grass;
Sun sun;
Tree tree;
Vine[] v;
// sETTING lEVEL;
//boolean Level2= true;

// Adding Platform Class as an array to add multiple to scene
color yellow = #F8FF31,green = #0BA048; //SETS COLORS
Platform[] p;
float platformSize = 150; // SETS HOW WIDE
PVector platformDist = new PVector (100,50);//HOW FAR APART THE PLATFORMS ARE
PVector platformPOS = new PVector (1500,300);//WHERE THE PLATFORMS ARE

// Adding Vines Class
Vines[] vines;
PVector vinesPOS = new PVector (1900, -400);//CHANGE THESE VARIABLES TO KEEP COLLISIONS 
float length = 150; 

void settings() {
  fullScreen();
}

void setup() {
startScreenSetup();  
appleSetup();  // Initialize the Apple (enemy) and platform setup
playerSetup();
playSetup();
loadSaveData();
}


void draw() {
  background(50,255,50);
  println(screen);

  
  if (screen == "game") {
  pushMatrix();
  cameraDraw();
  grassDraw();

  sunDraw();
  treeDraw();
  playDraw();
  appleDraw();
  popMatrix();
  }
  menuDraw();
  //if (Level2) {

    //for (int i =0; i<vines.length; i ++ ) {
    //  vines[i].run();
    //}
  //}

}

void keyPressed() {
  aimKeyPressed();
  movementKeyPressed();
  saveKeyPressed();
}

void keyReleased() {
  aimKeyReleased();
  movementKeyReleased();
}

void mousePressed(){
   mouseReleased();
}
