// Secluded variables for the enemy (), and platform
Banana[] banana; // banana bullets are now stored in their parent banana class

void BananaDraw() {
  // checks if banana array exists
  if (banana != null) {
    for (Banana currentBanana : banana){
      // Banana is alive
      if (currentBanana.hitPoints > 0){ 
        currentBanana.update();
        currentBanana.display();
      } else {
        // Banana is dead
        if (lastDestroyedTime < 0) {
          // Timer hasn't started yet — start it now
          lastDestroyedTime = millis();
        }
        // Check if enough time has passed to respawn
        if (millis() - lastDestroyedTime > respawnTime) {
          currentBanana.x = currentBanana.initX;
          currentBanana.y = currentBanana.initY;
          currentBanana.hitPoints = 1;
          lastDestroyedTime = -1; // Reset timer
        }
      }
      // runs banana bullet update
      if (currentBanana.bullet.active){
        currentBanana.bullet.update();
      }
    } 
  }


}

// Banana class
class Banana extends Enemy {
  float speed = 1;
  float ySpeed = 0;
  float gravity = 0.8;

  PImage[] frames;          // Array of animation frames
  int currentFrame = 0;     // Index of current frame
  int frameTimer = 0;       // Used to time switching frames
  int frameInterval = 10;   // Change frame every 10 draw() calls
  
  bananaBullet bullet;
  boolean bananaShot = false;  //checking to see if the bullet is active

  Banana(float x, float y, EnemyType type, PImage[] availableImages) {
    super(x, y, 1, type, availableImages); // Initialize Enemy superclass
    frames = availableImages; 
    bullet = new bananaBullet(x, y);
  }

  void follow(Play player) {
    if (player.pos.x < x - 1) x -= speed;
    else if (player.pos.x > x + 1) x += speed;
  }

  void update() {
    // Gravity
    ySpeed += gravity;
    y += ySpeed;

    Rectangle bananaRect = getBounds();

    //uses the float from the banana bullet inside of the bullet class.
    if (!bananaShot && hitPoints > 0) { // can't shoot if you're dead
      bullet.x = this.x;
      bullet.y = this.y;
      bullet.active = true;
      bananaShot = true;
    }

    for (Ground g : allGrounds) {
      Rectangle groundRect = new Rectangle(
        (int) g.pos.x,
        (int) g.pos.y,
        (int) g.area.x,
        (int) g.area.y
      );

      if (bananaRect.intersects(groundRect)) {
        y = g.pos.y - h + 1; // Snap banans to ground
        ySpeed = 0;
        break;
      }
    }

    // Animation
    frameTimer++;
    if (frameTimer >= frameInterval) {
      frameTimer = 0;
      currentFrame = (currentFrame + 1) % frames.length;
    } 
  }

  void display() {
  }

  boolean onAnyGround() {
    Rectangle bananaRect = getBounds();
    for (Ground g : allGrounds) {
      Rectangle groundRect = new Rectangle(
        (int) g.pos.x,
        (int) g.pos.y,
        (int) g.area.x,
        (int) g.area.y
      );
      if (bananaRect.intersects(groundRect)) return true;
    }
    return false;
  }

 Rectangle getBounds() {
    return new Rectangle((int) x, (int) y, (int) w, (int) h);
  }
}


class bananaBullet {
  
  float x, y;
  //float w = 10, h = 10;
  float speed = 18;
  boolean active = false;
  
  bananaBullet(float X, float Y) { //Holds the bullet
    
    x = X;
    y = Y;
  }
  
  void update() {
    //position increasing fromm the x
    x += speed;
  }
  
  void display() {
    //rect for bullet
    rect(x, y, 10, 10);   
  }
  
 Rectangle getBounds() {
    return new Rectangle((int) x, (int) y, 10, 10);
  }
  
}
