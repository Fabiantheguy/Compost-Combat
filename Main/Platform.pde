boolean isColliding;
float cameraMovement;
class Platform {
  float x, y, w, h;

  Platform (float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h =  h;
    cameraMovement= 1.25;
  }
  void run () {
    display();
    update();
  }

  void display () {
    fill (yellow);
    rect(x, y, w, h);
  }

  void update () {
    

    if (isColliding) {
      player.y = y - player.h;
      player.ySpeed = 0;
    }
    cameraMovement();
  }
  
  boolean isColliding(Player p) {
    return ( p.y + p.h >= y && p.y + p.h <= y + 10 && p.x + p.w > x && p.x < x + w);
  }
  
  void cameraMovement() {
  if (player.left) {
    x+= cameraMovement;
  } else if (player.right) {
    x-= cameraMovement;
  }
}
}
