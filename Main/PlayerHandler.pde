// Nathan Ellis 4/10/2025
// THE PLAN IS SIMPLE:
// Finite State Machine with all player states
// Input to switch states
// Separate FSMs for movement and shooting
int maxHealth = 5;
int currentHealth = maxHealth;
boolean invincible = false;
int invincibleStartTime = 0;
int invincibleDuration = 1000; // milliseconds of invincibility

Play worm = new Play(1000, 610, 5); // spawn location
// === Global key states ===
boolean leftHeld = false;
boolean rightHeld = false;
boolean upPressed = false;
boolean downHeld = false;
boolean upAimed = false;
boolean downAimed = false;
boolean leftAimed = false;
boolean rightAimed = false;
String[] lastAim = new String[4];
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
  grass = new Ground(-1000, 625, 10000, 150);
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
  platforms = new Platform [5]; // the amount of platforms we need in the scene (# CAN BE ALTERED)
  for (int i = 0; i<platforms.length; i ++ ) {
    platforms[0] = new Platform(worm.pos.x, worm.pos.y- 50, 440, 20);
    platforms[1] = new Platform(600, 400, 100, 20);
    platforms[2] = new Platform(800, 350, 100, 20);
    platforms[3] = new Platform(1000, 300, 100, 20);
    platforms[4] = new Platform(1200, 250, 100, 20);
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
  }

  // Smooth interpolation toward the target camera position
  camPos.lerp(camTarget, 0.05); // Adjust 0.05 to tweak smoothing

  // Translate the scene to follow the player
  translate(-camPos.x, -camPos.y);
}

class Player {
  float x, y;            // Position of the player
  float w = 40, h = 40;  // Size
  float xSpeed = 5;      // Horizontal speed
  float ySpeed = 0;      // Vertical speed
  float gravity = 0.8;   // Gravity
  float jumpStrength = -15; // Jump power
  boolean left, right;   // Input flags
  boolean canJump = false;  // Flag if player can jump
  String movCurrent = "air"; // "walk" when on ground/platform, "air" when falling

  // Constructor
  Player(float x, float y) {
    this.x = x;
    this.y = y;
  }

  // Rectangle for collision
  Rectangle getBounds() {
    return new Rectangle((int)x, (int)y, (int)w, (int)h);
  }

  void update() {
    // Horizontal movement
    if (left) x -= xSpeed;
    if (right) x += xSpeed;

    // Gravity
    ySpeed += gravity;
    y += ySpeed;

    boolean onSurface = false;  // Whether standing on platform or ground

for (Platform p : platforms) {
  if (getBounds().intersects(p.getBounds())) {
    float playerBottom = y + h;
    float playerTop = y;
    float platformTop = p.y;
    float platformBottom = p.y + p.h;

    // LANDING ON PLATFORM
    if (ySpeed > 0 && playerBottom - ySpeed + 40 <= platformTop && playerBottom >= platformTop) {
      // Player must be falling (ySpeed > 0)
      // and must have already crossed above platform top
      y = platformTop - h;
      ySpeed = 0;
      onSurface = true;
    }
    // HITTING FROM BELOW
    else if (ySpeed < 0 && playerTop <= platformBottom && playerTop - ySpeed >= platformBottom) {
      // Player must be moving upward (ySpeed < 0)
      // and must have crossed below platform bottom
      y = platformBottom;
      ySpeed = 1; // small push downward
    }
  }
}


    // GROUND COLLISION
    for (Ground g : allGrounds) {
      if (getBounds().intersects(g.getBounds())) {
        if (ySpeed >= 0 && y + h <= g.pos.y + 10) {
          y = g.pos.y - h;
          ySpeed = 0;
          onSurface = true;
        }
      }
    }

    // Set movement state
    if (onSurface) {
      canJump = true;
      movCurrent = "walk";
    } else {
      canJump = false;
      movCurrent = "air";
    }
  }

  void display() {
    fill(0);  // Black
    rect(x, y, w, h);
  }

