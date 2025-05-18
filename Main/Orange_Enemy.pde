// Secluded variables for the enemy (orange), and platform
Orange[] orange;

PImage[] orangeFrames;

int orangeRespawnTime = 3000; // 3 seconds to respawn the apple
int orangeLastDestroyedTime = -1; // -1 means no orange has died yet


// Initialize the orange and platform objects
void orangeSetup() {
  orangeFrames = new PImage[1];
  orangeFrames[0] = loadImage("Orange.png");
  orange = new Orange[1];
  orange[0] = new Orange(width / 4, worm.pos.y - 100);
}

void orangeDraw() {
  // checks if orange array exists
  if (orange != null) {
    for (Orange currentOrange : orange){
      // Orange is alive
      if (currentOrange.hitPoints > 0){  
        currentOrange.follow(worm);
        currentOrange.update();
        currentOrange.display();
      } else {
        // Orange is dead
        if (orangeLastDestroyedTime < 0) {
          // Timer hasn't started yet — start it now
          orangeLastDestroyedTime = millis();
        }
        // Check if enough time has passed to respawn
        if (millis() - orangeLastDestroyedTime > orangeRespawnTime) {
          currentOrange.x = currentOrange.initX;
          currentOrange.y = currentOrange.initY;
          currentOrange.hitPoints = 1;
          orangeLastDestroyedTime = -1; // Reset timer
        }
      }
    } 
  }
}


// orange class
class Orange extends Enemy {
  float x, y, initX, initY;               // Position
  float w = 40, h = 40;     // Size
  float speed = 12;
  float ySpeed = 0;
  float gravity = 0.8;

  PImage[] frames;          // Array of animation frames
  int currentFrame = 0;     // Index of current frame
  int frameTimer = 0;       // Used to time switching frames
  int frameInterval = 10;   // Change frame every 10 draw() calls
  
  boolean orangeMove = true; //orange can move
  int orangeStop = -1; //orange stop for certain amount of seconds

  Orange(float x, float y) {
    super(x, y, 1, orangeType, orangeFrames);

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
