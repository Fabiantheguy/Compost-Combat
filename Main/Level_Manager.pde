

/* settings for GD 205 Game Compost Combat
 --ELEMENTS NEEDED:
 SAVE GAME
 EXIT GAME
 VOLUME CONTROL (Sound slider)
 MAP
 */
// SETTING lEVEL;
boolean playerWins = false;
boolean Level1, Level2, Level3; //Start game on LVL 1
boolean cameFromGameScr = false;
boolean showLoading = false;
int loadingStartTime = 0;
String levelToLoad = "";
Lvl1 lvl1;
Lvl2 lvl2;
Lvl3 lvl3;

// global lists for level objects so the player can actually access them
ArrayList<Vine> currentVines = new ArrayList<Vine>();
ArrayList<Platform> currentPlats = new ArrayList<Platform>();

//Scene Variables
Sound s;
float amp = map(mouseY, 0, height, 0.0, 1.0); // amplitude of the volume slider
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
Settings settings= new Settings (1400, 250, 100);
//ArrayList to store all Level Nodes for the Level Select
ArrayList<LevelNode> nodes;
// Instantiate Orange Enemy Class
//Orange orange= new Orange (width-200, height, 100);
/*------------------------------------------------
 START SCREEN SETUP
 -------------------------------------------------*/
void startScreenSetup() {
  background (bgColor);

  //import Settings Variables
  cog = loadImage("cog.png");
  s = new Sound (this);
  initLevelNodes();// Implements level nodes for the map screen
}

void menuDraw() {
  switch (screen) {
  case "start":
    startScreen();
    break;
  case "game":
    if (worm.pos.y>height + 100){screen="death";}
    settingsButton();
    break;
  case "death":
    endScreen(); //Dead screen
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
/*------------------------------------------------
 START SCREEN
 -------------------------------------------------*/
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
/*------------------------------------------------
 SAVE SCREEN
 -------------------------------------------------*/
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
          screen = "map";
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
        screen = "map";
        saveToFile(); // Save to JSON
      }
    } else if (key != CODED) {
      saveSlotNames[activeSlot] += key;
    }
  }
}

/*------------------------------------------------
 CREDITS SCREEN
 -------------------------------------------------*/

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
/*------------------------------------------------
 DEATH SCREEN
 -------------------------------------------------*/
void endScreen() {
  screen = "death";
  if (screen == "death") {
    fill(black);
    rect(0, 0, width, height);
    fill (white);
    textSize(125);
    text("THIS IS A DEATH SCREEN \n\n MEANING YOU ARE DEAD... \n\n R.I.P.", width/8, height/4);
    textSize(72);
  }
}
void saveToFile() {
  JSONObject json = new JSONObject();
  for (int i = 0; i < 4; i++) {
    json.setString("slot" + i, saveSlotNames[i]);
  }
  json.setFloat("volume", masterVol);
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
    json.setFloat("volume", 1.0);
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
  Sound.volume(json.getFloat("volume"));
  masterVol = json.getFloat("volume");
}
void initLevelNodes() {
  nodes = new ArrayList<LevelNode>();
  //Created a example level structure(Change if need be)
  LevelNode root = new LevelNode(width / 2, 300, "Spawn");
  LevelNode child1 = new LevelNode(width / 2 - 300, 500, "Unlocked");
  LevelNode child2 = new LevelNode(width / 2 + 300, 500, "Locked");
  LevelNode child3 = new LevelNode(width / 2 - 400, 700, "Locked");
  //If you want to change what level is displayed, change the Level state located in the quotation marks from "Locked" To "Unlocked". 
  //Then when the game is ran, pick the level you want and it should display all the elements shown in that level based on dedicated level class setup. 
  root.addChild(child1);
  child1.addChild(child2);
  child2.addChild(child3);

  nodes.add(root);
  nodes.add(child1);
  nodes.add(child2);
  nodes.add(child3);
}

