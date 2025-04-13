/*
  Be sure to comment out other people's functions using main functions while coding.
 This is a main setup for the game that handles screen settings, game setup, drawing, and key events.
 */
 
void settings() {
  fullScreen();  // Set the game to fullscreen mode
  }

  void enemySetup() {
      player = new Player(width/2, height - 150);  // Initialize the player at the center horizontally and above the platform vertically
     AppleSetup();  // Initialize the Apple (enemy) and platform setup
    
     orangeSetup(); // initialize orange setup
  }

  void enemyDraw() {
     // Draw the game each frame:
   // AppleDraw();  // Draw the apple (enemy) and handle its movement and behavior
    
    orangeDraw(); //Drawing enemy (orange) 

    player.update();  // Update the player's position, check for movements and gravity
    player.display();  // Display the player as a rectangle
  }

void keyPressed(){
  playerKeyReleased();
}

void keyReleased(){
  playerKeyReleased();
}
