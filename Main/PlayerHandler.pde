// Nathan Ellis 4/10/2025 //<>// //<>// //<>// //<>// //<>//
// THE PLAN IS SIMPLE:
// Finite State Machine with all player states
// Input to switch states
// Separate FSMs for movement and shooting
int maxHealth = 5;
int currentHealth = maxHealth;
boolean invincible = false;
int invincibleStartTime = 0;
int invincibleDuration = 1000; // milliseconds of invincibility
ArrayList<Item> items = new ArrayList<Item>();

Play worm = new Play(1000, 580, 5); // spawn location

// === Global key states ===
boolean leftHeld = false;
boolean rightHeld = false;
boolean upPressed = false;
boolean downHeld = false;
boolean upAimed = false;
boolean downAimed = false;
boolean leftAimed = false;
boolean rightAimed = false;
boolean spacePressed = false;
boolean movPressed = false; // for dirty flag
String[] lastAim = new String[4];
boolean onSurface = false;  // Whether standing on platform or ground
int[] movKeyCodes = {87, 65, 83, 68, 32}; // all key codes used in movement

/*
 This tab features a simple player that is to be used for testing enemies.
 The player can move left, right, and jump, and is affected by gravity.
 */
Player player;

// Camera Variables
PVector camPos;
PVector camTarget;

// sprite arrays for the worm's animation cycles
PImage[] wormWalk;
PImage[] wormJump;
PImage[] wormDuck;
PImage[] wormClimb;
PImage[] wormDash;

