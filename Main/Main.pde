import processing.sound.*;
import java.awt.Rectangle;
Ground grass;
Tree[] tree;
Vine[] v;
Platform[] platforms; //adding platform class
float masterVol = 1.0; // master volume for the game - stored as a float between 0.0 and 1.0


// Adding Vines Class
swingingVines[] vines;
PVector vinesPOS = new PVector (1900, -400);//CHANGE THESE VARIABLES TO KEEP COLLISIONS 
float vlength = 150; 

// for testing purposes, delete later 
int[] konacode = {38, 38, 40, 40, 37, 39, 37, 39, 66, 65};
int konaCurrent = 0;

void settings() {
  fullScreen();
}

void setup() {
soundSetup();
startScreenSetup();  
orangeSetup();
playerSetup();
playSetup();
loadSaveData();
lvlSetup();
environmentSetup();
titleScreenMusic.loop();
}


void draw() {
  if(screen.equals("loading")){
    loadingScreen();
    return;
  }
  
  background(50,205,50);

  
  if (screen == "game") {
  pushMatrix();
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
  playSFX();
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
  
  // cheat code to unlock all levels for testing purposes, delete later
  if(keyCode == konacode[konaCurrent] && screen == "map"){
    if(konaCurrent < konacode.length - 1){
      konaCurrent++;
    } else {
      for (int i=0; i < nodes.size(); i++){
        LevelNode currentNode = nodes.get(i);
        if(currentNode.state == "Locked"){
          currentNode.state = "Unlocked";
        }
      }
    }
  }
  
  // UI testing apparatus
  if(key == '4'){
    screen = "clear";
  }
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
