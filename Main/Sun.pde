//Shows level progression in the background 
class Sun {
  PVector pos;
  color c;
  float sunShift; 
  
  Sun(float x, float y) {
    c = #F5EC3E;
    pos = new PVector(x, y);
    sunShift = 0.25; // moves the sune by this amount
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
  
  // draws the sun itself
  void display() {
    fill(c);
    circle(pos.x, pos.y, 50);
  }
}

// draws both the sun moving and the sun itself
void sunDraw() {
  sun.update();
  sun.display();
}
