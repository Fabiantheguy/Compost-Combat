
// Strategy Pattern: Defines unique attack behaviors for different weapons
interface WeaponBehavior {
  void attack();
}

class MeleeAttack implements WeaponBehavior {
  public void attack() {
    println("Performing a melee attack!");
  }
}

class RangedAttack implements WeaponBehavior {
  public void attack() {
    println("Firing a ranged weapon!");
  }
}

class EnergyAttack implements WeaponBehavior {
  public void attack() {
    println("Launching an energy blast!");
  }
}

// State Pattern: Tracks weapon states like ready, charging, or overheated
enum WeaponState {
  READY, CHARGING, OVERHEATED, RELOADING
}

// Command Pattern: Executes weapon actions dynamically
interface Command {
  void execute();
}

class FireCommand implements Command {
  Weapon weapon;
  
  FireCommand(Weapon weapon) {
    this.weapon = weapon;
  }
  
  public void execute() {
    println(weapon.name + " fired!");
  }
}

// Observer Pattern: Notifies UI when weapon state changes
interface WeaponObserver {
  void update(String event);
}

class AmmoObserver implements WeaponObserver {
  public void update(String event) {
    println("Ammo updated: " + event);
  }
}
