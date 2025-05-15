class Bullet {
  float dirRad, speed;
  PVector pos;
  int lifetime, startTime;
  
  Bullet(float d, float s, PVector p, int l) {
    dirRad = d;
    speed = s;
    pos = new PVector(p.x, p.y);
    lifetime = l;
    startTime = millis();
  }
  
  void update() {
    this.pos.x += (this.speed * sin(this.dirRad));
    this.pos.y -= (this.speed * cos(this.dirRad));
    
    // draw bullet
    noStroke();
    fill(130);
    circle(this.pos.x, this.pos.y, 10);
    
    // Safeguard: Ensure apple exists before checking collision
    if (apple != null && getBounds().intersects(apple.getBounds())) {
      apple = null;  // Destroy the apple
      // Optionally, handle bullet deletion after collision if needed
    }
    
    if (orange != null && getBounds().intersects(orange.getBounds())) {
      orange = null;  // Destroy the orange
      // Optionally, handle bullet deletion after collision if needed
    }

    // Optionally delete the bullet when lifetime is over
    if (millis() - startTime >= lifetime) {
      // Implement logic to remove bullet if necessary
    }
  }

  Rectangle getBounds() {
    return new Rectangle((int)this.pos.x, (int)this.pos.y, 10, 10);  // bullet size
  }
}
