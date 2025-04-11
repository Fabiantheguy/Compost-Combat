// === Global key states ===
boolean leftHeld = false;
boolean rightHeld = false;
boolean upPressed = false;

// === Player class containing the FSMs ===
class Player {
  // instantiate variables
  StringList movStates = new StringList();
  String movCurrent = "walk";
  StringList gunStates  = new StringList();
  String gunCurrent = "aim";
  PVector pos;
  float speed, jumpVel, initJump;
  
  // constructor
  Player(float x, float y, float s) {
    // position
    pos = new PVector(x, y);
    
    // movement variables
    speed = s;
    jumpVel = 0;
    initJump = 10;
    
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
    noFill();
    stroke(150, 40, 0);
    
    // firing update
    if (this.gunCurrent == "aim") {
      this.updateAim();
    } else if (this.gunCurrent == "fire") {
      // this.updateFire();
    }
    
    noStroke();
    fill(255, 200, 150);
    rectMode(CENTER);
    
    // movement update
    if (this.movCurrent == "walk") {
      this.updateWalk();
    } else if (this.movCurrent == "jump") {
      this.updateJump();
    } else if (this.movCurrent == "g_dash") {
      // this.updateGDash();
    } else if (this.movCurrent == "a_dash") {
      // this.updateADash();
    }
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
    }
    
    rect(this.pos.x, this.pos.y, 40, 40);
  }
  
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

    if (this.pos.y >= 600) {
      this.pos.y = 600;
      this.jumpVel = 0;
      this.movCurrent = "walk";
    }
    
    rect(this.pos.x, this.pos.y, 35, 45);
  }

  // aim update code
  void updateAim() {
    line(this.pos.x, this.pos.y, mouseX, mouseY);
  }
}

// === Main sketch ===

Player player;

// === Key input tracking ===
void keyPressed() {
  if (key == 'a') leftHeld = true;
  if (key == 'd') rightHeld = true;
  if (key == 'w') upPressed = true;
}

void keyReleased() {
  if (key == 'a') leftHeld = false;
  if (key == 'd') rightHeld = false;
  if (key == 'w') upPressed = false;
}
