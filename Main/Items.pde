enum ItemType {
  HEALTH, FIRERATE
}

class Item {
  PVector pos;
  float size = 30;
  ItemType type;
  boolean active = true;

  Item(float x, float y, ItemType t) {
    pos = new PVector(x, y);
    type = t;
  }

  void display() {
    if (!active) return;

    if (type == ItemType.HEALTH) {
      fill(255, 0, 0);  // Red for health
    } else if (type == ItemType.FIRERATE) {
      fill(0, 0, 255);  // Blue for fire rate
    }
    ellipse(pos.x, pos.y, size, size);
  }

  void checkPickup(Play player) {
    if (!active) return;

    Rectangle playerRect = player.getBounds();
    Rectangle itemRect = new Rectangle((int)pos.x - 15, (int)pos.y - 15, 30, 30);

    if (playerRect.intersects(itemRect)) {
      if (type == ItemType.HEALTH && currentHealth < maxHealth) {
        currentHealth++;
      } else if (type == ItemType.FIRERATE) {
        player.fireRate = 25;                          // Fast shooting
        player.boostEndTime = millis() + 5000;         // 5 second duration
        player.boosted = true;
      }

      active = false;
    }
  }
}
