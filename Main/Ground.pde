ArrayList<Ground> allGrounds = new ArrayList<Ground>();

PImage ground;

class Ground {
  PVector pos, area;
  color c;
  
  Ground(float x, float y, float w, float h) {
    pos = new PVector(x, y);
    area = new PVector(w, h);
    c = #00ff00;
    
    ground = loadImage("Ground.png");
  }
  
  void display() {
    fill(c);
    rect(pos.x, pos.y, area.x, area.y);
  }
  
  Rectangle getBounds() {
    return new Rectangle((int)pos.x, (int)pos.y, (int)area.x, (int)area.y);
  }
}


void grassDraw(){
  float scale = 0.5;
  background(#3DCFF2);
  grass.display();
  // These the coordinates of the ground png (needs to be fixed)
  image(ground, width/2, height/10, ground.width * scale, ground.height * scale);
}
