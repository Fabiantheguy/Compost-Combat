float cameraMovement;

class Platform {
  float x, y, w, h;
  boolean onPlat;

  Platform (float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    cameraMovement= 1.25;
   
  }

  void display () {
    fill (#D2DE3C);
    rect(x, y, w, h);
  }

  void update () {
    cameraMovement();
    if (isColliding(worm)) {
      //println("running");
      onPlat=true;
      worm.movCurrent="walk";//If player is colliding w/ plat
      //worm.updateWalk();
      if (upPressed) {//Getting player to jump when on plat
        worm.movCurrent = "jump";
        worm.jumpVel = worm.initJump;
        worm.updateJump();
      }
    } else {
      onPlat = false;
    }
    
    //onPlat = onPlatform(this);
    //println(onPlat);
  }

  void cameraMovement() { //Accounting for camera shift in game
    if (player.left) {
      x+= cameraMovement;
    } else if (player.right) {
      x-= cameraMovement;
    }
  }
  //getting platform bounds
  Rectangle getBounds() {
    return new Rectangle((int)x, (int)y, (int)w, (int)h);
  }


  // Check if player is on platform
  boolean isColliding(Play worm) {
    return getBounds().intersects(worm.getBounds());
  }
}
