import java.awt.Rectangle;
Ground grass;
Sun sun;
Tree tree;

void settings(){
  fullScreen();
}

void setup() {
  player = new Player(width/15, height - 150);
  grass = new Ground(-500, height - 100, width + 1000, 200);
  sun = new Sun(width - 255, 50);
  tree = new Tree(width, 0, 200, 980);
  camPos = new PVector(0, 0);
  camTarget = new PVector(0, 0);
}


void draw() {
  
  cameraDraw();
  grassDraw();
  sunDraw();
  treeDraw();  
  player.update();
  player.display();
  popMatrix();
}



void keyPressed() {
  playerKeyPressed();
}

void keyReleased() {
  playerKeyReleased();
}
