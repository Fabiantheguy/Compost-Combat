class Settings {
  PVector pos;
  float size, move,
    rectX, rectY, rectX2, rectY2;
  color bgColor = (#EDE6E6), gray= (#7D867B), circleCol= (#FF0A2B), white= (#FFFCFC),
    black = (#000000), darkGray= (#767373), red = (#FF0324);

  Settings (float x, float y, float s) {
    pos= new PVector (x, y);
    size= s;
    rectX =screenWidth -230;
    rectX2 = 100;
    rectY = 80;
    rectY2 = 20;
    move=0.00;
  }
  void update() {
    boolean onSettings = mouseX>rectX-10 && mouseX<rectX+rectX2 &&
      mouseY>rectY-10 && mouseY< rectY+rectY2;
    if (screen =="game") {
      //Settings Button
      //image (cog,screenWidth-220, 90);
      fill(circleCol, 0);
      circle(screenWidth-220, 90, radius);
      fill(red);
      textSize(30);
      text("Settings", screenWidth-190, 100);
      image(cog, rectX-15, rectY-15, 50, 50);
    }
    //mouse detection
    fill (circleCol);
    noStroke();
    circle(mouseX, mouseY, 20);

    //If Button is Clicked, Open Settings
    if (onSettings) {
      //ADD COG ANIMATION HERE

      if (mousePressed) {
        circleCol = #0208F5;
        screen = "settings";
      }
    }
  }
  void openTab() {
    boolean onX = mouseX>screenWidth-266 && mouseX < ((screenWidth-266)+30)
      && mouseY > 135 && mouseY < 165;
    //Settings Screen
    if (screen=="settings") {
      fill(black);
      rect(100, 100, screenWidth-300, screenHeight-300);
      //exit button
      fill(red);
      circle(screenWidth-250, 150, radius);
      //temporary settings text
      textSize(72);
      fill(bgColor);
      text("SETTINGS", screenWidth/2.5, screenHeight/9);
      //Settings Buttons
      stroke(gray);
      strokeWeight(4);
      fill(darkGray);
      for (int i=0; i<4; i++) {
      rect(screenWidth/4.5, 300+(i*200), screenHeight/2, 100);
      }

      fill(bgColor);
      text("Save Game", screenWidth/4.25, 370);
      text("Map", screenWidth/4.25, 570);
      text("Volume", screenWidth/4.25, 770);
      text("Exit Game", screenWidth/4.25, 970);

      //Volume Bar
      fill(white,90);
      rect(800, 745, 500, 20);

      fill(black);
      rect(x, 725, 10, 60);
      

      boolean onVolumeBar = mouseX > 790 && mouseX < 1300;

      if (onVolumeBar) {
        if (mousePressed) {
          x=mouseX;
          amp = mouseX/16;
          if (mouseX>1300) {
            mouseX=1300;
          }
        }
      }
      //SWITCHING SCREENS BASED ON MOUSE CLICKS
      boolean saveClicked = mouseX> 445 && mouseX<1440 && mouseY>300 && mouseY < 400;
      boolean exitClicked =  mouseX> 445 && mouseX<1440 && mouseY>900 && mouseY < 1000;
      boolean mapClicked= mouseX> 445 && mouseX<1440 && mouseY>500 && mouseY < 600;
      if (saveClicked && mousePressed) {
        screen = "save";
      }
      if (mapClicked && mousePressed){
        screen= "map";
      }
      if (exitClicked && mousePressed) {
        exit();
      }
      if (onX && mousePressed) {
        screen = "game";
      }
    //DEBUG MOUSE COORDS
    textSize(30);
    fill(red);
    text ("COORDS:\t"+mouseX +"\t," + mouseY, mouseX-50, mouseY-50);
        }
      if (onX && mousePressed && screen =="map"){
        screen = "settings";
        mousePressed = false;
      }
  }

  void saveScreen() {
    if (screen == "save") {
      boolean onX = mouseX>screenWidth-266 && mouseX < ((screenWidth-266)+30);
      //Background Rect
      fill(black);
      rect(100, 100, screenWidth-300, screenHeight-300);
      //Save Text
      textSize(72);
      fill(bgColor);
      text("SAVES", screenWidth/2.5, screenHeight/11);
      //Save Boxes
      for (int i=0; i<4; i++) {
        stroke(gray);
        strokeWeight(4);
        fill(darkGray);
        rect(screenWidth/8, 200+(i*210), screenWidth/1.5, 180);
        fill (bgColor);
        text ("Saved Slot ...", screenWidth/8, 300+(i*210));
      }
      //exit button
      fill(red);
      noStroke();
      circle(screenWidth-250, 150, radius);
      if (onX && mousePressed) {
        screen = "settings";
        mousePressed= false;
      }
    }
  }
  
  void mapScreen(){
    boolean onX = mouseX>screenWidth-266 && mouseX < ((screenWidth-266)+30);
    if (screen=="map"){   
    //Background Rect
      fill(gray);
      rect(100, 100, screenWidth-300, screenHeight-300);
      fill(black);
      textSize(72);
      text("MAP SHOWN HERE",
      screenWidth/3, screenHeight/3);
      //exit button
      fill(red);
      circle(screenWidth-250, 150, radius);
      if (onX && mousePressed) {
        screen = "settings";
        mousePressed= false;
      }  
    }
  }
  
  //SAMPLE GAME SCREEN (CAN ERASE)
  void exampleGameScreen() {
    textSize(72);
    text("THIS IS A PLACEHOLDER FOR \n THE GAME SCREEN",
      screenWidth/4, screenHeight/4);
    fill(gray);
  } 
}

/*
  MAY IMPORT COG ANIMATIONS SO MADE
 ANIMATION CLASS FOR THAT REASON
 
 THIS IS NOT IMPLEMENTED YET
 */
class Animation {
  float x=screenWidth-245, y=82;
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
