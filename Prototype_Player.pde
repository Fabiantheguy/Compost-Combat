/* 
  This tab features a simple player that is to be used for testing enemies.
  The player can move left, right, and jump, and is affected by gravity.
*/
Player player;

class Player {
  float x, y;            // Position of the player (x, y)
  float w = 40, h = 40;  // Size of the player (width, height)
  float xSpeed = 5;      // Speed at which the player moves left/right
  float ySpeed = 0;      // Vertical speed, which is affected by gravity
  float gravity = 0.8;   // Gravity force that pulls the player down
  float jumpStrength = -15; // Strength of the jump (negative for upward motion)
  boolean left, right;   // Flags to indicate if the player is moving left or right

  // Constructor to initialize the player's position
  Player(float x, float y) {
    this.x = x;
    this.y = y;
  }

  // Update the player's movement based on the current speed and gravity
  void update() {
    // Move the player left if the 'left' flag is true
    if (left) x -= xSpeed;
    
    // Move the player right if the 'right' flag is true
    if (right) x += xSpeed;

    // Apply gravity to the player's vertical speed
    ySpeed += gravity;
    
    // Update the player's vertical position
    y += ySpeed;

    // Check if the player is on the platform (to prevent falling through)
    if (onGround(applePlatform)) {
      // Stop falling and place the player on top of the platform
      y = applePlatform.y - h;
      ySpeed = 0;  // Stop vertical movement (no gravity effect while on the ground)
    }
  }

  // Display the player as a black rectangle
  void display() {
    fill(0);  // Set the color to black
    rect(x, y, w, h);  // Draw the player as a rectangle
  }

  // Make the player jump by setting the vertical speed to a negative value
  void jump() {
    ySpeed = jumpStrength;  // Apply the jump strength to move the player upwards
  }

  // Reset the player's position and state when they respawn
  void respawn() {
    x = width / 2;        // Place the player in the center of the screen horizontally
    y = height - 150;     // Place the player just above the platform vertically
    left = false;         // Reset the left movement flag
    right = false;        // Reset the right movement flag
    apple.x = 50;         // Reset the enemy (apple) to its initial position
  }

  // Check if the player is standing on the platform (to avoid falling through)
  boolean onGround(ApplePlatform p) {
    // Returns true if the player's bottom is just above the platform
    return (y + h >= p.y && y + h <= p.y + 10 && x + w > p.x && x < p.x + p.w);
  }
  
  // Return the bounding box of the player (used for collision detection)
  Rectangle getBounds() {
    return new Rectangle((int)x, (int)y, (int)w, (int)h);
  }
}
