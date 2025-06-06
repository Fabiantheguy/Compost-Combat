
Platform platform;

abstract class Entity {
  float x, y, w, h; 

  Entity(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  abstract void update();
  abstract void display();
  
   Rectangle getBounds() {
    return new Rectangle((int)x, (int)y, (int)w, (int)h);
  }
}

//define all properties of enemy here, which has different type 

class Enemy extends Entity {
  EnemyType type;
  PImage[] frames; // Store one selected image
  int currentFrame = 0;
  int frameTimer = 0;
  int frameInterval = 10;
  int hitPoints; // the HP of the enemy (most have 1)
  float initX, initY;

  Enemy(float x, float y, int hp, EnemyType type, PImage[] availableImages) {
    super(x, y, 40, 40); // Now width & height are passed
    initX = x;
    initY = y; // enemies need to remember their starting position to respawn
    this.type = type;
    this.frames = availableImages; 
    hitPoints = hp;
  }
    

  void follow(Player player) {
    if (player.x < x - 1) x -= type.speed;
   else if (player.x > x + 1) x += type.speed;
  }

  void update() {
    frameTimer++;
    if (frameTimer >= frameInterval) {
      frameTimer = 0;
      currentFrame = (currentFrame + 1) % frames.length;
    }
  }

  void display() {
    image(frames[currentFrame], x, y, w, h); // Uses w & h dynamically
  }
}

// enmey facatory usd to create the enermy denamically, can add new tyoe of enemy,
// each enemy has its own type 

class EnemyFactory {
  
  EnemyType appleType, bananaType;

  // Constructor to initialize enemy types
  EnemyFactory() {
      appleType = new EnemyType("Apple", 3.0); // Example values: name, spead
      bananaType = new EnemyType("Banana", 8.0);
  }
 
  
 Enemy createEnemy(String type, float x, float y, PImage[] frames, Platform platform) {
    EnemyType enemyType;

    switch (type) {
      case "Apple":
        enemyType = appleType;
        break;
      case "Banana":
        enemyType = bananaType;
        break;
      default:
        return null;
    }

    // Create the enemy like apple or banana
    println("new enemy"); 
     if (type.equals("Apple")) {
        return new Apple(x, y, platform);        
     } else if (type.equals("Banana")) {
        return new Banana(x, y, enemyType, frames);
    } else {
        return new Enemy(x, y, 1, enemyType, frames);
    }
  }
}
