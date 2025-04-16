// === Global key states ===
boolean leftHeld = false;
boolean rightHeld = false;
boolean upPressed = false;
boolean downHeld = false;
boolean upAimed = false;
boolean downAimed = false;
boolean leftAimed = false;
boolean rightAimed = false;

// === Player class containing the FSMs ===
class Player {
  // instantiate variables
  StringList movStates = new StringList();
  String movCurrent = "walk";
  StringList gunStates  = new StringList();
  String gunCurrent = "ready";
  PVector pos;
  float speed, jumpVel, initJump, aimRad, bulletSpeed;
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();
  int bulletCd, fireRate;
  
  // constructor
  Player(float x, float y, float s) {
    // position
    pos = new PVector(x, y);
    
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
    
    rect(this.pos.x, this.pos.y, 45, 35);
  }

  // non-firing update code
  void updateReady(){
    if(upAimed || leftAimed || rightAimed || downAimed){
      this.gunCurrent = "fire";
    }
  }
  
  // firing update code
  void updateFire() {
    // original mouse aiming code, in case the rest of the team sees the light
    // line(this.pos.x, this.pos.y, mouseX, mouseY);
    
    // new 8-directional aiming code
    pushMatrix();
    translate(this.pos.x, this.pos.y);
    if(upAimed){
      if(leftAimed){
        rotate(PI/-4);
        this.aimRad = PI*1.75;
      } else if(rightAimed){
        rotate(PI/4);
        this.aimRad = PI/4;
      } else {
        this.aimRad = 0;
      }
    } else if(leftAimed){
      rotate(PI/-2);
      this.aimRad = PI*1.5;
      if(downAimed){
        rotate(PI/-4);
        this.aimRad = PI*1.25;
      }
    } else if(rightAimed){
      rotate(PI/2);
      this.aimRad = PI/2;
      if(downAimed){
        rotate(PI/4);
        this.aimRad = PI*0.75;
      }
    } else if(downAimed){
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
    
    if((upAimed || leftAimed || rightAimed || downAimed) == false){
      this.gunCurrent = "ready";
    }
  }
}

// === Key input tracking ===
void keyPressed() {
  if (key == 'a' || key == 'A') leftHeld = true;
  if (key == 'd' || key == 'D') rightHeld = true;
  if (key == 'w' || key == 'W') upPressed = true;
  if (key == 's' || key == 'S') downHeld = true;
  if (keyCode == UP) upAimed = true;
  if (keyCode == DOWN) downAimed = true;
  if (keyCode == LEFT) leftAimed = true;
  if (keyCode == RIGHT) rightAimed = true;
}

void keyReleased() {
  if (key == 'a' || key == 'A') leftHeld = false;
  if (key == 'd' || key == 'D') rightHeld = false;
  if (key == 'w' || key == 'W') upPressed = false;
  if (key == 's' || key == 'S') downHeld = false;
  if (keyCode == UP) upAimed = false;
  if (keyCode == DOWN) downAimed = false;
  if (keyCode == LEFT) leftAimed = false;
  if (keyCode == RIGHT) rightAimed = false;
}
