// Secluded variables for the enemy (), and platform
Banana banana;
bananaBullet bananabullet;


PImage bananaImage;

//int respawnTime = 3000; // 3 seconds to respawn the banana
//int lastDestroyedTime = -1; // -1 means no banans has died yet

// Initialize the Banana and platform objects
void BananaSetup() {
  bananaImage = loadImage("Banana.png");
  banana = new Banana(width / 4, worm.pos.y - 100);


}

void BananaDraw() {
  if (banana == null) {
    // Banana is dead
    if (lastDestroyedTime < 0) {
      // Timer hasn't started yet — start it now
      lastDestroyedTime = millis();
    }
    // Check if enough time has passed to respawn
    if (millis() - lastDestroyedTime > respawnTime) {
      banana = new Banana(width / 4, worm.pos.y - 90);
      lastDestroyedTime = -1; // Reset timer
    }
  } else {
    //Banana is alive
    //banana.follow(worm);
    banana.update();
    banana.display();
  }
  
  if (bananabullet != null ) {
    bananabullet.update();
    bananabullet.display();
}


}

// Banana class
class Banana {
 
  float x, y;               // Position
  float w = 40, h = 40;     // Size
  float speed = 1;
  float ySpeed = 0;
  float gravity = 0.8;

  PImage[] frames;          // Array of animation frames
  int currentFrame = 0;     // Index of current frame
  int frameTimer = 0;       // Used to time switching frames
  int frameInterval = 10;   // Change frame every 10 draw() calls
  
  boolean bananaShot = false;  //checking to see if the bullet is active

  Banana(float x, float y) {
    this.x = x;
    this.y = y;

    // Load the four frames (make sure these files are in your "data" folder)
    frames = new PImage[1];
    frames[0] = loadImage("Banana/Banana.png");
    //frames[1] = loadImage("banana/Teal.png");
    //frames[2] = loadImage("banana/Orange.png");
    //frames[3] = loadImage("banana/Blue.png");
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
    if ( !bananaShot ) {
      bananabullet = new bananaBullet(width / 4, worm.pos.y - 100); 
      
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
    image(frames[currentFrame], x - 20, y - 30, 80, 80);
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
  //boolean active = false;
  
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