void loadingScreen() {
  background(0);
  fill(255);
  textSize(72);
  text("Loading...\nPlease Wait", width / 2.5, height / 2 - 100);
  
  // Draws a loading Progress bar
  float barWidth = 600;
  float barHeight = 40;
  float barX = width / 2 - barWidth / 2;
  float barY = height / 2;

  fill(50);
  stroke(255);
  strokeWeight(3);
  rect(barX, barY, barWidth, barHeight, 10);

  // Progress is based on how much time has passed
  float progress = constrain((millis() - loadingStartTime) / 2000.0, 0, 1);
  fill(255, 0, 0);
  noStroke();
  rect(barX, barY, barWidth * progress, barHeight, 10);

  // Once the progress bar is filled, It will load the desired unlocked level that was chosen
  if (progress >= 1.0)

  if (millis() - loadingStartTime > 2000) {
    screen = "game";
    showLoading = false;

    // Set level flags
    Level1 = Level2 = Level3 = false;
    if (levelToLoad.equals("Level1")) Level1 = true;
    else if (levelToLoad.equals("Level2")) Level2 = true;
    else if (levelToLoad.equals("Level3")) Level3 = true;

    lvlSetup();
    screen = "game";
    showLoading = false;
  }
}

/*_____________________________________________
 LEVEL CHANGER
 _____________________________________________*/
void lvlSetup() {
  if (Level1) {
    lvl1 = new Lvl1();
  }
  if (Level2) {
    lvl2 = new Lvl2();
  }
  if (Level3) {
    lvl3 = new Lvl3();
  }
}

void lvlChanger() {
  if (Level1) {
    Level2=false;
    Level3 = false;
    lvl1.run();
  }
  if (Level2) {
    Level1 = false;
    Level3 = false;
    lvl2.run();
  }
  if (Level3) {
    Level1 = false;
    Level2=false;
    lvl3.run();
  }
  if (playerWins) {
  // Marks current level as Completed if the player completed it
  for (int i = 1; i < nodes.size(); i++) {
    if ((Level1 && i == 1) || (Level2 && i == 2) || (Level3 && i == 3)) {
      nodes.get(i).state = "Completed";
      nodes.get(i).targetColor = nodes.get(i).getColorForState("Completed");

      if (i + 1 < nodes.size()) {
        nodes.get(i + 1).state = "Unlocked";
        nodes.get(i + 1).targetColor = nodes.get(i + 1).getColorForState("Unlocked");
      }
      break;
    }
  }

  Level1 = Level2 = Level3 = false;
  playerWins = true;
  screen = "map";
}

}

/*_____________________________________________
 LEVEL 1 SETUP
 _____________________________________________*/
class Lvl1 {
  Lvl1() {

    //CHANGE THE PLATFORM & VINE LOCATION VALUES TO  MATCH YOUR LEVEL DESIGN

    v = new Vine [3]; // the amount of vines we need in the scene (# CAN BE ALTERED)
    v[0] = new Vine(width - 150, 100, 75, 525);
    v[1] = new Vine(width - 750, -700, 75, 785);
    v[2] = new Vine(width + 750, -1350, 75, 700);


    platforms = new Platform [5]; // the amount of platforms we need in the scene (# CAN BE ALTERED)
    platforms[0] = new Platform(width - 800, 80, 800, 20);
    platforms[1] = new Platform(width - 1200, -700, 1200, 20);
    platforms[2] = new Platform(width + 200, -650, 1000, 20);
    platforms[3] = new Platform(width + 200, -1350, 950, 20);
    platforms[4] = new Platform(width - 1000, -1300, 1000, 20);
    
    /*
    PImage[] appleFrames = new PImage[]{
    loadImage("apple/Red.png"),
    loadImage("apple/Blue.png"),
    loadImage("apple/Orange.png"),
    loadImage("apple/Teal.png")
    };
    PImage[] bananaFrames = new PImage[]{
      loadImage("Banana.png"),
      loadImage("apple/Red.png"),
    };
    */
    EnemyFactory factory = new EnemyFactory(); 
    
    currentVines.clear(); // clear current vines to prepare to add this level's set
    // add each vine in this level's array to the current vines list
    for(int i=0; i<v.length; i++){
      currentVines.add(v[i]);
    }
    
    currentPlats.clear(); // clear current platforms to prepare to add this level's set
    // add each platform in this level's array to the current platforms list
    for(int i=0; i<platforms.length; i++){
      currentPlats.add(platforms[i]);
    }

    apple = new Apple [3];
    apple[0] = new Apple(width - 800, 80, platforms[0]);
    apple[1] = new Apple(width - 1200, -740,platforms[1]);
    apple[2] = new Apple(width + 200, -1390, platforms[3]);
    
  }

