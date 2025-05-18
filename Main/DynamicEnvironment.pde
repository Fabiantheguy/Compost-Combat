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

// Ground Class
ArrayList<Ground> allGrounds = new ArrayList<Ground>();

PImage ground;

class Ground {
  PVector pos, area;
  color c;

  Ground(float x, float y, float w, float h) {
    pos = new PVector(x, y);
    area = new PVector(w, h);
    c = #00ff00;

    // Only load image once globally, not per ground instance
    if (ground == null) {
      ground = loadImage("Ground.png");
    }
  }

  void display() {
    // Draw the ground image at this ground's position and size
    image(ground, pos.x, pos.y, area.x, area.y + 200/*adjust for size*/);

    // Optionally draw the green rectangle behind or under the image
    // fill(c);
    // rect(pos.x, pos.y, area.x, area.y);
  }

  Rectangle getBounds() {
    return new Rectangle((int)pos.x, (int)pos.y, (int)area.x, (int)area.y);
  }
}



void grassDraw() {
  background(#3DCFF2);

  for (Ground g : allGrounds) {
    g.display();  // Will draw the image over the ground
  }
}


// Swinging Vines For Level Two
class swingingVines {
  float upperx, uppery, lowerx, lowery;
  float xSpeed;
  boolean isSwinging = false;
  float cameraMovement = 1.25;
  
  swingingVines (float x, float y, float x2, float y2) {
    upperx = x;
    uppery = y;
    lowerx = x2;
    lowery = y2;
    xSpeed = 0;
  }
  void run() {
    display();
    update();
  }

  void display() {
    stroke (#3CDE5B);
    strokeWeight(30);
    strokeCap(PROJECT);
    line (upperx, uppery, lowerx + xSpeed, lowery);
    noStroke();
  }
  void update () {
    isSwinging =player.x >= upperx - 30 &&
      player.x <=lowerx + 25 &&
      player.y > uppery - 50 &&
      player.y < lowery + 40;


    if (isSwinging) {
      if (keyPressed && key == ' ') {

        player.ySpeed = 0;
        isSwinging= false;
      }


      xSpeed = 100 * sin (0.03 * frameCount);
      player.x = lowerx+xSpeed;
      player.y = lowery;
    }
    cameraMovement();
  }

  void cameraMovement() {
    if (player.left) {
      upperx+= cameraMovement;
      lowerx += cameraMovement;
    } else if (player.right) {
      upperx-= cameraMovement;
      lowerx -= cameraMovement;
    }
  }
}



class Platform {
  float x, y, w, h;
  float cameraMovement;
  Platform (float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    cameraMovement= 1.25;
  }

  void display () {
    fill (#D2DE3C);
    rect(x, y, w, h);
  }

  void update () {
    cameraMovement();

    if (isColliding(worm)) {
      onSurface=true;
      player.canJump = true;

      // println ("working");
      player.ySpeed = 0;
    }
  }

  void cameraMovement() {
    if (player.left) {
      x+= cameraMovement;
    } else if (player.right) {
      x-= cameraMovement;
    }
  }
  //getting platform bounds
  Rectangle getBounds() {
    return new Rectangle((int)x, (int)y, (int)w, (int)h);
  }


  // Check if the player is on the platform
  boolean onPlatform(Platform plat) {
    return (plat.y + plat.h >= player.y &&
      plat.y + plat.h <= player.y + 10 &&
      plat.x + plat.w > player.x &&
      plat.x < player.x + player.w);
  }

  // Check if player is on platform
  boolean isColliding(Play worm) {
    return getBounds().intersects(worm.getBounds());
  }
}
