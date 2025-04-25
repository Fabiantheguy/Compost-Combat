// bullet class
class Bullet{
  // instantiate variables
  float dirRad, speed;
  PVector pos;
  int lifetime, startTime;
  
  // constructor
  Bullet(float d, float s, PVector p){
    // variable assignment
    dirRad = d;
    speed = s;
    pos = new PVector(p.x, p.y);
    lifetime = 600;
    startTime = millis();
  }
  
  // update
  void update(){
    // update position
    this.pos.x += (this.speed*sin(this.dirRad));
    this.pos.y -= (this.speed*cos(this.dirRad));
    
    // draw bullet
    noStroke();
    fill(130);
    circle(this.pos.x, this.pos.y, 10);
    
    // check collision (wip)
  }
}
