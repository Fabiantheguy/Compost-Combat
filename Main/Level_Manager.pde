

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
String[] saveSlotNames = {"Empty Slot", "Empty Slot", "Empty Slot", "Empty Slot"};
boolean[] slotNamed = {false, false, false, false};
int activeSlot = -1; // No slot selected
boolean typingName = false;
color bgColor = (#F5F2F2), gray= (#7D867B),
  circleCol= (#FF0A2B), white= (#FFFCFC), black = (#000000), darkGray= (#767373),
  red = (#FF0324), orangeCol = (#FC9903);
//Instantiate Settings Class
Settings settings= new Settings (1700, 300, 100);
// Instantiate Orange Enemy Class
//Orange orange= new Orange (width-200, height, 100);

void startScreenSetup() {


  background (bgColor);
  
  //import Settings Variables
  cog = loadImage("cog.png");
  s = new Sound (this);
}

void menuDraw() {
  switch (screen) {
  case "start":
    startScreen();
    break;
  case "game":
    //THIS CAN BE SWAPPED OUT WITH GAME SCREEN
    settingsButton();
    break;
  case "settings":
    //IMPORTING SETTINGS TAB
    //s.volume(amp);
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
    textSize(125);
    text("COMPOST COMBAT", width/5, height/8);
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
  fill(black);
  settingsWindow();

  textSize(72);

  text("SAVES", width/3, height/11);

  for (int i = 0; i < 4; i++) {
    stroke(gray);
    strokeWeight(4);
    fill(darkGray);
    rect(300, 200 + (i * 210), width / 1.5, 180);
    fill(bgColor);
    
    // If typing into this slot, show cursor
String displayName = saveSlotNames[i];
if (i == activeSlot && typingName) {
  if ((millis() / 500) % 2 == 0) {
    displayName += "|";
  }
}
    text(displayName, 320, 300 + (i * 210));
  }

  // Detect clicks on individual save slots
  if (mousePressed) {
    for (int i = 0; i < 4; i++) {
      int yTop = 200 + (i * 210);
      int yBottom = yTop + 180;
      if (mouseX > 300 && mouseX < 1500 && mouseY > yTop && mouseY < yBottom) {
        activeSlot = i;
        if (slotNamed[i] == false) {
        typingName = true;
        }
        if (slotNamed[i]) {
        screen = "game";
        }
        if (saveSlotNames[i].equals("Empty Slot")) {
          saveSlotNames[i] = "";
        }
        break;
      }
    }
  }

  // X Button and return
  exitButton();
  if (onX() && mousePressed) {
    screen = "start";
    activeSlot = -1;
    typingName = false;
    mousePressed = false;
  }
}
void saveKeyPressed() {  
    if (typingName && activeSlot >= 0 && activeSlot < 4) {
    if (key == BACKSPACE) {
      if (saveSlotNames[activeSlot].length() > 0) {
        saveSlotNames[activeSlot] = saveSlotNames[activeSlot].substring(0, saveSlotNames[activeSlot].length() - 1);
      }
    } else if (key == ENTER || key == RETURN) {
      typingName = false;
      if (saveSlotNames[activeSlot].trim().length() > 0) {
        slotNamed[activeSlot] = true;
        screen = "game";
        saveToFile(); // Save to JSON
      }
    } else if (key != CODED) {
      saveSlotNames[activeSlot] += key;
    }
  }
}


  //IN PROGRESS
  //vines = new Vines [3]; // the amount of vines we need in the scene (# CAN BE ALTERED)
  //for (int i =0; i<vines.length; i ++ ) {
  //  vines[0] = new Vines (vinesPOS.x, vinesPOS.y, vinesPOS.x, length);
  //  vines[1] = new Vines (vinesPOS.x + (i * 400), vinesPOS.y, vinesPOS.x + (i * 400), length);
  //  vines[2] =new Vines (vinesPOS.x + (i * 800), vinesPOS.y, vinesPOS.x +(i * 800), length);
  //}
  //}
  

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


void saveToFile() {
  JSONObject json = new JSONObject();
  for (int i = 0; i < 4; i++) {
    json.setString("slot" + i, saveSlotNames[i]);
  }
  saveJSONObject(json, sketchPath("gameData.json")); // Use full path
}


void loadSaveData() {
  JSONObject json;
  String savePath = sketchPath("gameData.json");

  File f = new File(savePath);
  if (!f.exists()) {
    println("No save file found. Creating new one...");
    json = new JSONObject();
    for (int i = 0; i < 4; i++) {
      json.setString("slot" + i, "Empty Slot");
    }
    saveJSONObject(json, savePath); // Save new default file
  } else {
    json = loadJSONObject(savePath); // Load it if it exists
  }

  for (int i = 0; i < 4; i++) {
    String name = json.getString("slot" + i, "Empty Slot");
    saveSlotNames[i] = name;
    if (!name.equals("Empty Slot") && !name.trim().equals("")) {
      slotNamed[i] = true;
    }
  }
}
