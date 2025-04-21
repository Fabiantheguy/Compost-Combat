// Secluded variables for the enemy (Apple), and platform
Apple apple;
ApplePlatform applePlatform;
PImage appleImage;


// Initialize the Apple and platform objects
void AppleSetup() {
  // Create the apple object at a specific location
  apple = new Apple(width/4, height - 150);
  appleImage = loadImage("Apple.png");
  // Create the platform at the bottom of the screen
  applePlatform = new ApplePlatform(0, height - 100, width, 20);
}

// Main drawing function to update and display all elements of this enemy
void AppleDraw() {
  // Set the background color to blue
  background(0,0,255);
  
  // Display the platform 
  applePlatform.display();
  
  // Make the apple follow the player and update its position
  apple.follow(player);
  apple.update();
  apple.display();
  
  // Check if the apple collides with the player; if so, respawn the player
  if (apple.collidesWith(player)) {
    println("You were caught! Respawning...");
    player.respawn(); // Call the respawn method when the player is caught
  }
}

class Apple {
  float x, y;               // Position
  float w = 40, h = 40;     // Size
  float speed = 3;
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

  void follow(Player player) {
    if (player.x < x - 1) x -= speed;
    else if (player.x > x + 1) x += speed;
  }

  void update() {
    // Gravity & movement
    ySpeed += gravity;
    y += ySpeed;

    if (onGround(applePlatform)) {
      y = applePlatform.y - h;
      ySpeed = 0;
    }

    // Animation timer
    frameTimer++;
    if (frameTimer >= frameInterval) {
      frameTimer = 0;
      currentFrame = (currentFrame + 1) % frames.length;
    }
  }

  void display() {
    image(frames[currentFrame], x - 20, y - 30, 80, 80);
  }

  boolean onGround(ApplePlatform p) {
    return (y + h >= p.y && y + h <= p.y + 10 && x + w > p.x && x < p.x + p.w);
  }

  Rectangle getBounds() {
    return new Rectangle((int)x, (int)y, (int)w, (int)h);
  }

  boolean collidesWith(Player p) {
    return getBounds().intersects(p.getBounds());
  }
}




// Class for the Platform (where the player can stand)
class ApplePlatform {
  float x, y, w, h;  // Position and size of the platform

  // Constructor to initialize the platform
  ApplePlatform(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  // Display the platform (green color)
  void display() {
    fill(0, 255, 0);  // Green color
    rect(x, y, w, h); // Draw the platform as a rectangle
  }
}
