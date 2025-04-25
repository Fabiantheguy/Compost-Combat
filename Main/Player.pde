/*
 This tab features a simple player that is to be used for testing enemies.
 The player can move left, right, and jump, and is affected by gravity.
 */
Player player;

// Camera Variables
PVector camPos;
PVector camTarget;

void playerSetup() {
  player = new Player(width/15, height - 150);
  grass = new Ground(-1000, 1165, 10000, 1100);
  sun = new Sun(width - 255, 50);
  tree = new Tree(width, -1880, 200, 5000);
  camPos = new PVector(0, 0);
  camTarget = new PVector(0, 0);
  allGrounds.add(grass);
  v = new Vine [5];
  for (int i = 0; i < v.length; i++) {
    v[0] = new Vine(width - 300, 480, 75, 500);
    v[1] = new Vine(width - 500, -80, 75, 471);
    v[2] = new Vine(width - 500, 980, 75, 500);
    v[3] = new Vine(width - 500, 980, 75, 500);
    v[4] = new Vine(width - 500, 980, 75, 500);
  }
  // SETTING UP LEVEL 2 PLATFORMS & VINES
  //if (Level2) {
  p = new Platform [0]; // the amount of platforms we need in the scene (# CAN BE ALTERED)
  for (int i =0; i<p.length; i ++ ) {
    p[0] = new Platform (1480, 430, 440, platformSize/3);
    p[1] = new Platform (platformPOS.x + (i * platformDist.x), platformPOS.y, platformSize, platformSize/3);
    p[2] =new Platform (platformPOS.x + (i * platformDist.x *2), platformPOS.y + (i * platformDist.y), platformSize, platformSize/3);
    p[3] = new Platform (platformPOS.x + (i * platformDist.x*3), platformPOS.y + (i * platformDist.y * 2), platformSize, platformSize/3);
    p[4] =new Platform (platformPOS.x + (i * platformDist.x*4), platformPOS.y + (i * platformDist.y/2), platformSize, platformSize/3);
  }
  //IN PROGRESS
  vines = new Vines [3]; // the amount of vines we need in the scene (# CAN BE ALTERED)
  for (int i =0; i<vines.length; i ++ ) {
    vines[0] = new Vines (vinesPOS.x, vinesPOS.y, vinesPOS.x, length);
    vines[1] = new Vines (vinesPOS.x + (i * 400), vinesPOS.y, vinesPOS.x + (i * 400), length);
    vines[2] =new Vines (vinesPOS.x + (i * 800), vinesPOS.y, vinesPOS.x +(i * 800), length);
  }
  //}
}
// Handle key press events to control the player movement
void movementKeyPressed() {
  // If 'A' or 'a' is pressed, move the player left
  if (key == 'a' || key == 'A') {
    player.left = true;
    leftHeld = true;
  }
  // If 'D' or 'd' is pressed, move the player right
  if (key == 'd' || key == 'D') {
    player.right = true;
    rightHeld = true;
  }
  if (key == 's' || key == 'S') {
    downHeld = true;
  }
  // If spacebar is pressed and the player is on the platform, make the player jump
  if (key == 'w' || key == 'W') {
    player.jump();
    upPressed = true;
  }
}

// Handle key release events to stop the player movement
void movementKeyReleased() {
  // If 'A' or 'a' is released, stop the left movement
  if (key == 'a' || key == 'A') {
    player.left = false;
    leftHeld = false;
  }
  // If 'D' or 'd' is released, stop the right movement
  if (key == 'd' || key == 'D') {
    player.right = false;
    rightHeld = false;
  }
  if (key == 's' || key == 'S') {
    downHeld = false;
  }
  if (key == 'w' || key == 'W') {
    upPressed = false;
  }
}

void cameraDraw() {
  // When player is near left edge camera stays into center of frame
  if (player.x <= 50.0) {
    camTarget.set(grass.pos.x, player.y - height/2 + player.h/2 - 400);
  } else {
    camTarget.set(player.x - width/2 + player.w/2, player.y - height/2 + player.h/2 - 400);
  }

  // When player is near right edge camera stays into center of frame
  if (player.x >= 3000) {
    camTarget.set(grass.area.y - 1050, worm.pos.y - height/2 - 400);
  } else {
    camTarget.set(worm.pos.x - width/2, worm.pos.y - height/2 - 400);
    println(player.h/2);  
  }

  // Smooth interpolation toward the target camera position
  camPos.lerp(camTarget, 0.05); // Adjust 0.05 to tweak smoothing

  // Translate the scene to follow the player
  translate(-camPos.x, -camPos.y);
  pushMatrix();
}
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
    //if (left) x -= xSpeed;

    //// Move the player right if the 'right' flag is true
    //if (right) x += xSpeed;

    // Apply gravity to the player's vertical speed
    ySpeed += gravity;

    // Update the player's vertical position
    y += ySpeed;

    // Check if the player is on the platform (to prevent falling through)
    if (onGround(grass)) {
      // Stop falling and place the player on top of the platform
      y = grass.pos.y - h;
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

  void climb() {
    y += 2;
  }
  // Reset the player's position and state when they respawn
  void respawn() {
    x = width / 2;        // Place the player in the center of the screen horizontally
    y = height - 150;     // Place the player just above the platform vertically
    left = false;         // Reset the left movement flag
    right = false;        // Reset the right movement flag

    ySpeed = 0;
  }

  // Check if the player is standing on the platform (to avoid falling through)
  boolean onGround(Ground g) {
    // Returns true if the player's bottom is just above the platform
    return (y + h >= g.pos.y && y + h <= g.pos.y + 10 && x + w > g.pos.x && x < g.pos.x + g.area.x);
  }

  // Return the bounding box of the player (used for collision detection)
  Rectangle getBounds() {
    return new Rectangle((int)x, (int)y, (int)w, (int)h);
  }
}
