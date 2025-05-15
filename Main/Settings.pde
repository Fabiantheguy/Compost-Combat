class Settings {
  PVector pos;
  float size, move,
    rectX, rectY, rectX2, rectY2;
  PVector rectangle= new PVector (500, 300);

  Settings (float x, float y, float s) {
    pos= new PVector (x, y);
    size = s;
    rectX = x;
    rectX2 = 50;
    rectY = y;
    rectY2 = 50;
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
      rect(800, 745, 500, 20);

      fill(black);
      rect(constrain(x, 800, 1301), 725, 10, 60);

      boolean onVolumeBar = mouseX > 800 && mouseX < 1301&&
        mouseY >700 && mouseY <800;

      if (onVolumeBar) {
        fill(white);
        text(int(amp) + "%", constrain(x, 800, 1301) - 50, 720);
        if (mousePressed) {
          x=constrain(mouseX, 800, 1301);;
          amp = map(mouseX, 800, 1301, 0, 101);
          if (mouseX>1301) {
            mouseX=1301;
          }
        }
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
        mousePressed = false;
      }
      if (mapClicked && mousePressed) {
        screen= "map";
      }
      if (exitClicked && mousePressed) {
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
      }
      if (onX() && mousePressed && screen =="map") {
        screen = "settings";
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
  fill(0,255,0);
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
  if (screen == "game"){ //Show Health in game Screen only
    textSize(100);
    text("Health: " + currentHealth, 50, 100);
  }
  if (onSettings) {
    //ADD COG ANIMATION HERE

    if (mousePressed) {
      circleCol = #0208F5;
      screen = "settings";
    }
  }
}
//SAMPLE GAME SCREEN (CAN ERASE)
void settingsWindow() {
  rect(300, 100, width/1.5, height);
}
void exitButton() {
  //exit button
  fill(red);
  circle(1530, 150, radius);
}
boolean onX () {
  if (mouseX>1500 && mouseX < 1550 &&
    mouseY > 145 && mouseY < 165) {
    return true;
  } else
    return false;
}

/*
  MAY IMPORT COG ANIMATIONS SO MADE
 ANIMATION CLASS FOR THAT REASON
 
 THIS IS NOT IMPLEMENTED YET
 */
class Animation {
  float x=width-330, y=82;
  PImage[] cog;
  int frame;

  Animation (String startImage, int number) {
    //Instantiate cog image
    number= 3;
    cog = new PImage[number];
    for (int i=0; i< number; i++) {
      //use nf to format #'s into strings
      String cogAnims=startImage + nf(i)+".png";
      cog[i]=loadImage(cogAnims);
    }
  }

  void display () {
    //Settings Icon Import
    frame = (frame+1) % 3;
    image(cog[frame], x, y, 50, 50);
  }
  int getWidth() {
    return cog[0].width;
  }
}
