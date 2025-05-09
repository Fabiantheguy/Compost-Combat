import processing.sound.*;
import java.awt.Rectangle;
Ground grass;
Sun sun;
Tree tree;
Vine[] v;
Platform[] platforms; //adding platform class


// Adding Swinging Vines Class
Vines[] vines;
PVector vinesPOS = new PVector (1900, -400);//CHANGE THESE VARIABLES TO KEEP COLLISIONS 
float vlength = 150; 

void settings() {
  fullScreen();
}

void setup() {
startScreenSetup();  
appleSetup();  // Initialize the Apple (enemy) and platform setup
BananaSetup();
playerSetup();
playSetup();
loadSaveData();
lvlSetup();
}


void draw() {
  background(50,255,50);

  
  if (screen == "game") {
  pushMatrix();
  
  soundSetup();
  cameraDraw();
  grassDraw();
  lvlChanger();//CHANGES THE LEVELS THROUGHOUT GAMEPLAY
  sunDraw();
  treeDraw();
  playerDraw();
  appleDraw();
  BananaDraw();
  popMatrix();
  }
  menuDraw();
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
   
   if (screen.equals("map")) {
     //Allow Node's to be click on, only on map screen
    for (LevelNode node : nodes) 
      node.checkClick();
  }
}
