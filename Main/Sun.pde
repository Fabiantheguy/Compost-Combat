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
    // when player goes left the sun moves to the right
    if (player.left) {
      pos.x += sunShift;
    }
    // when the player goes right the sun moves ;eft
    if (player.right) {
      pos.x -= sunShift;
    }
  }
  
  void display() {
    fill(c);
    circle(pos.x, pos.y, 50);
  }
}

// draws both the
void sunDraw() {
  sun.update();
  sun.display();
}
