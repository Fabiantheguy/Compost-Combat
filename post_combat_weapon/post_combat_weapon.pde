

// Inventory System
ArrayList<Weapon> inventory;
WeaponObserver ammoObserver;
int playerScore = 0;


void setup() {
  size(800, 600);
  inventory = new ArrayList<Weapon>();
  
  // Creating weapons using Factory Pattern
  WeaponFactory factory = new WeaponFactory();

  inventory.add(factory.createWeapon("Melee"));
  inventory.add(factory.createWeapon("Ranged"));
  inventory.add(factory.createWeapon("Energy"));

  // Observer for ammo changes
  ammoObserver = new AmmoObserver();
}

void draw() {
  background(50);
  fill(255);
  textSize(20);
  text("Weapon Inventory:", 50, 50);
  
  drawWeaponDashboard();
  
   // Draw Energy Weapon
  drawEnergyWeapon(100, 300);

  // Draw Melee Weapon
  drawMeleeWeapon(350, 300);

  // Draw Ranged Weapon
  drawRangedWeapon(600, 300);


}

// Draw Weapon Dashboard
void drawWeaponDashboard() {
  fill(30);
  rect(0, height - 100, width, 100); // Background panel
  
  fill(255);
  textSize(20);
  text("Weapon Dashboard:", 20, height - 80);
  text("Score: " + playerScore, width - 200, height - 80); // Display score


  int y = height - 60;
  for (Weapon w : inventory) {
    w.display(20, y);
    y += 20;
 
  }
}

// Function to Draw Energy Weapon
void drawEnergyWeapon(float x, float y) {
  fill(0, 255, 255);
  rect(x, y, 100, 20); // Barrel
  ellipse(x + 100, y + 10, 30, 30); // Energy orb
}

// Function to Draw Melee Weapon (Blade)
void drawMeleeWeapon(float x, float y) {
  fill(150);
  rect(x, y, 15, 100); // Handle
  fill(200);
  triangle(x - 10, y, x + 25, y, x + 7, y - 50); // Blade
}

// Function to Draw Ranged Weapon (Gun)
void drawRangedWeapon(float x, float y) {
  fill(100);
  rect(x, y, 100, 20); // Barrel
  rect(x + 20, y + 20, 30, 40); // Handle
  noFill();
  ellipse(x + 35, y + 40, 20, 10); // Trigger guard
}



// Key Control for Weapons
void keyPressed() {
  for (Weapon w : inventory) {
    if (w instanceof RangedWeapon && (key == 'c' || key == 'f')) {
      RangedWeapon sniper = (RangedWeapon) w;
      if (key == 'c') sniper.performAttack();
      if (key == 'f') new FireCommand(sniper).execute();
      ammoObserver.update("Ammo reduced!");
      playerScore += 10; // Increase score for firing

    } else if (w instanceof EnergyWeapon && (key == 'e' || key == 'r')) {
      EnergyWeapon railgun = (EnergyWeapon) w;
      if (key == 'e') railgun.performAttack();
      if (key == 'r') new FireCommand(railgun).execute();
      playerScore -= 5; // Reduce score if player reloads too much
    } else if (w instanceof MeleeWeapon && (key == 'g' || key == 'h')) {
      MeleeWeapon knife = (MeleeWeapon) w;
      if (key == 'g') knife.performAttack();
      if (key == 'h') new FireCommand(knife).execute();
      playerScore += 20; // Increase score for melee attack

    }
  }
}
