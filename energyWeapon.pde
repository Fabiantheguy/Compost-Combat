class EnergyWeapon extends Weapon {
  float energyLevel;
  boolean charging;
  float chargeTime;
  float maxCharge;

  EnergyWeapon(String name, int damage, float weight, float energyLevel) {
    super(name, damage, weight, new EnergyAttack());
    this.energyLevel = energyLevel;
    this.charging = false;
    this.chargeTime = 0;
    this.maxCharge = 3.0;
  }
  

  void charge() {
    if (energyLevel > 0) {
      charging = true;
      chargeTime += 0.1;
      println(name + " is charging... Charge Level: " + chargeTime);
      if (chargeTime >= maxCharge) {
        chargeTime = maxCharge; // Prevent overcharging
      }
    }
  }

  void fire() {
    if (charging) {
      charging = false;
      if (energyLevel > 0) {
        int power = (int)(damage * (chargeTime / maxCharge)); // Scale damage
        println(name + " fired! Power: " + power);
        energyLevel -= 10;
      } else {
        println(name + " is overheated!");
      }
      chargeTime = 0; // Reset charge after firing
    }
  }
  
  void recharge() {
    energyLevel = 100; // Reset energy
    println(name + " RECHARGED!");
  }


  void display(int x, int y) {
    fill(255);
    text(name + " | Damage: " + damage + " | Energy: " + energyLevel, x, y);
  }

}
