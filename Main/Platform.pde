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
  }

  void display () {
    cameraMovement();
  }

  
  
  void cameraMovement() {
  if (player.left) {
    x+= cameraMovement;
  } else if (player.right) {
    x-= cameraMovement;
  }
  println(x);
}
}
