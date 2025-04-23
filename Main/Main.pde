import java.awt.Rectangle;
Ground grass;
Sun sun;
Tree tree;
Vine vine1;

void settings(){
  fullScreen();
}

void setup() {
  player = new Player(width/15, height - 150);
  grass = new Ground(-1000, height - 100, width + 3000, 3000);
  sun = new Sun(width - 255, 50);
  tree = new Tree(width, -2100, 200, 3080);
  vine1 = new Vine(width - 300, 480, 75, 500);
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
