boolean isSwinging=false;

class Vines{
  float upperx,uppery,lowerx,lowery;
  float xSpeed;
  float thickness;
  Vines (float x, float y, float x2, float y2){
    upperx = x;
    uppery = y;
    lowerx = x2;
    lowery = y2;
    xSpeed = 0;
    thickness=30;
  }
  void run(){
    display();
    update();
  }
  
  void display(){
    stroke (#3CDE5B);
    strokeWeight(30);
    strokeCap(PROJECT);
    line (upperx,uppery,lowerx + xSpeed,lowery);
    noStroke();
  }
  void update () {
     
      if (isSwinging) {
          xSpeed = 100 * sin (0.03 * frameCount);
          worm.pos.x = lowerx+xSpeed;
          worm.pos.y = lowery;
          
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
  //getting vine bounds
Rectangle getBounds() {
    return new Rectangle((int)upperx, (int)uppery, (int)lowerx, (int)lowery);
  }


   // Check if the player is on the vine
  boolean onVine(Vines vines) {
    return (vines.lowery + thickness >= player.y && 
            vines.uppery + thickness <= player.y + 10 &&
            vines.lowerx + thickness > player.x && 
            vines.upperx + thickness< player.x + player.w);
  }

  // Check if player is on vine
  boolean isSwinging(Play worm) {
    return getBounds().intersects(worm.getBounds());
  }
  }
