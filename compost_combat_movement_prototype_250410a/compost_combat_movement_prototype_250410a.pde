// Nathan Ellis 4/10/2025
// THE PLAN IS SIMPLE:
// Finite State Machine with all player states
// Input to switch states
// Separate FSMs for movement and shooting

Player worm = new Player(400, 600, 5);

void setup(){
  size(800, 800);
}

void draw(){
  background(120, 190, 255);
  
  worm.update();
}
