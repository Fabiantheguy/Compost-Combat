import java.awt.Rectangle;
Ground grass;
Sun sun;
Tree tree;

void settings(){
  fullScreen();
}

void setup() {
  player = new Player(width/15, height - 150);
  grass = new Ground(0, height - 100, width, 200);
  sun = new Sun(width - 255, 50);
  tree = new Tree(width, 0, 200, 980);
}

void draw() {
  println(mouseY);
  grassDraw();
  sunDraw();
  treeDraw();  
  player.update();
  player.display();
}

void keyPressed() {
  playerKeyPressed();
}

void keyReleased() {
  playerKeyReleased();
}
