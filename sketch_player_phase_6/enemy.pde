import java.awt.Rectangle;

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

//define all properties of enemy here, which has different type and different platform

class Enemy extends Entity {
  EnemyType type;
  PImage[] frames; // Store one selected image
  int currentFrame = 0;
  int frameTimer = 0;
  int frameInterval = 10;

  Enemy(float x, float y, EnemyType type, PImage[] availableImages) {
    super(x, y, 40, 40); // Now width & height are passed
    this.type = type;
    this.frames = availableImages; 
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
// each enemy has its own type and platform

class EnemyFactory {
  
  EnemyType appleType, bananaType;
 
  
 Enemy createEnemy(String type, float x, float y, PImage[] frames) {
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

    // Create the enemy associated with the platform, like apple or banana
    println("new enemy"); 
     if (type.equals("Apple")) {
        return new Apple(x, y, enemyType,frames);        
     } else if (type.equals("Banana")) {
        return new Banana(x, y, enemyType, frames);
    } else {
        return new Enemy(x, y, enemyType, frames);
    }
  }
}
