// class for moving, damage-dealing projectiles
class Bullet {
  float dirRad, speed, momentumX, momentumY;
  PVector pos;
  int lifetime, startTime, myID, nextBullet;
  BulletPool pool;
  boolean active = false;
  
  // old pre-object pool constructor
  Bullet(float d, float s, PVector p, int l) {
    dirRad = d;
    speed = s;
    pos = new PVector(p.x, p.y);
    lifetime = l;
    startTime = millis();
  }
  
  // alternate constructor for object pool
  Bullet(BulletPool b, int m, int n) {
    dirRad = 0;
    speed = 0;
    pos = new PVector(0, 0);
    lifetime = 0;
    startTime = 0;
    pool = b;
    myID = m;
    nextBullet = n;
  }
  
  // set up bullet from object pool to be fired
  void ready(float d, float s, float mX, float mY, PVector p, int l) {
    dirRad = d;
    speed = s;
    pos = new PVector(p.x, p.y);
    momentumX = mX; // sets bullet momentum to player momentum at time of shooting
    momentumY = mY;
    lifetime = l;
    startTime = millis();
    active = true;
    pool.nextFree = nextBullet; // sets the next bullet in line to be called by the pool
  }
  
  void update() {
    pos.x += (this.speed * sin(this.dirRad));
    pos.x += momentumX;
    pos.y -= (this.speed * cos(this.dirRad));
    pos.y -= momentumY;
    
    // draw bullet
    noStroke();
    fill(130);
    circle(this.pos.x, this.pos.y, 10);
    
    // Safeguard: Ensure apple exists before checking collision
    if (apple != null) {
      for (Apple currentApple : apple){
        if (getBounds().intersects(currentApple.getBounds())){
          currentApple.hitPoints--;  // Damage the apple
        }
      // Optionally, handle bullet deletion after collision if needed
      }
    }
    
    // Safeguard: Ensure orange exists before checking collision
    if (orange != null) {
      for (Orange currentOrange : orange){
        if (getBounds().intersects(currentOrange.getBounds())){
          currentOrange.hitPoints--;  // Damage the orange
        }
      // Optionally, handle bullet deletion after collision if needed
      }
    }
  }
  
  // runs when the bullet is destroyed
  void destroy(){
    active = false;
    pool.nextFree = myID; // this allows the bullet to set itself as the next free one
  }

  Rectangle getBounds() {
    return new Rectangle((int)this.pos.x, (int)this.pos.y, 10, 10);  // bullet size
  }
}

// bullet object pool
class BulletPool {
  // array of all bullets and their isFree values
  Bullet[] allBullets = new Bullet[64];
  int nextFree;
  
  // instantiate all bullets in constructor
  BulletPool() {
    // initially set the next free bullet to the first one
    nextFree = 0;
    // create all bullets
    for(int i=0; i<allBullets.length; i++){
      int j = i+1;
      if (j==allBullets.length) {
        allBullets[i] = new Bullet(this, i, 0);
      } else {
        allBullets[i] = new Bullet(this, i, j);
      }
    }
  }
}
