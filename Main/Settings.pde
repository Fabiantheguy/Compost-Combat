class Settings {
  PVector pos;
  float size, move,
    rectX, rectY, rectX2, rectY2;
  PVector rectangle= new PVector (500, 300);
  boolean changingVol = false; // flag for if the player is currently changing the volume
  color[] upgradeColors; // colors of each of the upgrade buttons
  String upgradeSelected; // selected upgrade for the upgrade menu
  boolean upgradeChosen = false; // toggle so player can only choose 1 update per level

  Settings (float x, float y, float s) {
    pos= new PVector (x, y);
    size = s;
    rectX = x;
    rectX2 = 50;
    rectY = y;
    rectY2 = 50;
    
    // upgrade color array
    upgradeColors = new color[6];
    upgradeColors[0] = color(255, 140, 0);
    upgradeColors[1] = color(255, 178, 85);
    upgradeColors[2] = color(35, 177, 0);
    upgradeColors[3] = color(78, 217, 44);
    upgradeColors[4] = color(243, 41, 223);
    upgradeColors[5] = color(255, 113, 241);
  }

  void openTab() {
    float rectStart = 400, rectEnd = 1370;
    //Settings Screen
    if (screen=="settings") {
      fill(black);
      settingsWindow();
      exitButton();
      //temporary settings text
      textSize(72);
      fill(bgColor);
      text("SETTINGS", width/3, height/4);
      //Settings Buttons
      stroke(gray);
      strokeWeight(4);
      fill(darkGray);
      for (int i=0; i<4; i++) {
        rect(400, 300+(i*200), width/2, 100);
      }
      noStroke();
      fill(bgColor);
      text("Return to Title Screen", rectangle.x, 370);
      text("Map", rectangle.x, 570);
      text("Volume", rectangle.x, 770);
      text("Exit Game", rectangle.x, 970);

      //Volume Bar
      fill(white, 90);
      rect(760, 745, 500, 20);

      fill(black);
      rect(constrain(x, 759, 1251), 725, 10, 60);

      boolean onVolumeBar = mouseX > 759 && mouseX < 1251&&
        mouseY >700 && mouseY <800;

      if (onVolumeBar) {
        fill(white);
        text(int(amp) + "%", constrain(x, 759, 1251) - 50, 720);
        if (mousePressed) {
          changingVol = true;
          x=constrain(mouseX, 759, 1251);;
          amp = map(mouseX, 759, 1251, 0, 101);
          masterVol = constrain(amp/100, 0.0, 1.0);
          Sound.volume(masterVol); // sets the overall volume of the game
          if (mouseX>1251) {
            mouseX=1251;
          }
        }
      }
      // putting this outside the onVolumeBar check allows the volume to be easily set to exactly 0% or 100%
      if(changingVol && !mousePressed) {
        saveToFile();
        changingVol = false; // writes volume data to JSON only when mouse is released
        println("Volume data saved!");
      }
      
      //SWITCHING SCREENS BASED ON MOUSE CLICKS
      boolean startClicked = mouseX> rectStart && mouseX<rectEnd &&
        mouseY>300 && mouseY < 400;
      boolean exitClicked =  mouseX> rectStart && mouseX<rectEnd &&
        mouseY>900 && mouseY < 1000;
      boolean mapClicked= mouseX> rectStart && mouseX<rectEnd &&
        mouseY>500 && mouseY < 600 && screen =="settings";

      if (startClicked && mousePressed) {
        screen = "start";
        cameFromGameScr = false;
        mousePressed = false;
      }
      if (mapClicked && mousePressed) {
        cameFromGameScr = false;
        screen= "map";
      }
      if (exitClicked && mousePressed) {
        cameFromGameScr = false;
        fill(gray, 85);
        stroke(gray);
        strokeCap(ROUND);
        strokeWeight(10);
        rect(width/2, height/3, 400, 100);
        fill (white);
        text("exiting ...", width/2, height/2.5);
        noStroke();
        exit();
      }
      if (onX() && mousePressed) {
        screen = "game";
        cameFromGameScr = false;
      }
      if (onX() && mousePressed && screen =="map") {
        screen = "settings";
        cameFromGameScr = false;
        mousePressed = false;
      }
    }
  }

  void mapScreen() {
    if (screen=="map") {
      //Background Rect
      fill(gray);
      settingsWindow();
      fill(black);
      textSize(36);
      text("Map", width/2.075, height/5);
      text("Start\nPoint", width / 2 - 37, 350);
      text("Level #1", width / 2 - 362.5, 550);
      text("Level #2", width / 2 + 237.5, 550);
      text("Level #3", width / 2 - 462.5, 750);
        //Draw all Node connections, that are behind nodes
      for (LevelNode node : nodes) {
        node.drawConnections();
      }
      //Draws each level node
      for (LevelNode node : nodes) {
        node.display();
      }
      
      drawLegend();

      exitButton();
      if (onX() && mousePressed) {
        screen = "settings";
        mousePressed = false;
      }
    }
  }

  void drawLegend() {
    float legendX = 100;
    float legendY = height - 250;
    float boxW = 300;
    float boxH = 245;
    float rowHeight = 50;

    fill(white, 230);
    stroke(black);
    strokeWeight(2);
    rect(legendX, legendY, boxW, boxH, 10);

    textSize(24);
    fill(black);
    text("Map Legend/Key:", legendX + 20, legendY + 30);

    // Start
    fill(0, 255, 0);
    ellipse(legendX + 30, legendY + 60, 20, 20);
    fill(black);
    text("= Spawn", legendX + 60, legendY + 67.5);

    // Locked
    fill(0);
    ellipse(legendX + 30, legendY + 108, 20, 20);
    fill(black);
    text("= Locked", legendX + 60, legendY + 116);

    // Unlocked
    fill(255, 0, 0);
    ellipse(legendX + 30, legendY + 107 + rowHeight, 20, 20);
    fill(black);
    text("= Unlocked", legendX + 60, legendY + 115 + rowHeight);

    // Completed
    fill(0, 200, 255);
    ellipse(legendX + 30, legendY + 110 + rowHeight * 2, 20, 20);
    fill(black);
    text("= Completed", legendX + 60, legendY + 117.5 + rowHeight * 2);
  }


  void settingsButton() {
    boolean onSettings = mouseX>settings.rectX-10 && mouseX<settings.rectX+settings.rectX2 &&
      mouseY>settings.rectY-200 && mouseY< settings.rectY+settings.rectY2;
    //Settings Button
    //image (cog,screenWidth-220, 90);
    fill(circleCol, 0);
    circle(settings.rectX, settings.rectY, radius);
    fill(red);
    textSize(30);
    text("Settings", settings.rectX+50, settings.rectY-170);
    image(cog, settings.rectX, settings.rectY-200, 50, 50);
    if (screen == "game") { //Show Health in game Screen only
      textSize(100);
      text("Health: " + currentHealth, 50, 100);
    }
    if (onSettings) {
      //ADD COG ANIMATION HERE

      if (mousePressed) {
        circleCol = #0208F5;
        cameFromGameScr = (screen.equals("game")); // Only true if coming from main game screen
        screen = "settings";
      }
    }
  }
  

  void settingsWindow() {
    rect(300, 100, width/1.5, height);
  }
  
  void exitButton() {
    //exit button
    fill(red);
    circle(1530, 150, radius);
  }
  
  // UI module for clearing a level
  void lvlClear() {
    // basic UI setup and text
    noStroke();
    fill(black);
    settingsWindow();
    fill(white);
    textSize(150);
    textAlign(CENTER);
    text("LEVEL CLEAR!", width/2, 220);
    textSize(64);
    text("Choose your Upgrade:", width/2, 350);
    text("Dash", width/4, 450);
    text("Range", width/2, 450);
    text("Agility", width*0.75, 450);
    
    // dash upgrade button -- selection check
    if(mouseY > 450 && mouseY < 700 && abs(mouseX-480) <= 150){
      fill(50);
      circle(480, 575, 225);
      fill(upgradeColors[1]);
      upgradeSelected = "dash";
    } else {
      fill(upgradeColors[0]);
    }
    // dash upgrade button -- drawing
    triangle(385, 500, 385, 650, 535, 575);
    triangle(460, 500, 460, 650, 610, 575);
    
    // range upgrade button -- selection check
    if(mouseY > 450 && mouseY < 700 && abs(mouseX-960) <= 150){
      fill(50);
      circle(960, 575, 225);
      fill(upgradeColors[3]);
      upgradeSelected = "range";
    } else {
      fill(upgradeColors[2]);
    }
    // range upgrade button -- drawing
    quad(825, 550, 1100, 550, 1100, 600, 825, 600);
    quad(1090, 570, 1090, 580, 1140, 580, 1140, 570);
    quad(850, 675, 825, 650, 950, 550, 975, 575);
    
    // range upgrade button -- selection check
    if(mouseY > 450 && mouseY < 700 && abs(mouseX-1440) <= 150){
      fill(50);
      circle(1440, 575, 225);
      fill(upgradeColors[5]);
      upgradeSelected = "range";
    } else {
      fill(upgradeColors[4]);
    }
    // range upgrade button -- drawing
    quad(1360, 530, 1490, 530, 1490, 570, 1360, 570);
    quad(1380, 590, 1510, 590, 1510, 630, 1380, 630);
    triangle(1310, 550, 1360, 600, 1360, 500);
    triangle(1560, 610, 1510, 560, 1510, 660);
    
    // check for map button
    boolean mapClicked= mouseX> 480 && mouseX<1440 &&
        mouseY>750 && mouseY < 850 && screen =="clear";
        
    // draw map button
    stroke(gray);
    strokeWeight(4);
    fill(darkGray);
    rect(480, 750, 960, 100);
    noStroke();
    fill(white);
    text("Return to Map", 960, 826);
    textAlign(LEFT);
    
    // interactions
    if(mousePressed){
      // map button code
      if(mapClicked){
        upgradeChosen = false;
        cameFromGameScr = false;
        screen = "map";
      } else if(!upgradeChosen) {
        // upgrade code
        switch(upgradeSelected){
          case "dash":
            // dash upgrade
            if (worm.upgrades.get("dash") < 2) {
              worm.upgrades.add("dash", 1);
              // reduce dash cooldown WIP
            }
            break;
          case "range":
            // range upgrade
            if (worm.upgrades.get("range") < 2) {
              worm.upgrades.add("range", 1);
              worm.bulletLife += 350;
            }
            break;
          case "agility":
            // agility upgrade
            if (worm.upgrades.get("agility") < 2) {
              worm.upgrades.add("agility", 1);
              worm.speed += 1;
            }
            break;
        }
        upgradeChosen = true;
        // print(worm.upgrades);
      }
    }
    
    settingsButton();
  }
  
  boolean onX () {
    if (mouseX>1500 && mouseX < 1550 &&
      mouseY > 145 && mouseY < 165) {
      return true;
    } else
      return false;
  }
  
}
