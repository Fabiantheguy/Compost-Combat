color gray = #404040;
boolean isColliding;
class Platform {
  int x, y, w, h;
  Platform (int x, int y, int w, int h) {
    this.x= x;
    this.y = y;
    this.w= w;
    this.h =  h;
  }
  void run () {
    display();
    update();
  }

  void display () {
    fill (gray);
    rect(x, y, w, h);
  }

  void update () {
    isColliding =player.x >= x && player.y > y-50 ;
    if (isColliding) {
      player.y = y-50;
      player.ySpeed = 0;
    }
  }
}
