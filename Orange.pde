Platform platform;
Player player;

class Orange {
  PVector pos;
  float size;


  Orange (float x, float y, float s) {
    pos = new PVector (x, y);
    size=s;
  }

  void display() {
    fill (orangeCol);
    circle (pos.x, pos.y, size);
    platform = new Platform (0, height-200, width, height);
    player = new Player (100, height-225, 100);
  }
  void update() {
    player.display();
    platform.display();
    platform.update();
  }
}

class Platform {
  PVector pos;
  PVector dimensions;
  Platform (float x, float y, float w, float h) {
    pos = new PVector(x, y);
    dimensions =  new PVector (w, h);
  }
  void display () {
    fill (gray);
    rect(platform.pos.x, platform.pos.y, platform.dimensions.x, dimensions.y);
  }
  void update () {
    if (orange.pos.y>platform.pos.y) {
      orange.pos.y=platform.pos.y;
    }
  }
}

class Player {
  PVector pos;
  PVector dimensions;
  PVector vel = new PVector(3.0, 0);
  PVector gravity= new PVector (0, 0.8);
  Player (float x, float y, int health) {
    pos = new PVector (x, y);
    dimensions = new PVector (25, 25);
    float accel = 3.0;
    health=0;
  }

  void display () {
    fill (black);
    rect(pos.x, pos.y, dimensions.x, dimensions.y);
  }

  void jump() {
    vel = new PVector (0.0, 3.0);
    player.pos.y-=(vel.y);
    vel.add(gravity);
  }

  void controls() {
    if (key ==  'a' || key == 'A' || key==CODED && key == LEFT
      && onScreen()) {
      player.pos.x +=player.vel.x;
      keyPressed=false;
    }
    if (key ==  'd' || key == 'D' || key==CODED && key == RIGHT
      && onScreen()) {
      player.pos.x -= player.vel.x;
    }
    if (key==CODED && key == ' ') {
      player.jump();
    }
  }
}
boolean onScreen () {
  if (player.pos.x>0 && player.pos.y>0 &&
    player.pos.x<width && player.pos.y<height) { 
      onScreen();
  }
  return true;
}
