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
    isColliding = player.x >= x - player.h/1.5 && player.y > y - player.h && player.x < x + w && player.y < y + w;

    if (isColliding) {
      player.y = y - player.h;
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
