// Platforms for players to land on 
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




void treeDraw() {
  tree.update();
  tree.display();
}
