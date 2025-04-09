/* settings for GD 205 Game Compost Combat
 --ELEMENTS NEEDED:
 SAVE GAME
 EXIT GAME
 VOLUME CONTROL
 */
Settings settings= new Settings (2000, 2000, 100);
String screen = "game";
int screenWidth=2000, screenHeight=2000, radius = 30;

color bgColor = (#AAF796), gray= (#7D867B), red= (#FF0A2B),
  black = (#000000), white= (#FFFFFF);

void setup() {
  background(bgColor);
  size(2000, 2000);
  fullScreen();
}

void draw() {
  switch (screen) {
  case "game":
    textSize(72);
    text("THIS IS A PLACEHOLDER FOR \n THE GAME SCREEN",
      screenWidth/4, screenHeight/4);
    fill(gray);
    break;
  case "settings":
    //settings class
     settings.openTab();
    break;
  }
     settings.update();
}

class Settings {
  boolean settingsClicked=false;
  PVector pos;
  float size;
  
  Settings (float x, float y, float s) {
    pos= new PVector (x, y);
    size= s;
  }

  void update() {
    //Settings Button
    circle(screenWidth-220, 90, radius);
    textSize(30);
    text("Settings", screenWidth-200, 100);
  }
  void openTab(){
    //If Button is Clicked, Open Settings
    float rectX,rectY,rectX2,rectY2;
    rectX =screenWidth -220;
    rectX2 = screenWidth-100;
    rectY = 100;
    boolean onSettings = mouseX > rectX ||
      mouseX <  rectX2 &&
      mouseY > 50 || mouseY<rectY;
    boolean onX = mouseX > screenWidth -220 ||
      mouseX < screenWidth-100 &&
      mouseY > 50 || mouseY<100 && screen == "settings";
    if (onSettings && mousePressed) {
      settingsClicked=true;
      if (settingsClicked) {
        screen = "settings";
        //Settings Screen
        fill(black);
        rect(0, 0, screenWidth, screenHeight);
        textSize(72);
        stroke(white);
        text("THIS IS A PLACEHOLDER FOR \n THE SETTINGS SCREEN",
          screenWidth/4, screenHeight/4);
        stroke(black);
        fill(red);
        circle(screenWidth-220, 90, radius);
      }
      if (onX && mousePressed) {
        screen = "game";
      }
    }
  }
}
