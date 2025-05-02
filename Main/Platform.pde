import java.awt.Rectangle;  // Import Rectangle for collision checking

boolean isColliding;
float cameraMovement;

// Adding Platform Class as an array to add multiple to scene
color yellow = #F8FF31, green = #0BA048; // Sets colors
Platform[] platforms;
float platformSize = 150; // Sets how wide
PVector platformDist = new PVector(100, 50); // How far apart the platforms are
PVector platformPOS = new PVector(1500, 300); // Where the platforms are
boolean isOnTop;

class Platform {
  float x, y, w, h;

  Platform(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    cameraMovement = 1.25;
  }

  void run() {
    update();
    display();
  }

  void update() {
    isOnTop = false;

    // detects if player is on top of the platforms
    if (player.y - player.h > y  &&
      player.x < x + w &&
      player.x + player.w > x) {
      isOnTop = true;
    }
    if (player.left) {
      x += cameraMovement;
    } else if (player.right) {
      x -= cameraMovement;
    }
  }
  void display() {
    fill(255, 0, 0);
    rect(x, y, w, h);
  }
}
