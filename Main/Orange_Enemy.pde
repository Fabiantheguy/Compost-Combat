// Secluded variables for the enemy (orange), and platform //<>// //<>// //<>//
Orange orange;

PImage spriteSheetOrange = loadImage("Orange.png");

int orangeRespawnTime = 3000; // 3 seconds to respawn the apple
int orangeLastDestroyedTime = -1; // -1 means no apple has died yet


// Initialize the orange and platform objects
void orangeSetup() {
  orange = new Orange(width / 4, worm.pos.y - 100);
}

void orangeDraw() {
  if (orange == null) {
    // orange is dead
    if (orangeLastDestroyedTime < 0) {
      // Timer hasn't started yet — start it now
      orangeLastDestroyedTime = millis();
    }
    // Check if enough time has passed to respawn
    if (millis() - orangeLastDestroyedTime > orangeRespawnTime) {
      orange = new Orange(width / 4, worm.pos.y - 100);
      orangeLastDestroyedTime = -1; // Reset timer
    }
  } else {
    // orange is alive
    orange.follow(worm);
    orange.update();
    orange.display();
  }
  
}


// orange class
class Orange {
  float x, y;               // Position
  float w = 40, h = 40;     // Size
  float speed = 12;
  float ySpeed = 0;
  float gravity = 0.8;

  PImage[] frames;          // Array of animation frames
  int currentFrame = 0;     // Index of current frame
  int frameTimer = 0;       // Used to time switching frames
  int frameInterval = 10;   // Change frame every 10 draw() calls
   int cols = 6;
  int rows = 1; 
  int frameW =spriteSheetOrange. width / cols;
  int frameH = spriteSheetOrange. height / rows; 
  int frameTimer = 0;       // Used to time switching frames
  int frameInterval = 10;   // Change frame every 10 draw() calls
  int frameCounter = 0;
  
  
    int index; 
      //for (int i =0; i < cols; i++){
       // frames[index++] = spriteSheetOrange.get(i * frameW,  frameH, frameW, frameH);
     // }
     
     
  boolean orangeMove = true; //orange can move
  int orangeStop = -1; //orange stop for certain amount of seconds

  Orange(float x, float y) {
    this.x = x;
    this.y = y;

    // Load the four frames (make sure these files are in your "data" folder)
    frames = new PImage[1];
    frames[0] = loadImage("orange/Orange.png");
  }
  //follow player if the orangeMove function is true
  void follow(Play player) {
      if (orangeMove) {
        if (player.pos.x < x - 1) x -= speed;
        else if (player.pos.x > x + 1) x += speed;
    }
  }
  

  void update() {
 
    //Time until orange can move
    if (!orangeMove && millis() - orangeStop >= 3000) {
      orangeMove = true;
      
    }
 
    // Gravity
    ySpeed += gravity;
    y += ySpeed;
    
    frameCounter ++;
    if (frameCounter >= frameInterval){
      currentFrame = (currentFrame + 1) %totalFrames;
      frameCounter = 0;

    Rectangle orangeRect = getBounds();

    for (Ground g : allGrounds) {
      Rectangle groundRect = new Rectangle(
        (int) g.pos.x,
        (int) g.pos.y,
        (int) g.area.x,
        (int) g.area.y
      );

      if (orangeRect.intersects(groundRect)) {
        y = g.pos.y - h + 1; // Snap orange to ground
        ySpeed = 0;
        break;
      }
    }
    

    // Animation
    frameTimer++;
    if (frameTimer >= frameInterval) {
      frameTimer = 0;
      currentFrame = (currentFrame + 1) % frames.length;
    }
  }

  void display() {
    image(frames[currentFrame], x - 20, y - 30, 80, 80);
  }

  boolean onAnyGround() {
    Rectangle orangeRect = getBounds();
    for (Ground g : allGrounds) {
      Rectangle groundRect = new Rectangle(
        (int) g.pos.x,
        (int) g.pos.y,
        (int) g.area.x,
        (int) g.area.y
      );
      if (orangeRect.intersects(groundRect)) return true;
    }
    return false;
  }

  Rectangle getBounds() {
    return new Rectangle((int) x, (int) y, (int) w, (int) h);
  }
  //Making the orange stunned making sure to call it within the player
  void orangeStun() {
    orangeMove = false;       
    orangeStop = millis();

}

}
