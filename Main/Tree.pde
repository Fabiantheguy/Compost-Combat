// Main place where gameplay will happen
class Tree {
  float x, y, w, h, treeShift; // postiton and area of tree
  
  
  Tree(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    treeShift = 1.25;
  }
  
  void update() {
    if (player.left) {
      x += treeShift;
    }
    
    if (player.right) {
      x -= treeShift;
    }
  }
  
  void display() {
    fill(#83470F);
    rect(x, y, w, h);
  }
  
  
}

// Class for Vine for player to climb up and down tree
class Vine{
  PVector pos;
  PVector area;
  boolean isOnVine; // detect if player is on Vine
  
  Vine(float x, float y, float w, float h){
    pos = new PVector(x, y);
    area = new PVector(w, h);
    isOnVine = false;
  }
  
  void display(){
    fill(#00ff00);
    rect(pos.x, pos.y, area.x, area.y);
  }
  
}


void treeDraw() {
  tree.update();
  tree.display();
}