  void jump() {
    if (canJump) {
      ySpeed = jumpStrength;
      canJump = false;
      movCurrent = "air";
    }
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
}
void playSetup() {
  lastAim[0] = "none";
  lastAim[1] = "none";
  lastAim[2] = "none";
  lastAim[3] = "none";
}


// Handling collision and player physics
void playerDraw() {
   boolean foundCollision = false;

for (Platform p : platforms) {
  p.run();

  if (p.intersects()) {
    float playerBottom = player.y + player.h;
    float platformTop = p.y;

    // Ensure the player is falling and close to the platform's top
    if (player.ySpeed > 0 && playerBottom <= platformTop && playerBottom + player.ySpeed > platformTop) {
      // Land on the platform
      player.y = platformTop - player.h;
      player.canJump = true;
      worm.movCurrent = "walk";
      foundCollision = true;
    }
  }
}


  if (!foundCollision) {
    player.canJump = false;
  }

  if (!isColliding) {
    player.ySpeed += 0.5;  // Apply gravity when not colliding
  }

  worm.update();  // Assuming worm is your player object and has an update method

  isColliding = false;  // Reset collision status each frame

  // Handle health and invincibility (if applicable)
  if (apple != null) {
    // Handle collision with apple
    if (!invincible && worm.getBounds().intersects(apple.getBounds())) {
      currentHealth--;
      invincible = true;
      invincibleStartTime = millis();
    }
  }

  // Handle invincibility timer
  if (invincible) {
    if (millis() - invincibleStartTime > invincibleDuration) {
      invincible = false;
    }
  }
}


// === Player class containing the FSMs ===
class Play {
  // instantiate variables
  StringList movStates = new StringList();
  String movCurrent = "walk";
  StringList gunStates  = new StringList();
  String gunCurrent = "ready";
  PVector pos, size;
  float speed, jumpVel, initJump, aimRad, bulletSpeed;
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();
  int bulletCd, fireRate;

  // constructor
  Play(float x, float y, float s) {
    // position
    pos = new PVector(x, y);
    size = new PVector(40, 40);

    // movement variables
    speed = s;
    jumpVel = 0;
    initJump = 15;

    // shooting variables
    aimRad = 0;
    bulletSpeed = 10;

    // fire rate variables (in milliseconds)
    bulletCd = 0;
    fireRate = 150;

    // append states to lists
    movStates.append("walk");
    movStates.append("jump");
    movStates.append("g_dash");
    movStates.append("a_dash");

    gunStates.append("aim");
    gunStates.append("fire");
  }

  // state hub
  void update() {
    rectMode(CENTER);
    noFill();
    stroke(150, 40, 0);

    // firing update
    if (this.gunCurrent == "ready") {
      this.updateReady();
    } else if (this.gunCurrent == "fire") {
      this.updateFire();
    }

    // bullet update
    for (int i=0; i<bullets.size(); i++) {
      // check if the bullet needs to be updated or deleted
      Bullet bullet = bullets.get(i);
      if (millis() - bullet.startTime >= bullet.lifetime) {
        bullets.remove(i);
      } else {

        bullet.update();
      }
    }

    noStroke();
    fill(255, 200, 150);


    // movement update
    if (this.movCurrent == "walk") {
      this.updateWalk();
    } else if (this.movCurrent == "jump") {
      this.updateJump();
    } else if (this.movCurrent == "duck") {
      this.updateDuck();
    } else if (this.movCurrent == "g_dash") {
      // this.updateGDash();
    } else if (this.movCurrent == "a_dash") {
      // this.updateADash();
    } else if (this.movCurrent == "climb") {
      this.updateClimb();
    }
    rectMode(CORNER);
  }

  // walk update code
  void updateWalk() {
    if (leftHeld) {
      this.pos.x -= this.speed;
    }
    if (rightHeld) {
      this.pos.x += this.speed;
    }
    if (upPressed) {
      this.jumpVel = this.initJump;
      this.movCurrent = "jump";
    } else if (downHeld) {
      this.movCurrent = "duck";
    }

    if (!invincible || (millis() / 100) % 2 == 0) {
      rect(this.pos.x, this.pos.y, this.size.x, this.size.y);
    }
  }

  // jump update code
  // jump update code
  void updateJump() {
    this.pos.y -= this.jumpVel;
    this.jumpVel -= 0.5;

    if (leftHeld) {
      this.pos.x -= (this.speed * 0.6);
    }
    if (rightHeld) {
      this.pos.x += (this.speed * 0.6);
    }

    // Use collision detection instead of hardcoded Y
    if (onAnyGround()) {
      this.jumpVel = 0;
      this.movCurrent = "walk";
    }

    if (!invincible || (millis() / 100) % 2 == 0) {
      rect(this.pos.x, this.pos.y, this.size.x * 0.875, this.size.y * 1.125);
    }
  }

  // checks if the player is colliding with any ground
  boolean onAnyGround() {
    Rectangle playerRect = this.getBounds();
    for (Ground g : allGrounds) {
      Rectangle groundRect = new Rectangle(
        (int)g.pos.x,
        (int)g.pos.y + 15,
        (int)g.area.x,
        (int)g.area.y
        );
      if (playerRect.intersects(groundRect)) return true;
    }
    return false;
  }

