import processing.sound.*;
import java.awt.Rectangle;
Ground grass;
Tree tree;
Vine[] v;
Platform[] platforms; //adding platform class
float masterVol; // master volume for the game - stored as a float between 0.00 and 1.00

// Adding Swinging Vines Class
Vines[] vines;

float vlength = 150; 

void settings() {
  fullScreen();
}

void setup() {
startScreenSetup();  
orangeSetup();
playerSetup();
playSetup();
loadSaveData();
lvlSetup();
}


void draw() {
  if(screen.equals("loading")){
    loadingScreen();
    return;
  }
  
  background(50,255,50);

  
  if (screen == "game") {
  pushMatrix();
  soundSetup();
  cameraDraw();
  grassDraw();
  lvlChanger();//CHANGES THE LEVELS THROUGHOUT GAMEPLAY
  treeDraw();
  playerDraw();
  appleDraw();
  BananaDraw();
  orangeDraw();
  popMatrix();
  
  
  
    
    
  }
  menuDraw();
}

void keyPressed() {
    if (key == ESC) {
    key = 0; // Prevent default ESC behavior of closing out of the game

    // Toggle between both game and settings screens if ESC key is pressed only in the game screen
    if (screen.equals("game")) {
      cameFromGameScr = true;
      screen = "settings";
    } else if (screen.equals("settings")&& cameFromGameScr) {
      screen = "game";
      cameFromGameScr = false;
    }

    return;
  }
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
