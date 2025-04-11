

/* settings for GD 205 Game Compost Combat
 --ELEMENTS NEEDED:
 SAVE GAME
 EXIT GAME
 VOLUME CONTROL (Sound slider)
 MAP
 */

//Scene Variables
Sound s;
float amp = map(mouseY, 0, height, 0.0, 1.0);
String screen = "start";
int radius = 30;
float x=800;
PImage cog;
color bgColor = (#F5F2F2), gray= (#7D867B),
  circleCol= (#FF0A2B), white= (#FFFCFC), black = (#000000), darkGray= (#767373),
  red = (#FF0324), orangeCol = (#FC9903);
//Instantiate Settings Class
Settings settings= new Settings (1700, 300, 100);
// Instantiate Orange Enemy Class
Orange orange= new Orange (width-200, height, 100);

void setup() {
  size(2000, 2000);
  fullScreen();
  background (bgColor);

  //import Settings Variables
  cog = loadImage("cog.png");
  s= new Sound (this);
}

void draw() {
  background (bgColor);
  switch (screen) {
  case "start":
    startScreen();
    break;
  case "game":
    //THIS CAN BE SWAPPED OUT WITH GAME SCREEN
    orange.display();
    orange.update();
    settingsButton();
    break;
  case "settings":
    //IMPORTING SETTINGS TAB
    s.volume(amp);
    settings.openTab();
    break;
  case "map":
    //IMPORT MAP
    settings.mapScreen();
    break;
  case "save":
    //IMPORT LOAD SAVE SCREEN
    saveScreen();
    break;
  case "credits":
    credits();
    break;
  }
  //DEBUG MOUSE COORDS
   //mouse detection
  fill (circleCol);
  noStroke();
  circle(mouseX, mouseY, 20);
  textSize(30);
  fill(red);
  text ("COORDS:\t"+mouseX +"\t," + mouseY, mouseX-50, mouseY-50);
}

void startScreen() {
  if (screen=="start") {
    boolean startClicked = (mouseX > 400 && mouseX < 1300 &&
      mouseY > 300 && mouseY < 400 && mousePressed);
    boolean settingsClicked = (mouseX > 400 && mouseX < 1300 &&
      mouseY > 500 && mouseY < 600 && mousePressed && screen =="start");
    boolean creditsClicked = (mouseX > 400 && mouseX < 1300 &&
      mouseY > 700 && mouseY < 800 && mousePressed);
    fill(black);
    rect(0, 0, width, height);
    fill (white);
    textSize(120);
    text("COMPOST COMBAT", width/3.05, height/8);
    textSize(72);
    //Settings Buttons
    stroke(gray);
    strokeWeight(4);
    fill(darkGray);
    for (int i=0; i<3; i++) {
      rect(400, 300+(i*200), width/2, 100);
    }
    noStroke();
    fill(bgColor);
    text("Start Game", settings.rectangle.x, 370);
    text("Settings", settings.rectangle.x, 570);
    text("Credits", settings.rectangle.x, 770);
    if (startClicked) {
      screen = "save";
      mousePressed=false;
    }
    if (settingsClicked) {
      screen = "settings";
      mousePressed = false;
    }
    if (creditsClicked) {
      screen = "credits";
    }
  }
}
void saveScreen() {
  if (screen == "save") {
    fill(black);
    settingsWindow();
    //Save Text
    textSize(72);
    fill(bgColor);
    text("SAVES", width/3, height/11);
    //Save Boxes
    for (int i=0; i<4; i++) {
      stroke(gray);
      strokeWeight(4);
      fill(darkGray);
      rect(300, 200+(i*210), width/1.5, 180);
      fill (bgColor);
      text ("Saved Slot ...", 300, 300+(i*210));
    }
    noStroke();
    boolean saveClicked= (mouseX > 300 && mouseX < 1500&& 
                          mouseY > 200 && mouseY < 380 ||
                          mouseY > 400 && mouseY < 580 || 
                          mouseY > 600 && mouseY < 780); 
    if (saveClicked && mousePressed){
      screen="game";
    }
    exitButton();
    if (onX() && mousePressed) {
      screen = "start";
      mousePressed= false;
    }
  }
}

void credits () {
  fill(black);
  rect(0, 0, width, height);
  fill (white);
  textSize(72);
  text("CREDITS:\n\n Thank You for Playing!", width/3, height/10);
  exitButton();
  if (onX() && mousePressed) {
    screen = "start";
  }
}
void mousePressed(){
   mouseReleased();
}
