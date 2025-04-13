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

// Class for the Apple (enemy) object
class Apple {
  float x, y;        // Position of the apple
  float w = 40, h = 40;  // Size of the apple
  float speed = 3;        // Speed of the apple
  float ySpeed = 0;       // Vertical speed for gravity
  float gravity = 0.8;    // Gravity effect

  // Constructor to initialize the apple's position
  Apple(float x, float y) {
    this.x = x;
    this.y = y;
  }

  // Make the apple follow the player left and right
  void follow(Player player) {
    if (player.x < x - 1) x -= speed;  // Move left
    else if (player.x > x + 1) x += speed;  // Move right
  }

  // Update the apple's vertical position with gravity
  void update() {
    ySpeed += gravity;  // Apply gravity
    y += ySpeed;        // Move the apple down

    // Check if the apple is on the platform
    if (onGround(applePlatform)) {
      y = applePlatform.y - h;  // Position the apple on top of the platform
      ySpeed = 0;               // Stop vertical movement (no gravity effect)
    }
  }

  // Display the apple (red color)
  void display() {
    fill(255, 0, 0);  // Red color
    image(appleImage, x - 13, y - 25, 75, 75);
  }

  // Check if the apple is on the platform
  boolean onGround(ApplePlatform p) {
    return (y + h >= p.y && y + h <= p.y + 10 && x + w > p.x && x < p.x + p.w);
  }
  
  // Return the bounding box of the apple for collision detection
  Rectangle getBounds() {
    return new Rectangle((int)x, (int)y, (int)w, (int)h);
  }

  // Check if the apple collides with the player using their bounding boxes
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
