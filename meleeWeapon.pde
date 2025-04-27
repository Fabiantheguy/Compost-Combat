// Melee Weapon
class MeleeWeapon extends Weapon {
  int durability;
  float chargeTime;
  float maxCharge;

  MeleeWeapon(String name, int damage, float weight, int durability) {
   super(name, damage, weight, new MeleeAttack());
    this.durability = durability;
    this.chargeTime = 0;
    this.maxCharge = 3.0;
  }

  void charge() {
    if (durability > 0) {
      chargeTime += 0.1;
      println(name + " is charging... Charge Level: " + chargeTime);
      if (chargeTime >= maxCharge) {
        chargeTime = maxCharge; // Prevent overcharging
      }
    }
  }
  
  void attack() {
    if (chargeTime > 0 && durability > 0) {
      int power = (int)(damage * (chargeTime / maxCharge)); // Scale damage
      println(name + " attacked! Power: " + power);
      durability -= 5; // Reduce durability per attack
    } else {
      println(name + " is broken and can't attack!");
    }
    chargeTime = 0; // Reset charge after attack
  }
  
  void display(int x, int y) {
    fill(255);
    text(name + " | Damage: " + damage + " | Durability: " + durability, x, y);
  }
}


 
