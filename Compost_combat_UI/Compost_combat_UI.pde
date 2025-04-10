/* settings for GD 205 Game Compost Combat
 --ELEMENTS NEEDED:
 SAVE GAME
 EXIT GAME
 VOLUME CONTROL (Sound slider) 
 MAP
 */

//Scene Variables 
String screen = "game";
int screenWidth=2000, screenHeight=2000, radius = 30;
float x=800;
PImage cog;
//Instantiate Settings Class
Settings settings= new Settings (screenWidth, screenHeight, 100);

void setup() {
  size(2000, 2000);
  fullScreen();
  
  //import cog sprite image 
  cog = loadImage("cog.png");
}

void draw() {
  background (settings.bgColor);
  switch (screen) {
  case "game":
 //THIS CAN BE SWAPPED OUT WITH GAME SCREEN 
    settings.exampleGameScreen();
    break;
  case "settings":
//IMPORTIMG SETTINGS TAB
     settings.openTab();
     break;
  case "save":
    settings.saveScreen();
    break;
  }
     settings.update();
     
}
