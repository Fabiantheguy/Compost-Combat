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

// === Player class containing the FSMs ===
class Player {
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
  Player(float x, float y, float s) {
    // position
    pos = new PVector(x, y);
    size = new PVector(40, 40);
    
    // movement variables
    speed = s;
    jumpVel = 0;
    initJump = 10;
    
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
    noFill();
    stroke(150, 40, 0);
    
    // firing update
    if (this.gunCurrent == "ready") {
      this.updateReady();
    } else if (this.gunCurrent == "fire") {
      this.updateFire();
    }
    
    // bullet update
    for(int i=0; i<bullets.size(); i++){
      // check if the bullet needs to be updated or deleted
      Bullet bullet = bullets.get(i);
      if(millis() - bullet.startTime >= bullet.lifetime){
        bullets.remove(i);
      } else {
        bullet.update();
      }
    }
    
    noStroke();
    fill(255, 200, 150);
    rectMode(CENTER);
    
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
    
    rect(this.pos.x, this.pos.y, this.size.x, this.size.y);
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
    
    rect(this.pos.x, this.pos.y, this.size.x*0.875, this.size.y*1.125);
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
    
    rect(this.pos.x, this.pos.y, this.size.x*1.125, this.size.y*0.875);
  }
  
  // climbing update code
  void updateClimb(){
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
    
    rect(this.pos.x, this.pos.y, this.size.x, this.size.y);
  }

  // non-firing update code
  void updateReady(){
    if(lastAim[0] != "none" || lastAim[1] != "none"){
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
    if(int(lastAim[0]) == 38){
      if(int(lastAim[1]) == 37){
        rotate(PI/-4);
        this.aimRad = PI*1.75;
      } else if(int(lastAim[1]) == 39){
        rotate(PI/4);
        this.aimRad = PI/4;
      } else {
        this.aimRad = 0;
      }
    } else if(int(lastAim[1]) == 37){
      rotate(PI/-2);
      this.aimRad = PI*1.5;
      if(int(lastAim[0]) == 40){
        rotate(PI/-4);
        this.aimRad = PI*1.25;
      }
    } else if(int(lastAim[1]) == 39){
      rotate(PI/2);
      this.aimRad = PI/2;
      if(int(lastAim[0]) == 40){
        rotate(PI/4);
        this.aimRad = PI*0.75;
      }
    } else if(int(lastAim[0]) == 40){
      rotate(PI);
      this.aimRad = PI;
    }
    line(0, 0, 0, -70);
    popMatrix();
    
    // check if bullet cooldown has elapsed
    if(millis() - this.bulletCd >= this.fireRate){
      bullets.add(new Bullet(this.aimRad, this.bulletSpeed, this.pos));
      this.bulletCd = millis();
    }
    
    // if no keys are pressed, exit this state
    if(lastAim[0] == "none" && lastAim[1] == "none"){
      this.gunCurrent = "ready";
    }
  }
  
  // Return the bounding box of the player (used for collision detection)
  Rectangle getBounds() {
    return new Rectangle((int)this.pos.x, (int)this.pos.y, 
                         (int)this.size.x, (int)this.size.y);
  }
}

// === Key input tracking ===
void keyPressed() {
  if (key == 'a' || key == 'A') leftHeld = true;
  if (key == 'd' || key == 'D') rightHeld = true;
  if (key == 'w' || key == 'W') upPressed = true;
  if (key == 's' || key == 'S') downHeld = true;
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

void keyReleased() {
  if (key == 'a' || key == 'A') leftHeld = false;
  if (key == 'd' || key == 'D') rightHeld = false;
  if (key == 'w' || key == 'W') upPressed = false;
  if (key == 's' || key == 'S') downHeld = false;
  if (keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT) {
    // find key code for the key released and remove it
    for(int i=0; i<lastAim.length; i++) {
      if(int(lastAim[i]) == keyCode) lastAim[i] = "none";
    }
    // fill missing indexes with their previous values
    if(lastAim[0] == "none"){
      lastAim[0] = lastAim[2];
      lastAim[2] = "none";
    }
    if(lastAim[1] == "none"){
      lastAim[1] = lastAim[3];
      lastAim[3] = "none";
    }
  }
}
