boolean isSwinging=false,spacePressed=false;

class Vines{
  float upperx,uppery,lowerx,lowery;
  float xSpeed;
  Vines (float x, float y, float x2, float y2){
    upperx = x;
    uppery = y;
    lowerx = x2;
    lowery = y2;
    xSpeed = 0;
    
  }
  void run(){
    display();
    update();
  }
  
  void display(){
    stroke (green);
    strokeWeight(30);
    strokeCap(PROJECT);
    line (upperx,uppery,lowerx + xSpeed,lowery);
    noStroke();
  }
  void update () {
    isSwinging =player.x >= upperx - 30 && 
    player.x <=lowerx + 25 &&
    player.y > uppery - 50 && 
    player.y < lowery + 40;

      
      if (isSwinging) {
        if(keyPressed && key == ' '){
       
          player.ySpeed = 0;
          isSwinging= false;
        } 
          
          
          xSpeed = 100 * sin (0.03 * frameCount);
          player.x = lowerx+xSpeed;
          player.y = lowery;
          
        }
        cameraMovement();
    }
    
 void cameraMovement() {
  if (player.left) {
    upperx+= cameraMovement;
    lowerx += cameraMovement;
  } else if (player.right) {
    upperx-= cameraMovement;
    lowerx -= cameraMovement;

  }
}
  }
