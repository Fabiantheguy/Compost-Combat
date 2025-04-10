class Settings {
  PVector pos;
  float size,move,
        rectX, rectY, rectX2, rectY2;
  color bgColor = (#AAF796), gray= (#7D867B), circleCol= (#FF0A2B),
        black = (#000000), white= (#FFFFFF), red = (#FF0324);

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
      image(cog, rectX-15,rectY-15,50,50);
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
    boolean onX = mouseX>screenWidth-266 &&
      mouseX < ((screenWidth-266)+30)
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
      fill(white);
      text("THIS IS A PLACEHOLDER FOR \n THE SETTINGS SCREEN",
        screenWidth/4, screenHeight/4);
    }
    if (onX && mousePressed) {
      screen = "game";
    }
  }

  //SAMPLE GAME SCREEN (CAN ERASE)
  void exampleGameScreen() {
    textSize(72);
    text("THIS IS A PLACEHOLDER FOR \n THE GAME SCREEN",
      screenWidth/4, screenHeight/4);
    fill(settings.gray);
  }
}

/*
  MAY IMPORT COG ANIMATIONS SO MADE 
  ANIMATION CLASS FOR THAT REASON 
  
  THIS IS NOT IMPLEMENTED YET
*/
class Animation {
  float x=screenWidth-245,y=82;
  PImage[] cog;
  int frame;
  
  Animation (String startImage, int number){
   //Instantiate cog image
    number= 3;
    cog = new PImage[number];
    for (int i=0; i< number; i++){
      //use nf to format #'s into strings
      String cogAnims=startImage + nf(i)+".png";
      cog[i]=loadImage(cogAnims);
    }
  }
  
  void display (){
      //Settings Icon Import
      frame = (frame+1) % 3;
      image(cog[frame], x, y, 50, 50);
  }
  int getWidth(){
    return cog[0].width;
  }
}
