// Shows level progression in the background 
class Sun {
  float d;
  PVector pos;
  color c;
  
  Sun(float x, float y, float d) {
    c = #F5EC3E;
    pos = new PVector(x, y);
    
  }
  
  void display() {
    fill(c);
    circle(pos.x, pos.y, d);
  }
}
