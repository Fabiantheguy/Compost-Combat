import processing.sound.*;
import java.awt.Rectangle;
Ground grass;
Sun sun;
Tree tree;
Vine[] v;

// sETTING lEVEL;
//boolean Level2= true;
Platform[] platforms; //adding platform class

// Adding Vines Class
Vines[] vines;
PVector vinesPOS = new PVector (1900, -400);//CHANGE THESE VARIABLES TO KEEP COLLISIONS 
float length = 150; 

void settings() {
  fullScreen();
}

void setup() {
platformSetup ();
startScreenSetup();  
appleSetup();  // Initialize the Apple (enemy) and platform setup
playerSetup();
playSetup();
loadSaveData();
}


void draw() {
  background(50,255,50);

  
  if (screen == "game") {
    
    
  pushMatrix();
  cameraDraw();
  grassDraw();
  sunDraw();
  treeDraw();
  playerDraw();
  appleDraw();
  platformDraw();
  popMatrix();
  }
   
  menuDraw();
  //if (Level2) {

    //for (int i =0; i<vines.length; i ++ ) {
    //  vines[i].run();
    //}
  //}

}
void platformSetup (){
   // SETTING UP LEVEL 2 PLATFORMS & VINES
  //if (Level2) {
  platforms = new Platform [5]; // the amount of platforms we need in the scene (# CAN BE ALTERED)
  platforms[0] = new Platform(400, 600, 440, 20);
  platforms[1] = new Platform(600, 400, 100, 20);
  platforms[2] = new Platform(800, 350, 100, 20);
  platforms[3] = new Platform(1000, 300, 100, 20);
  platforms[4] = new Platform(1200, 250, 100, 20);
  
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
