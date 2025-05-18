// Secluded variables for the enemy (Apple), and platform //<>// //<>//
Apple[] apple;

PImage[] appleFrames; // global apple frames array that all apples load from

int respawnTime = 3000; // 3 seconds to respawn the apple
int lastDestroyedTime = -1; // -1 means no apple has died yet

// Initialize the Apple and platform objects
void appleSetup() {
  appleFrames = new PImage[4];
  appleFrames[0] = loadImage("apple/Red.png");
  appleFrames[1] = loadImage("apple/Teal.png");
  appleFrames[2] = loadImage("apple/Orange.png");
  appleFrames[3] = loadImage("apple/Blue.png");
}

void appleDraw() {
  // checks if apple array exists
  if (apple != null) {
    for (Apple currentApple : apple){
      // Apple is alive
      if (currentApple.hitPoints > 0){  
        currentApple.patrol();
        currentApple.update();
        currentApple.display();
      } else {
        // Apple is dead
        if (lastDestroyedTime < 0) {
          // Timer hasn't started yet — start it now
          lastDestroyedTime = millis();
        }
        // Check if enough time has passed to respawn
        if (millis() - lastDestroyedTime > respawnTime) {
          currentApple.hitPoints = 1;
          // should probably add something to send the apple back to its starting position
          lastDestroyedTime = -1; // Reset timer
        }
      }
    } 
  }
}


// Apple class
class Apple extends Enemy {
  float speed = 1;
  float ySpeed = 0;
  float gravity = 0.8;

  PImage[] frames;          // Array of animation frames
  int currentFrame = 0;     // Index of current frame
  int frameTimer = 0;       // Used to time switching frames
  int frameInterval = 10;   // Change frame every 10 draw() calls
  float rightEdge, leftEdge; // edge of platform      
  boolean movingRight = true; // detects if the apple is moving right
  Platform platform;
  
  Apple(float x, float y, Platform platform) {
    super(x, y, 1, appleType, appleFrames);
    this.platform = platform;
    this.leftEdge = platform.x;
    this.rightEdge = platform.x + platform.w;
    
    // Load the four frames (make sure these files are in your "data" folder)
    frames = new PImage[4];
    frames[0] = loadImage("apple/Red.png");
    frames[1] = loadImage("apple/Teal.png");
    frames[2] = loadImage("apple/Orange.png");
    frames[3] = loadImage("apple/Blue.png");
  }

  void patrol() {
    // if the boolean is true the apple moves right
    if (movingRight){
      x += speed;
      // if the apple is on the right edge the apple no longer moves right
      if(x >= rightEdge){
        movingRight = false;
      }
      // if the apple is no longer moving right it moves to the left
    } else if (!movingRight){
      x -= speed;
      // if the apple reaches the left edge it moves right again
      if (x <= leftEdge){
        movingRight = true;
      }
    }
   
  }

  
  void update() {
    // Gravity
    ySpeed += gravity;
    y += ySpeed;

    Rectangle appleRect = getBounds();

    for (Ground g : allGrounds) {
      Rectangle groundRect = new Rectangle(
        (int) g.pos.x,
        (int) g.pos.y,
        (int) g.area.x,
        (int) g.area.y
        );

      if (appleRect.intersects(groundRect)) {
        y = g.pos.y - h + 1; // Snap apple to ground
        ySpeed = 0;
        break;
      }
    }
    
    for (Platform p : platforms) {
      Rectangle platRect = new Rectangle (
        (int) p.x,
        (int) p.y,
        (int) p.w,
        (int) p.h
      );
      
      if (appleRect.intersects(platRect)) {
        y = p.y - h + 1; // Snap apple to platform
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
    Rectangle appleRect = getBounds();
    for (Ground g : allGrounds) {
      Rectangle groundRect = new Rectangle(
        (int) g.pos.x,
        (int) g.pos.y,
        (int) g.area.x,
        (int) g.area.y
        );
      if (appleRect.intersects(groundRect)) return true;
    }
    return false;
  }

  Rectangle getBounds() {
    return new Rectangle((int) x, (int) y, (int) w, (int) h);
  }
}
