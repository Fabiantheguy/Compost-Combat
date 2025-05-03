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
