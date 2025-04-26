/*
  Be sure to comment out other people's functions using main functions while coding.
  This is a main setup for the game that handles screen settings, game setup, drawing, and key events.
*/

void settings() {
  fullScreen();  // Set the game to fullscreen mode
}

void setup() {
  player = new Player(width/2, height - 150);  // Initialize the player at the center horizontally and above the platform vertically
  AppleSetup();  // Initialize the Apple (enemy) and platform setup
}

void draw() {
  // Draw the game each frame:
  AppleDraw();  // Draw the apple (enemy) and handle its movement and behavior
  player.update();  // Update the player's position, check for movements and gravity
  player.display();  // Display the player as a rectangle
}

void keyPressed() {
  playerKeyPressed();  // Handle key presses for apple-specific behavior (likely for enemy control)
}

void keyReleased() {
  playerKeyReleased();  // Handle key releases for apple-specific behavior (likely for enemy control)
}
