import java.awt.Rectangle;
Ground grass;
Sun sun;
Tree tree;
Vine vine1;
// sETTING lEVEL;
//boolean Level2= true;

// Adding Platform Class as an array to add multiple to scene
color yellow = #F8FF31,green = #0BA048; //SETS COLORS
Platform[] p;
float platformSize = 150; // SETS HOW WIDE
PVector platformDist = new PVector (100,50);//HOW FAR APART THE PLATFORMS ARE
PVector platformPOS = new PVector (1500,300);//WHERE THE PLATFORMS ARE

// Adding Vines Class
Vines[] vines;
PVector vinesPOS = new PVector (1900, -400);//CHANGE THESE VARIABLES TO KEEP COLLISIONS 
float length = 150; 
void settings() {
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

  // SETTING UP LEVEL 2 PLATFORMS & VINES
  //if (Level2) {
    p = new Platform [5]; // the amount of platforms we need in the scene (# CAN BE ALTERED)
    for (int i =0; i<p.length; i ++ ) {
      p[0] = new Platform (platformPOS.x, platformPOS.y, platformSize, platformSize/3);
      p[1] = new Platform (platformPOS.x + (i * platformDist.x), platformPOS.y, platformSize, platformSize/3);
      p[2] =new Platform (platformPOS.x + (i * platformDist.x *2), platformPOS.y + (i * platformDist.y), platformSize, platformSize/3);
      p[3] = new Platform (platformPOS.x + (i * platformDist.x*3), platformPOS.y + (i * platformDist.y * 2), platformSize, platformSize/3);
      p[4] =new Platform (platformPOS.x + (i * platformDist.x*4), platformPOS.y + (i * platformDist.y/2), platformSize, platformSize/3);
    }
//IN PROGRESS
    vines = new Vines [3]; // the amount of vines we need in the scene (# CAN BE ALTERED)
    for (int i =0; i<vines.length; i ++ ) {
      vines[0] = new Vines (vinesPOS.x, vinesPOS.y, vinesPOS.x, length);
      vines[1] = new Vines (vinesPOS.x + (i * 400), vinesPOS.y, vinesPOS.x + (i * 400), length);
      vines[2] =new Vines (vinesPOS.x + (i * 800), vinesPOS.y,vinesPOS.x +(i * 800), length);
    }
  //}
}


void draw() {
  cameraDraw();
  grassDraw();
  sunDraw();
  treeDraw();
  //if (Level2) {
    for (int i =0; i<p.length; i ++ ) {
      p[i].run();
    }
    //for (int i =0; i<vines.length; i ++ ) {
    //  vines[i].run();
    //}
  //}

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