  void run() {
    display();
    update();
  }
  void display() {
    for (int i = 0; i < v.length; i++) {
      v[i].display();
    }
    for (int i = 0; i <platforms.length; i++) {
      platforms[i].display();
    }
  }
  void update() {
    for (int i = 0; i < v.length; i++) {
      v[i].update();
    }


    for (int i = 0; i <platforms.length; i++) {
      platforms[i].update();
    }
  }
}

/*_____________________________________________
 LEVEL 2 SETUP
 _____________________________________________*/
class Lvl2 {
  Lvl2 () {
    //CHANGE THE PLATFORM & VINE LOCATION VALUES TO  MATCH YOUR LEVEL DESIGN

    platforms = new Platform [5]; // the amount of platforms we need in the scene (# CAN BE ALTERED)
    platforms[0] = new Platform(0, 160, 440, 20);
    platforms[1] = new Platform(500, 220, 200, 20);
    platforms[2] = new Platform(750, 350, 200, 20);
    platforms[3] = new Platform(1000, 300, 100, 20);
    platforms[4] = new Platform(1200, 250, 100, 20);



    //IN PROGRESS

    vines = new swingingVines [3]; // the amount of vines we need in the scene (# CAN BE ALTERED)
    vines[0] = new swingingVines (650, 0, 650, vlength);
    vines[1] = new swingingVines (2300, -400, 2300, vlength);
    vines[2] =new swingingVines (2700, -400, 2700, vlength);
    
    // add current swinging vines to a global list (WIP)
    
    currentPlats.clear(); // clear current platforms to prepare to add this level's set
    // add each platform in this level's array to the current platforms list
    for(int i=0; i<platforms.length; i++){
      currentPlats.add(platforms[i]);
    }
    
    worm.pos= new PVector(100,100);
  }
  void run() {

    display();
    update();
  }

  void display() {

    for (int i = 0; i < vines.length; i++) {
      vines[i].display();
    }
    for (int i = 0; i <platforms.length; i++) {
      platforms[i].display();
    }
  }
  void update() {
    for (int i = 0; i < vines.length; i++) {
      vines[i].update();
    }


    for (int i = 0; i <platforms.length; i++) {
      platforms[i].update();
    }
  }
}

/*_____________________________________________
 LEVEL 3 SETUP
 _____________________________________________*/
class Lvl3 {
  Lvl3 () {

    //CHANGE THE PLATFORM & VINE LOCATION VALUES TO  MATCH YOUR LEVEL DESIGN

    platforms = new Platform[6];
    platforms[0] = new Platform(1300, 200, 250, 20);  // Starts directly after The end of level 2
    platforms[1] = new Platform(1500, 100, 200, 20);  // Climb up
    platforms[2] = new Platform(1650, -50, 250, 20);  // Mid-level challenge
    platforms[3] = new Platform(1800, -200, 180, 20); // Narrower
    platforms[4] = new Platform(2000, -350, 300, 20); // More open space
    platforms[5] = new Platform(2200, -500, 250, 20); // Final platform

    // Vines to bridge larger vertical gaps
    v = new Vine[4];
    v[0] = new Vine(1450, 100, 75, 150);   // From plat 0 to plat 1
    v[1] = new Vine(1600, -50, 75, 150);   // From plat 1 to plat 2
    v[2] = new Vine(1750, -200, 75, 150);  // From plat 2 to plat 3
    v[3] = new Vine(2150, -500, 75, 200);  // Final ascent
    
    currentVines.clear(); // clear current vines to prepare to add this level's set
    // add each vine in this level's array to the current vines list
    for(int i=0; i<v.length; i++){
      currentVines.add(v[i]);
    }
    
    currentPlats.clear(); // clear current platforms to prepare to add this level's set
    // add each platform in this level's array to the current platforms list
    for(int i=0; i<platforms.length; i++){
      currentPlats.add(platforms[i]);
    }

    // Respawn worm near Level 2's exit
    worm.pos = new PVector(1350, 150);
  }

  void run() {
    display();
    update();
  }

  void display() {
    for (int i = 0; i < v.length; i++) {
      v[i].display();
    }
    for (int i = 0; i < platforms.length; i++) {
      platforms[i].display();
    }
  }

  void update() {
    for (int i = 0; i < v.length; i++) {
      v[i].update();
    }
    for (int i = 0; i < platforms.length; i++) {
      platforms[i].update();
    }
  }
}
