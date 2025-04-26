// Secluded variables for the enemy (Apple), and platform //<>//
Apple apple;

PImage appleImage;

int respawnTime = 3000; // 3 seconds to respawn the apple
int lastDestroyedTime = -1; // -1 means no apple has died yet

// Initialize the Apple and platform objects
void appleSetup() {
  appleImage = loadImage("Apple.png");
  apple = new Apple(width / 4, worm.pos.y - 100);
}

void appleDraw() {
  if (apple == null) {
    // Apple is dead
    if (lastDestroyedTime < 0) {
      // Timer hasn't started yet — start it now
      lastDestroyedTime = millis();
    }
    // Check if enough time has passed to respawn
    if (millis() - lastDestroyedTime > respawnTime) {
      apple = new Apple(width / 4, worm.pos.y - 100);
      lastDestroyedTime = -1; // Reset timer
    }
  } else {
    // Apple is alive
    apple.follow(worm);
    apple.update();
    apple.display();
  }
}


// Apple class
class Apple {
  float x, y;               // Position
  float w = 40, h = 40;     // Size
  float speed = 1;
  float ySpeed = 0;
  float gravity = 0.8;

  PImage[] frames;          // Array of animation frames
  int currentFrame = 0;     // Index of current frame
  int frameTimer = 0;       // Used to time switching frames
  int frameInterval = 10;   // Change frame every 10 draw() calls

  Apple(float x, float y) {
    this.x = x;
    this.y = y;

    // Load the four frames (make sure these files are in your "data" folder)
    frames = new PImage[4];
    frames[0] = loadImage("apple/Red.png");
    frames[1] = loadImage("apple/Teal.png");
    frames[2] = loadImage("apple/Orange.png");
    frames[3] = loadImage("apple/Blue.png");
  }

  void follow(Play player) {
    if (player.pos.x < x - 1) x -= speed;
    else if (player.pos.x > x + 1) x += speed;
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
