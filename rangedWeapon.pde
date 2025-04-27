// Ranged Weapon with Charge Mechanic
class RangedWeapon extends Weapon {
  int ammo;
  float chargeTime;
  float maxCharge;

  RangedWeapon(String name, int damage, float weight, int ammo) {
    super(name, damage, weight, new RangedAttack());
    this.ammo = ammo;
    this.chargeTime = 0;
    this.maxCharge = 2.5;
  }
  
  void charge() {
    if (ammo > 0) {
      chargeTime += 0.1;
      println(name + " is charging... Charge Level: " + chargeTime);
      if (chargeTime >= maxCharge) {
        chargeTime = maxCharge;
      }
    }
  }
  
void fire() {
    if (chargeTime > 0 && ammo > 0) {
      int power = (int)(damage * (chargeTime / maxCharge)); // Scale damage
      println(name + " fired! Power: " + power);
      ammo--;
    } else {
      println(name + " has no ammo!");
    }
    chargeTime = 0; // Reset charge after firing
  }

 void display(int x, int y) {
    fill(255);
    text(name + " | Damage: " + damage + " | Ammo: " + ammo, x, y);
  }
}
