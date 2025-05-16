/*
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
    image(ground, pos.x, pos.y, area.x, area.y + 200/*adjust for size*//*);
    
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
*/
