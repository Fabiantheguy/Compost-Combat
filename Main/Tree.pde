/*
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
class Vine {
  float x, y, w, h;
  boolean isOnVine; // detect if player is on Vine
  float vineShift; // moves the vine by this amount
  color c;

  Vine(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    vineShift = 1.25;
    c = #00ff00;
  }

  // draws the vine
  void display() {
    fill(c);
    rect(x, y, w, h);
  }

  void update() {

    // moves the vine to the right when player is moving to the left
    if (player.left) {
      x += vineShift;
    }

    // moves the vine to the left when the player is moving right
    if (player.right) {
      x -= vineShift;
    }

    // resets the boolean to false if player is not touching vine every frame
    isOnVine = false;



  }

  // Check if Player is Colliding with Vine
  boolean isOnVine(Play worm) {
    return getBounds().intersects(worm.getBounds());
  }

  // gets perimiter of the vine
  Rectangle getBounds() {
    return new Rectangle((int) x, (int) y, (int) w, (int) h);
  }
}


void treeDraw() {
  tree.update();
  tree.display();
}
*/
