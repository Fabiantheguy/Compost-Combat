// Base Weapon Class
abstract class Weapon {
  String name;
  int damage;
  float weight;
  WeaponState state;
  WeaponBehavior behavior;

  Weapon(String name, int damage, float weight, WeaponBehavior behavior) {
    this.name = name;
    this.damage = damage;
    this.weight = weight;
    this.state = WeaponState.READY;
    this.behavior = behavior;
  }
  

  void performAttack() {
    if (state == WeaponState.READY || state == WeaponState.CHARGING) {
      behavior.attack();
    } else {
      println(name + " is " + state + ", cannot attack!");
    }
  }

  abstract void display(int x, int y);
}

// Factory Pattern: Weapon Factory for Dynamic Weapon Creation
class WeaponFactory {
  public Weapon createWeapon(String type) {
    switch (type) {
      case "Melee":
        return new MeleeWeapon("Combat Knife", 30, 2.5, 100);
      case "Ranged":
        return new RangedWeapon("Sniper Rifle", 90, 15.0, 5);
      case "Energy":
        return new EnergyWeapon("Railgun", 120, 25.0, 100);
      default:
        return null;
    }
  }
}
