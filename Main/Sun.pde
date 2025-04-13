//Shows level progression in the background 
class Sun {
  PVector pos;
  color c;
  float sunShift;
  
  Sun(float x, float y) {
    c = #F5EC3E;
    pos = new PVector(x, y);
    sunShift = 0.25;
  }
  
  void update() {
    if (player.left) {
      pos.x += sunShift;
    }
    
    if (player.right) {
      pos.x -= sunShift;
    }
  }
  
  void display() {
    fill(c);
    circle(pos.x, pos.y, 50);
  }
}

void sunDraw() {
  sun.display();
  sun.update();
}
