//Variable for enemy
Banana banana;
//BananaPlatform bananaPlatform;

void BananaSetup() {
  banana = new Banana(width / 4, worm.pos.y - 100);
  //bananaPlatform = new BananaPlatform (0, height - 100, width, 20);
}

void BananaDraw() {
  
 banana.display();

}

class Banana {
  
 float x, y;             //position
 float w = 40, h = 40;   //size
 float speed = 3;
 float ySpeed = 0;
 float gravity = 0.8;
 
 Banana(float x, float y) {
   this.x = x;
   this.y = y;
    
 }
 
 void display() {
     fill(100);
     rect(x, y, w, h);
 }
 
}
