// ===========================
// Banana Enemy + Bullet Logic
// ===========================

// Global references to Banana enemy and its bullet
Banana banana;
bananaBullet bananabullet;

// Placeholder for Banana sprite sheet
PImage bananaImage;

// Respawn management (optional)
// int respawnTime = 3000;         // 3 seconds delay before respawn
// int lastDestroyedTime = -1;     // Track when the banana died

// ===========================
// Initialization
// ===========================

void BananaSetup() {
  // Load the full sprite sheet for Banana (1 row, 6 columns)
  PImage sheet = loadImage("Enemy Sprites/Banana.png");
  
  int cols = 6;  // Number of animation columns (frames)
  int rows = 1;  // Only one row
  int frameW = sheet.width / cols;
  int frameH = sheet.height / rows;

  // Slice the sprite sheet into individual frames
  PImage[] bananaFrames = new PImage[cols];
  for (int i = 0; i < cols; i++) {
    bananaFrames[i] = sheet.get(i * frameW, 0, frameW, frameH);
  }

  // Create the Banana enemy using a factory
  EnemyFactory factory = new EnemyFactory();
  banana = (Banana) factory.createEnemy("Banana", width / 4, height - 500, bananaFrames);
}

// ===========================
// Banana Draw Cycle
// ===========================

void BananaDraw() {
  if (banana == null) {
    // If the banana has been destroyed
    if (lastDestroyedTime < 0) {
      lastDestroyedTime = millis(); // Start the respawn timer
    }
    if (millis() - lastDestroyedTime > respawnTime) {
      // Time to respawn (you can re-initialize banana here)
      // banana = new Banana(...); 
      lastDestroyedTime = -1;
    }
  } else {
    // If banana is alive, update and display it
    banana.update();
    banana.display();
  }

  // If bullet exists, update and display it
  if (bananabullet != null) {
    bananabullet.update();
    bananabullet.display();
  }
}

// ===========================
// Banana Enemy Class
// ===========================

class Banana extends Enemy {
  float speed = 1;
  float ySpeed = 0;
  float gravity = 0.8;

  PImage[] frames;         // Animation frames
  int currentFrame = 0;    // Current animation frame
  int frameTimer = 0;      // Frame timing counter
  int frameInterval = 10;  // Frame switch rate

  boolean bananaShot = false; // Only shoot once

  Banana(float x, float y, EnemyType type, PImage[] availableImages) {
    super(x, y, type, availableImages); // Call superclass
    frames = availableImages;
  }

  // Optional: Follows the player horizontally
  void follow(Play player) {
    if (player.pos.x < x - 1) x -= speed;
    else if (player.pos.x > x + 1) x += speed;
  }

  void update() {
    // Apply gravity
    ySpeed += gravity;
    y += ySpeed;

    Rectangle bananaRect = getBounds();

    // Shoot banana bullet only once
    if (!bananaShot) {
      bananabullet = new bananaBullet(width / 4, worm.pos.y - 100);
      bananaShot = true;
    }

    // Collision detection with ground
    for (Ground g : allGrounds) {
      Rectangle groundRect = new Rectangle(
        (int) g.pos.x,
        (int) g.pos.y,
        (int) g.area.x,
        (int) g.area.y
      );

      if (bananaRect.intersects(groundRect)) {
        y = g.pos.y - h + 1; // Snap to ground
        ySpeed = 0;
        break;
      }
    }

    // Handle animation cycling
    frameTimer++;
    if (frameTimer >= frameInterval) {
      frameTimer = 0;
      currentFrame = (currentFrame + 1) % frames.length;
    }
  }

  void display() {
    // Draw current animation frame
    image(frames[currentFrame], x - 20, y - 30, 80, 80);
  }

  // Check if banana is standing on any platform
  boolean onAnyGround() {
    Rectangle bananaRect = getBounds();
    for (Ground g : allGrounds) {
      Rectangle groundRect = new Rectangle(
        (int) g.pos.x,
        (int) g.pos.y,
        (int) g.area.x,
        (int) g.area.y
      );
      if (bananaRect.intersects(groundRect)) return true;
    }
    return false;
  }

  // Get the bounding box for collision
  Rectangle getBounds() {
    return new Rectangle((int) x, (int) y, (int) w, (int) h);
  }
}

// ===========================
// Banana Bullet Class
// ===========================

class bananaBullet {
  float x, y;
  float speed = 18;

  bananaBullet(float X, float Y) {
    x = X;
    y = Y;
  }

  void update() {
    // Move bullet to the right
    x += speed;
  }

  void display() {
    // Draw bullet as a simple rectangle
    rect(x, y, 10, 10);
  }

  Rectangle getBounds() {
    return new Rectangle((int) x, (int) y, 10, 10);
  }
}
