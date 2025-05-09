float cameraMovement;

class Platform {
  float x, y, w, h;

  Platform (float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h =  h_;
    cameraMovement= 1.25;
  }

  void display () {
    fill (#D2DE3C);
    rect(x, y, w, h);
  }

  void update () {
    cameraMovement();
    
    if (isColliding(worm)) {
      onSurface=true;
      player.canJump = true;
      
      println ("working");
      worm.pos.y = y - worm.size.y /2;
      player.ySpeed = 0;
      worm.movCurrent = "walk";     
    }
  }

  void cameraMovement() {  
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


   // Check if the player is on the platform
  boolean onPlatform(Platform plat) {
    return (plat.y + plat.h >= player.y && 
            plat.y + plat.h <= player.y + 10 &&
            plat.x + plat.w > player.x && 
            plat.x < player.x + player.w);
  }

  // Check if player is on platform
  boolean isColliding(Play worm) {
    return getBounds().intersects(worm.getBounds());
  }
}
