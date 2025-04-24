import java.awt.Rectangle;
Ground grass;
Sun sun;
Tree tree;
Vine vine1;
// Adding Platform Class as an array to add multiple to scene
Platform[] p;
int platformSize = 250;
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
  
  p = new Platform [5]; // the amount of platforms we need in the scene (# CAN BE ALTERED)
  for (int i =0; i<p.length; i ++ ){
    p[0] = new Platform (width , 460, platformSize, 50);
    p[1] = new Platform (300 + (i * 100) ,100,platformSize,50);
    p[2] =new Platform (300 + (i * 200),100 + (i * 50),platformSize,50);
    p[3] = new Platform (300+ (i * 200),100 + (i * 100),platformSize,50);
    p[4] =new Platform (100+ (i * 300),100+ (i * 25),platformSize,50);
  }
  
}


void draw() {
  cameraDraw();
  grassDraw();
  sunDraw();
  treeDraw();  
  for (int i =0; i<p.length; i ++ ){
    p[i].run();   
  }
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
