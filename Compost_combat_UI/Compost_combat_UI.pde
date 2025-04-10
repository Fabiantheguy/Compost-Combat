  //IMPORTING SOUND LIBRARY
import processing.sound.*;

/* settings for GD 205 Game Compost Combat
 --ELEMENTS NEEDED:
 SAVE GAME
 EXIT GAME
 VOLUME CONTROL (Sound slider) 
 MAP
 */

//Scene Variables 
Sound s;
float amp = map(mouseY,0,height,0.0,1.0);
String screen = "game";
int screenWidth=2000, screenHeight=2000, radius = 30;
float x=800;
PImage cog;
//Instantiate Settings Class
Settings settings= new Settings (screenWidth, screenHeight, 100);

void setup() {
  size(2000, 2000);
  fullScreen();
  
  //import Settings Variables
  cog = loadImage("cog.png");
  s= new Sound (this);
}

void draw() {
  background (settings.bgColor);
  switch (screen) {
  case "game":
 //THIS CAN BE SWAPPED OUT WITH GAME SCREEN 
    settings.exampleGameScreen();
    break;
  case "settings":
//IMPORTING SETTINGS TAB
     s.volume(amp);
     settings.openTab();
     break;
  case "map":
    settings.mapScreen();
  case "save":
    settings.saveScreen();
    break;
  }
     settings.update();
     
}
