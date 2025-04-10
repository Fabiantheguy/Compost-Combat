class Settings {
  PVector pos;
  float size, rectX, rectY, rectX2, rectY2;
  color bgColor = (#AAF796), gray= (#7D867B), circleCol= (#FF0A2B),
  black = (#000000), white= (#FFFFFF), red = (#FF0324);
  
  Settings (float x, float y, float s) {
    pos= new PVector (x, y);
    size= s;
    rectX =screenWidth -230;
    rectX2 = 100;
    rectY = 80;
    rectY2 = 20;
  }
  void update() {
    if (screen =="game"){
      //Settings Button
      circle(screenWidth-220, 90, radius);
      textSize(30);
      text("Settings", screenWidth-200, 100);
    }
    //mouse detection
    fill (circleCol);
    noStroke();
    circle(mouseX, mouseY, 20);
    //If Button is Clicked, Open Settings
    if (collidesWith() && mousePressed) {
      circleCol = #0208F5;
      screen = "settings";
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
        
        fill (red,0);
        stroke(red);
        rect(screenWidth-266,135,30,30) ;
        //temporary settings text
        textSize(72);
        stroke(white);
        text("THIS IS A PLACEHOLDER FOR \n THE SETTINGS SCREEN",
        screenWidth/4, screenHeight/4);
      }
       if (onX && mousePressed) {
        screen = "game";
      }   
  }
  //Collision Detection (Demonstrated by Fabian)
  Rectangle getBounds() {
    return new Rectangle(int(rectX), int(rectX2), int(rectY), int(rectY2));
  }

  Rectangle getMouseBounds() {
    return new Rectangle (int (mouseX), int(mouseY), 20, 20);
  }
  boolean collidesWith() {
    return getBounds().intersects(getMouseBounds());
  }
  
  //SAMPLE GAME SCREEN (CAN ERASE)
  void exampleGameScreen(){
    textSize(72);
    text("THIS IS A PLACEHOLDER FOR \n THE GAME SCREEN",
    screenWidth/4, screenHeight/4);
    fill(settings.gray);
  }
}