  // duck update code
  void updateDuck() {
    if (leftHeld) {
      this.pos.x -= (this.speed*0.5);
    }
    if (rightHeld) {
      this.pos.x += (this.speed*0.5);
    }
    if (downHeld == false) {
      this.movCurrent = "walk";
    }

    if (!invincible || (millis() / 100) % 2 == 0) {
      rect(this.pos.x, this.pos.y, this.size.x * 1.125, this.size.y * 0.875);
    }
  }

  // climbing update code
  void updateClimb() {
    if (leftHeld || rightHeld) {
      if (upPressed) {
        this.jumpVel = this.initJump;
      }
      this.movCurrent = "jump";
    } else {
      if (upPressed) {
        this.pos.y -= (this.speed * 0.6);
      }
      if (downHeld) {
        this.pos.y += (this.speed * 0.6);
      }
    }

    if (!invincible || (millis() / 100) % 2 == 0) {
      rect(this.pos.x, this.pos.y, this.size.x, this.size.y);
    }
  }

  // non-firing update code
  void updateReady() {
    // if aiming matrix is activated, enter firing state
    if (lastAim[0] != "none" || lastAim[1] != "none") {
      this.gunCurrent = "fire";
    }
  }

  // firing update code
  void updateFire() {
    // original mouse aiming code, in case the rest of the team sees the light
    // line(this.pos.x, this.pos.y, mouseX, mouseY);

    // new 8-directional aiming code
    // had to change this to use key codes
    // 37-40 are in ascending order: left, up, right, down
    pushMatrix();
    translate(this.pos.x, this.pos.y);
    if (int(lastAim[0]) == 38) {
      if (int(lastAim[1]) == 37) {
        rotate(PI/-4); // rotate matrix (for aiming visuals)
        this.aimRad = PI*1.75; // set value of aim direction (for bullets)
      } else if (int(lastAim[1]) == 39) {
        rotate(PI/4);
        this.aimRad = PI/4;
      } else {
        this.aimRad = 0;
      }
    } else if (int(lastAim[1]) == 37) {
      rotate(PI/-2);
      this.aimRad = PI*1.5;
      if (int(lastAim[0]) == 40) {
        rotate(PI/-4);
        this.aimRad = PI*1.25;
      }
    } else if (int(lastAim[1]) == 39) {
      rotate(PI/2);
      this.aimRad = PI/2;
      if (int(lastAim[0]) == 40) {
        rotate(PI/4);
        this.aimRad = PI*0.75;
      }
    } else if (int(lastAim[0]) == 40) {
      rotate(PI);
      this.aimRad = PI;
    }
    line(0, 0, 0, -70); // visual aiming line - this is the only reason i push matrix
    popMatrix();

    // check if bullet cooldown has elapsed
    if (millis() - this.bulletCd >= this.fireRate) {
      bullets.add(new Bullet(this.aimRad, this.bulletSpeed, this.pos));
      this.bulletCd = millis();
    }

    // if no keys are pressed, exit this state
    if (lastAim[0] == "none" && lastAim[1] == "none") {
      this.gunCurrent = "ready";
    }
  }

  // Return the bounding box of the player (used for collision detection)
  Rectangle getBounds() {
    return new Rectangle((int)this.pos.x, (int)this.pos.y,
      (int)this.size.x, (int)this.size.y);
  }
}

// player-specific keyPressed actions
void aimKeyPressed() {
  // activate aiming key array
  if ((keyCode == UP || keyCode == DOWN) && int(lastAim[0]) != keyCode) {
    // add previous key code at index 2 (prev up/down index)
    lastAim[2] = lastAim[0];
    // add newest key code at index 0 (designated up/down index)
    lastAim[0] = str(keyCode);
  }
  if ((keyCode == LEFT || keyCode == RIGHT) && int(lastAim[1]) != keyCode) {
    // add previous key code at index 2 (prev up/down index)
    lastAim[3] = lastAim[1];
    // add newest key code at index 1 (designated left/right index)
    lastAim[1] = str(keyCode);
  }
  // print("(" + lastAim[0] + ", " + lastAim[2] + ")");
}

// player-specific keyReleased actions
void aimKeyReleased() {
  // deactivate spaces in aiming key array
  if (keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT) {
    // find key code for the key released and remove it
    for (int i=0; i<lastAim.length; i++) {
      if (int(lastAim[i]) == keyCode) lastAim[i] = "none";
    }
    // fill missing indexes with their previous values
    if (lastAim[0] == "none") {
      lastAim[0] = lastAim[2];
      lastAim[2] = "none";
    }
    if (lastAim[1] == "none") {
      lastAim[1] = lastAim[3];
      lastAim[3] = "none";
    }
  }
}
