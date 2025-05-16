// Secluded variables for the enemy (), and platform
Banana banana;
bananaBullet bananabullet;


PImage bananaImage;

//int respawnTime = 3000; // 3 seconds to respawn the banana
//int lastDestroyedTime = -1; // -1 means no banans has died yet

// Initialize the Banana objects
void BananaSetup() {
  PImage[] bananaFrames = new PImage[]{
    // loadImage("Banana.png")
      loadImage("apple/Red.png"),
  }; 

  EnemyFactory factory = new EnemyFactory();
  banana = (Banana)factory.createEnemy("Banana", width / 4, height - 150,  bananaFrames); 
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
      // banana = new Banana(width / 4, worm.pos.y - 90);
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
class Banana extends Enemy {

  float speed = 1;
  float ySpeed = 0;
  float gravity = 0.8;

  PImage spriteSheet =  loadImage("Banana.png"); 
;       // 
  PImage[] frames;          // Array of animation frames
  int currentFrame = 0;     // Index of current frame
  int totalFrames = 6;
  int cols = 6;
  int frameW =spriteSheet. width / cols;
  int frameH = spriteSheet. height / rows; 
  int frameTimer = 0;       // Used to time switching frames
  int frameInterval = 10;   // Change frame every 10 draw() calls
  int frameCounter = 0;
  
  
    int index; 
      //for (int i =0; i < cols; i++){
      //  frames[index++] = spriteSheet.get(i * frameW,  frameH, frameW, frameH);
      //}

  
  boolean bananaShot = false;  //checking to see if the bullet is active

  Banana(float x, float y, EnemyType type, PImage[] availableImages) {
    super(x, y, type, availableImages); // Initialize Enemy superclass
    frames = availableImages; 
  }

  void follow(Play player) {
    if (player.pos.x < x - 1) x -= speed;
    else if (player.pos.x > x + 1) x += speed;
  }

  void update() {
    // Gravity
    ySpeed += gravity;
    y += ySpeed;
    
    frameCounter ++;
    if (frameCounter >= frameInterval){
      currentFrame = (currentFrame + 1) %totalFrames;
      frameCounter = 0;
    }

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
