class Platform {
  color gray = #404040;
  boolean isOnTop;
  int x, y, w, h;
  float platformShift;
  
  Platform (int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h =  h;
    platformShift = 1.25;
  }
  void run () {
    update();
    display();
  }
  
  void update () {
    
    // moves the platform to the right when player is moving to the left
    if(player.right){
      x -= platformShift;
    }
    
    if(player.left){
      x += 2.0;
    }
  }   

  void display () {
    fill (gray);
    rect(x, y, w, h);
  } 
}
