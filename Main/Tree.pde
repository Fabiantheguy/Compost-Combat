// Main place where gameplay will happen
class Tree {
  float x, y, w, h, treeShift; // postiton and area of tree
  
  
  Tree(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    treeShift = 1.25; // moves tree by this amount
  }
  
  void update() {
    
    // moves the tree to the right when player is moving to the left
    if (player.left) {
      x += treeShift;
    }
    
    // moves the tree to the left when the player is moving right
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
  float vineShift; // moves the vine by this amount
  float top, bot, right, left; // hitboxes for vine
  color c;
  
  Vine(float x, float y, float w, float h){
    pos = new PVector(x, y);
    area = new PVector(w, h);
    isOnVine = false;
    vineShift = 1.25;
    top = pos.y - area.y;
    bot = pos.y + area.y;
    right = pos.x + area.x;
    left = pos.x - area.x;
    c = #00ff00;
  }
  
  // draws the vine
  void display(){
    fill(c);
    rect(pos.x, pos.y, area.x, area.y);
  }
  
  void update(){
       
    // moves the vine to the right when player is moving to the left
    if (player.left) {
      pos.x += vineShift;
    }
    
    // moves the vine to the left when the player is moving right
    if (player.right) {
      pos.x -= vineShift;
    }
  }

  
  // detects if player is on vine
  boolean isOnVine(Player p) {
    return (p.x + p.w >= left &&
            p.x - p.w <= right &&
            p.y - p.h <= bot &&
            p.y + p.h >= top);
  }
  
  // gets perimiter of the vine
  Rectangle getBounds() {
    return new Rectangle((int) pos.x, (int) pos.y, (int) area.x, (int) area.y);
  }
}


void treeDraw() {
  tree.update();
  tree.display();

}
