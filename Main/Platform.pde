boolean isColliding;
float cameraMovement;
class Platform {
  float x, y, w, h, platformTop;

  Platform (float x, float y, float w, float h) {
    this.x= x;
    this.y = y;
    this.w= w;
    this.h =  h;
    cameraMovement= 1.25;
    platformTop = 40;
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
    isColliding =player.x >= x - platformTop/1.5 &&
      player.y > y-platformTop &&
      player.x < x + platformSize
      && player.y < y+ platformSize;

    if (isColliding) {
      player.y = y-platformTop;
      player.ySpeed = 0;
    }
    cameraMovement();
  }
  
  void cameraMovement() {
  if (player.left) {
    x+= cameraMovement;
  } else if (player.right) {
    x-= cameraMovement;
  }
}
}
