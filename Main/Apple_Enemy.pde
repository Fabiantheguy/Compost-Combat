// Secluded variables for the enemy (Apple), and platform //<>// //<>// //<>//
Apple apple;

PImage appleImage;

int respawnTime = 3000; // 3 seconds to respawn the apple
int lastDestroyedTime = -1; // -1 means no apple has died yet

// Initialize the Apple objects


void appleDraw() {
  if (apple == null) {
    // Apple is dead
    if (lastDestroyedTime < 0) {
      // Timer hasn't started yet — start it now
      lastDestroyedTime = millis();
    }
    // Check if enough time has passed to respawn
    if (millis() - lastDestroyedTime > respawnTime) {
      // apple = new Apple(width / 4, worm.pos.y - 100);
      lastDestroyedTime = -1; // Reset timer
    }
  } else {
    // Apple is alive
    apple.patrol();
    apple.update();
    apple.display();
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
  boolean movingRight = true; // detects if apple is moving right
  Platform platform;

  Apple(float x, float y, EnemyType type, PImage[] availableImages, Platform platform) {
    super(x, y, type, availableImages); // Initialize Enemy superclass
    frames = availableImages;
    this.platform = platform;
    this.leftEdge = platform.x;
    this.rightEdge = platform.x + platform.w;
  }

  void patrol() {
    // if the boolean is true the apple moves right

    if (movingRight) {
      x += speed;
      // if the apple is on the right edge the apple no longer moves right
      if (x >= rightEdge) {
        movingRight = false;
      }
      // if the apple is no longer moving right it moves to the left
    } else if (!movingRight) {
      x -= speed;
      // if the apple reaches the left edge it moves right again
      if (x <= leftEdge) {
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
