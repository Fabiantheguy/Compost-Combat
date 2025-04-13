
// Instantiated Orange Enemy - TH
Orange orange;
ParticleSystem ps;
Object object;
color orangeCol=#FF9E00, black= #000000;
float ran = 0;

void orangeSetup() {
  orange= new Orange (width-150, height - 150, 75);
  ps = new ParticleSystem (new PVector (width/2, 50));
  object = new Object (100, height-200, 100);
}
void orangeDraw() {
  orange.display();
  orange.update();
  object.display();
}

class Orange {
  PVector pos;
  float size;
  PVector speed;
  Orange (float x, float y, float s) {
    pos = new PVector (x, y);
    size=s;
    speed = new PVector (-3, 0);
  }

  void display() {
    if (!hitsObject()) {
      fill (orangeCol);
      circle (pos.x, pos.y, size);
    } else if (hitsObject()) {
      ps.addParticle();
      ps.run();
    }
  }
  void update() {
    boolean hitsCorner = (orange.pos.x<0+orange.size/2||orange.pos.x>width-orange.size/2);

    if (onGround(applePlatform)) {
      pos.y= applePlatform.y-size/2;
    }
    //add orange movement
    if (! hitsCorner) {
      pos.x+=speed.x;
    }
    if (hitsCorner) {
      hitsCorner = false;
      pos.x-=speed.x;
    }
    if (seesPlayer()) {
      pos.x+=speed.x*4;
      if (hitsObject()) {
        ps.run();
      }
    }
  }

  boolean seesPlayer() {
    return(dist (player.x, player.y, orange.pos.x, orange.pos.y)<500);
  }
}
// Check if the orange is standing on the platform (to avoid falling through)
boolean onGround(ApplePlatform applePlatform) {
  //Returns true if the orange is above the platform
  return (orange.pos.y + orange.size >= applePlatform.y);
}
boolean hitsObject(){
  boolean hittingObject = dist (object.x,object.y,orange.pos.x+orange.size/2,
  orange.pos.y+ orange.size/2)<100;
  return (hittingObject);
}

class Object {
  float x,y,size;
  Object (float x, float y, float s) {
    this.x=x;
    this.y=y;
    this.size=s;
  }
  void display() {
    fill (black);
    square(x, y, size);
  }
}

class Particle {
  PVector pos, speed, accel;
  int opacity;
  Particle (PVector pos) {
    this.pos= pos;
    pos = orange.pos.copy();
    speed =new PVector (random(-1, 1), random(-2, 0));
    accel =new PVector (0.0, 0.5);
    opacity = 255;
  }
  void display () {
    fill (orangeCol, opacity);
    ellipse(pos.x, pos.y, 8, 8);
  }

  boolean stopParticles() {
    if (opacity <0.0) {
      return true;
    } else {
      return false;
    }
  }
}
Particle particle;
  class ParticleSystem {
    ArrayList<Particle> particles;
    PVector pos;

    ParticleSystem(PVector position) {
      pos = position.copy();
      particles = new ArrayList<Particle>();
    }

    void addParticle() {
      particles.add(new Particle(pos));
    }

    void run () {
      for (int i = particles.size()-1; i >= 0; i--) {
        Particle p = particles.get(i);
        if (p.stopParticles()) {
          particles.remove(i);
        }
      }
    }
  }
