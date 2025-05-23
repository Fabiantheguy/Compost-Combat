//usd to define different type of enemies, such as: Apple, Banana

class EnemyType {
  String name;
  float speed;

  EnemyType(String name, float speed) {
    this.name = name;
    this.speed = speed;      
  }
}

//add new type of enemy here
EnemyType appleType = new EnemyType("Apple", 3.0); 
EnemyType bananaType = new EnemyType("Banana", 8.0);
EnemyType orangeType = new EnemyType("Orange", 10.0);