void playerSetup() {
  player = new Player(width/15, height - 150);
  grass = new Ground(-1000, 625, 10000, 150);
  tree = new Tree [2];
  for (int i = 0; i < tree.length; i ++) {
    tree[i] = new Tree(width, -1880, 200, 5000);
  }
  // gonna figure out initial camera position stuff later -nate

  camPos = new PVector(0, 0);
  camTarget = new PVector(0, 0);
 
  // camPos = new PVector(width - 1200, -740);
  // camTarget = new PVector(width - 1200, -740);
  allGrounds.add(grass);
  if (!Level2){
  items.add(new Item(width - 750, 65, ItemType.HEALTH));
  items.add(new Item(700, 600, ItemType.FIRERATE));
  }
  if (Level2){
     items.add(new Item(width - 750, 65, ItemType.HEALTH));
    items.add(new Item(700, 600, ItemType.FIRERATE));
  }
  //}
}
// Handle key press events to control the player movement
void movementKeyPressed() {
  // If 'A' or 'a' is pressed, move the player left
  if (key == 'a' || key == 'A') {
    if (!leftHeld) worm.dirtyMomentum = true; // when held bool changes, dirty flag turns on
    player.left = true;
    leftHeld = true;
    worm.facingRight = false;
  }
  // If 'D' or 'd' is pressed, move the player right
  if (key == 'd' || key == 'D') {
    if (!rightHeld) worm.dirtyMomentum = true; // when held bool changes, dirty flag turns on
    player.right = true;
    rightHeld = true;
    worm.facingRight = true;
  }
  if (key == 's' || key == 'S') {
    if (!downHeld) worm.dirtyMomentum = true; // when held bool changes, dirty flag turns on
    downHeld = true;
  }
  // If w is pressed and the player is on the platform, make the player jump
  if (key == 'w' || key == 'W') {
    if (!upPressed) worm.dirtyMomentum = true; // when held bool changes, dirty flag turns on
    player.jump();
    upPressed = true;
  }
  if (keyCode == 32) {
    spacePressed = true;
  }
  /*
  if (!Level2) {
   for (int i = 0; i < v.length; i++) {
   if (key == 'w' && v[i].isOnVine) {
   player.climb();
   println("demon");
   }
   }
   }
   */

  // temp cheat code to upgrade dash (1 key)
  if (keyCode == 49) {
    if (worm.upgrades.get("dash") < 2) {
      worm.upgrades.add("dash", 1);
      worm.dashCd -= 400; // level 1 dash has a 0.8 second cooldown, level 2 dash has a 0.4 second cooldown
    } else {
      worm.upgrades.set("dash", 0);
      worm.dashCd = 1200;
    }
  }
  // temp cheat code to upgrade range (2 key)
  if (keyCode == 50) {
    if (worm.upgrades.get("range") < 2) {
      worm.upgrades.add("range", 1);
      worm.bulletLife += 350;
    } else {
      worm.upgrades.set("range", 0);
      worm.bulletLife = 700;
    }
  }
  // temp cheat code to upgrade agility (3 key)
  if (keyCode == 51) {
    if (worm.upgrades.get("agility") < 2) {
      worm.upgrades.add("agility", 1);
      worm.speed += 1;
    } else {
      worm.upgrades.set("agility", 0);
      worm.speed = 5;
    }
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
  if (key == 'w' || key == 'W' ) {
    upPressed = false;
  }
  if (keyCode == 32) {
    spacePressed = false;
  }

  // activates dirty flag if any movement key is pressed
  for (int val : movKeyCodes) {
    if (keyCode == val) {
      worm.dirtyMomentum = true;
      break;
    }
  }
}

void cameraDraw() {
  // When player is near left or right edge camera stays in center of frame
  if (worm.pos.x <= -600.0) {
    camTarget.set(-600, worm.pos.y - height/2 - 400);
  } else if (worm.pos.x >= 3000) {
    camTarget.set(3000 - 1050, worm.pos.y - height/2 - 400);
  } else if (Level2) {
    camTarget.set(worm.pos.x - width/2, worm.pos.y - height/2);
  }else {
    camTarget.set(worm.pos.x - width/2, worm.pos.y - height/2 - 400 );
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
  //Rectangle getBounds() {
  //  return new Rectangle((int)x, (int)y, (int)w, (int)h);
  //}

  void update() {
    // Horizontal movement
    if (left) x -= xSpeed;
    if (right) x += xSpeed;

    // Gravity
    ySpeed += gravity;
    y += ySpeed;


    //for (Platform p : platforms) {
    //  {
    //    float playerBottom = y + h;
    //    float playerTop = y;
    //    float platformTop = p.y;
    //    float platformBottom = p.y + p.h;

    //    // LANDING ON PLATFORM
    //    if (ySpeed > 0 && playerBottom - ySpeed + 40 <= platformTop && playerBottom >= platformTop) {
    //      // Player must be falling (ySpeed > 0)
    //      // and must have already crossed above platform top
    //      y = platformTop - h;
    //      ySpeed = 0;
    //      onSurface = true;
    //    }
    //    // HITTING FROM BELOW
    //    else if (ySpeed < 0 && playerTop <= platformBottom && playerTop - ySpeed >= platformBottom) {
    //      // Player must be moving upward (ySpeed < 0)
    //      // and must have crossed below platform bottom
    //      y = platformBottom;
    //      ySpeed = 1; // small push downward
    //    }
    //  }
    //}


    // GROUND COLLISION
    //for (Ground g : allGrounds) {
    //  if (getBounds().intersects(g.getBounds())) {
    //    if (ySpeed >= 0 && y + h <= g.pos.y + 10) {
    //      y = g.pos.y - h;
    //      ySpeed = 0;
    //      onSurface = true;
    //    }
    //  }
    //}

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
  // clear last aim array
  lastAim[0] = "none";
  lastAim[1] = "none";
  lastAim[2] = "none";
  lastAim[3] = "none";
  
  // set up worm image arrays
  wormWalk = new PImage[2];
  wormJump = new PImage[1];
  wormDuck = new PImage[1];
  wormClimb = new PImage[2];
  wormDash = new PImage[1];
  
  // add images to arrays
  wormWalk[0] = loadImage("worm/W1.png");
  wormWalk[1] = loadImage("worm/W2.png");
  wormJump[0] = loadImage("worm/W6.png");
  wormDuck[0] = loadImage("worm/W5.png");
  wormClimb[0] = loadImage("worm/W1.png");
  wormClimb[1] = loadImage("worm/W6.png");
  wormDash[0] = loadImage("worm/W3.png");
}


// Handling collision and player physics
void playerDraw() {
  worm.update();  // Assuming worm is your player object and has an update method
  for (Item i : items) {
    i.update();
    i.display();
    i.checkPickup(worm);
  }
  //for (Platform p : platforms) {
  //  p.update();
  //  p.display();
  //  if (isOnTop) {
  //  }


  //  // Check for collision with platform
  //  if (isOnTop) {
  //    isColliding = true;
  //    print(player.canJump);

  //    worm.movCurrent = "walk";
  //    player.canJump = true;
  //    player.y = p.y - player.h; // Place player on top of platform
  //  }
  //}

  //if (!isColliding) {
  //  player.ySpeed += 0.5;  // Apply gravity when not colliding
  //}


  //isColliding = false;  // Reset collision status each frame


  // Handle health and invincibility (if applicable)
  if (apple != null) {
    for (Apple currentApple : apple) {
      // Handle collision with apple
      if (!invincible && worm.getBounds().intersects(currentApple.getBounds()) && currentApple.hitPoints > 0) {
        worm.takeDmg(1);
      }
    }
  }

  if (orange != null) {
    // Handle collision with orange
    for (Orange currentOrange : orange) {
      if (!invincible && worm.getBounds().intersects(currentOrange.getBounds())) {
        currentOrange.orangeStun();
        worm.takeDmg(3);
      }
    }
  }
 
  if (banana != null) {
    // iterate over banana array
    for (Banana currentBanana : banana) {
      // Handle collision with banana's bullet
      if (!invincible && worm.getBounds().intersects(currentBanana.bullet.getBounds()) && currentBanana.bullet.active) {
        // maybe add a reload function to the banana? idk
        worm.takeDmg(2);
        currentBanana.bullet.active = false;
      }
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
  String movCurrent = "walk";
  String gunCurrent = "ready";
  PVector pos, size, center;
  float speed, jumpVel, initJump, aimRad, bulletSpeed, momentumX, momentumY;
  int bulletCd, fireRate, bulletLife;
  int baseFireRate = 150;
  int boostEndTime = 0;
  boolean boosted = false, dirtyMomentum = true, dashActive = false, facingRight = true;
  int currentFrame = 0, frameInc = 0; // for animation
  int dashStart = 0;
  int dashTime = 200; // milliseconds
  int dashCd = 1200; // milliseconds
  // int test = 0; // temporary while i test dirty flag -nate

  // instantiate complex data
  IntDict upgrades; // instantiate upgrade dictionary
  HashMap<String, PlayerState> stateMap; // A HashMap to hold all the possible states.
  PlayerState currentState; // player's current state
  Vine currentVine; // current vine that the entire play class can access, trust me i need this -nate
  BulletPool bPool = new BulletPool(); // object pool for the player's bullets

  // constructor
  Play(float x, float y, float s) {
    // position
    pos = new PVector(x, y);
    size = new PVector(40, 40);
    center = new PVector(pos.x + (size.x/2), pos.y + (size.y/2));
    momentumX = 0;
    momentumY = 0;

    // Create a HashMap to store different movement states
    stateMap = new HashMap<String, PlayerState>();
    // Instantiate and store various player states
    // These states must be defined elsewhere as classes implementing PlayerState
    stateMap.put("walk", new WalkState());
    stateMap.put("jump", new JumpState());
    stateMap.put("duck", new DuckState());
    stateMap.put("climb", new ClimbState());
    stateMap.put("dash", new DashState());
    stateMap.put("ready", new ReadyState());
    stateMap.put("fire", new FiringState());

    // Set the initial state.
    currentState = stateMap.get("walk");

    // movement variables
    speed = s;
    jumpVel = 0;
    initJump = 12;

    // shooting variables
    aimRad = 0;
    bulletSpeed = 10;
    bulletLife = 700;

    // fire rate variables (in milliseconds)
    bulletCd = 0;
    fireRate = baseFireRate;

    // set upgrade levels
    upgrades = new IntDict();
    upgrades.set("dash", 0); // this will eventually pull int values from save data
    upgrades.set("range", 0); // increases range of bullets
    upgrades.set("agility", 0); // increases speed
  }

  // state hub
  void update() {
    center.x = pos.x + (size.x/2);
    center.y = pos.y + (size.y/2); // to replace rectMode(CENTER);
    noFill();
    stroke(150, 40, 0);
    strokeWeight(6);
    // firing update
    if (this.gunCurrent == "ready") {
      stateMap.get("ready").update(this);
      stateMap.get("ready").display(this);
    } else if (this.gunCurrent == "fire") {
      stateMap.get("fire").update(this);
      stateMap.get("fire").display(this);
    }
    if (boosted && millis() > boostEndTime) {
      fireRate = baseFireRate;
      boosted = false;
    }

    if (boosted) {
      float remaining = boostEndTime - millis();
      float maxDuration = 5000.0;
      float pct = constrain(remaining / maxDuration, 0, 1);

      noStroke();
      fill(0, 0, 255, 180); // Blue bar
      float barWidth = size.x * pct;
      rect(pos.x, pos.y - 30, barWidth, 5);
    }

    // bullet update
    for (Bullet bullet : bPool.allBullets) {
      // check if the bullet needs to be updated or deleted
      if (bullet.active) {
        if (millis() - bullet.startTime >= bullet.lifetime) {
          bullet.destroy();
        } else {
          bullet.update();
        }
      }
    }
    
    // dash cooldown check - nested if statements are to make sure it doesn't check the complicated stuff if the simple stuff isn't true
    if(upgrades.get("dash") > 0 && !dashActive){
      if(millis() - dashStart >= dashCd){
        dashActive = true;
      }
    }

    noStroke();
    fill(255, 200, 150);
    //rect(this.pos.x, this.pos.y, this.size.x, this.size.y);

    // movement update
    if (this.movCurrent == "walk") {
      stateMap.get("walk").update(this);
      stateMap.get("walk").display(this);
    } else if (this.movCurrent == "jump") {
      stateMap.get("jump").update(this);
      stateMap.get("jump").display(this);
    } else if (this.movCurrent == "duck") {
      stateMap.get("duck").update(this);
      stateMap.get("duck").display(this);
    } else if (this.movCurrent == "dash") {
      stateMap.get("dash").update(this);
      stateMap.get("dash").display(this);
    } else if (this.movCurrent == "climb") {
      stateMap.get("climb").update(this);
      stateMap.get("climb").display(this);
    }

    rectMode(CORNER);
    
    // increment animation
    frameInc++;
    if (frameInc >= 10){
      currentFrame++;
      frameInc = 0;
    }
  }
  void takeDmg(int l) {
    currentHealth -= l;
    // die if health is 0, start invincibility timer otherwise
    if (currentHealth <= 0) {
      //enter death screen
      level1Music.stop();
      endScreen();
      // player death code
      playerDeath();
    } else {
      invincible = true;
      invincibleStartTime = millis();
    }
  }

  // checking for vine to climb
  void checkClimb() {
    boolean touchingVine = false;
    for (int i=0; i<currentVines.size(); i++) {
      currentVine = currentVines.get(i); // uses currentVine in the player's variable section
      if (currentVine.isOnVine(this)) {
        touchingVine = true;
        break;
      }
    }
    if (upPressed && touchingVine) {
      movCurrent = "climb";
    }
  }

  // checks if the player is colliding with any ground
  boolean onAnyGround() {
    Rectangle playerRect = this.getBounds();
    // check if player collides with all grounds
    for (Ground g : allGrounds) {
      Rectangle groundRect = new Rectangle(
        (int)g.pos.x,
        (int)g.pos.y,
        (int)g.area.x,
        (int)g.area.y
        );
      if (playerRect.intersects(groundRect)) {
        if (pos.y > g.pos.y - (size.y/2)) {
          pos.y = g.pos.y - (size.y/2);
        }
        return true;
      }
    }
    // check if player collides with all platforms
    for (Platform pl : currentPlats) {
      if (pl.isColliding(this)) {
        if (pos.y > pl.y - (size.y/2)) {
          pos.y = pl.y - (size.y/2);
        }
        return true;
      }
    }
    return false;
  }

  // Return the bounding box of the player (used for collision detection)
  Rectangle getBounds() {
    return new Rectangle((int)this.pos.x, (int)this.pos.y,
      (int)this.size.x, (int)this.size.y);
  }

  void changeState(String newKey) {
    if (stateMap.containsKey(newKey)) {
      currentState = stateMap.get(newKey);
    }
  }

  // momentum check function
  void checkMomentum(float mX, float mY) {
    if (dirtyMomentum) {
      momentumX = mX;
      momentumY = mY;
      dirtyMomentum = false;
      // test++;
      // println(test + " dirty flags triggered");
    }
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
      lastAim[3] =
        "none";
    }
  }
}
void playerDeath() {
  // currently just re-generates the player object
  // change this later to trigger a "game over" UI
  worm = new Play(1000, 610, 5);
  currentHealth = 5;
}
