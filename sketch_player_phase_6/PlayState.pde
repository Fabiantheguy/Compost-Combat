// PlayerState Interface & Concrete State Classes
interface PlayerState {
  // Each state must define how to update the player.
  void update(Play player);
  
  // Each state may define its own display (or you could keep display in Play).
  void display(Play player);
}

class WalkState implements PlayerState {
  
  // Explicit no-argument constructor
  public WalkState() {
    //empty 
  }

  public void update(Play player) {
  if (spacePressed && player.upgrades.get("dash") > 0){ // check for dash upgrade
      player.dashStart = millis();
      player.movCurrent = "dash";
    } else if (player.onAnyGround()) {
      if (leftHeld) {
        player.pos.x -= player.speed;
      }
      if (rightHeld) {
        player.pos.x += player.speed;
      }
      if (upPressed) {
        player.jumpVel = player.initJump;
        player.movCurrent = "jump";
      } else if (downHeld) {
        player.movCurrent = "duck";
      }
    } else {
     player.jumpVel = 0;
      player.movCurrent = "jump"; // causes player to fall if they walk off a platform edge
    }
    
    player.checkClimb(); // context-sensitive climbing state update
  }
  
  public void display(Play player) {
    // Draw the player normally:
     if (!invincible || (millis() / 100) % 2 == 0) {
      rect(player.pos.x, player.pos.y, player.size.x, player.size.y);
    }
     println("display walk state");
  } 
}


class JumpState implements PlayerState {
  
  // Explicit no-argument constructor
  public JumpState() {
    //empty 
  }
  
  public void update(Play player) {
    
    player.pos.y -= player.jumpVel;
    player.jumpVel -= 0.5;

    if (leftHeld) {
      player.pos.x -= (player.speed * 0.6);
    }
    if (rightHeld) {
      player.pos.x += (player.speed * 0.6);
    }

    // Use collision detection instead of hardcoded Y
    if (player.onAnyGround()) {
      player.jumpVel = 0;
      player.movCurrent = "walk";
    }
    
    player.checkClimb(); // context-sensitive climbing state update
    
    // dash
    if (spacePressed && player.upgrades.get("dash") > 0){
      player.dashStart = millis();
      player.movCurrent = "dash";
    }
    println("update jump state");
  }
  
  public void display(Play player) {
    if (!invincible || (millis() / 100) % 2 == 0) {
      rect(player.pos.x, player.pos.y, player.size.x * 0.875, player.size.y * 1.125);
    }
    println("display jump state");
  }
}


class DuckState implements PlayerState {
  
  // Explicit no-argument constructor
  public DuckState() {
    //empty 
  }
  
  public void update(Play player) {
   if (spacePressed && player.upgrades.get("dash") > 0){
      player.dashStart = millis();
      player.movCurrent = "dash";
    } else if (player.onAnyGround()) {
      if (leftHeld) {
        player.pos.x -= (player.speed*0.5);
      }
      if (rightHeld) {
        player.pos.x += (player.speed*0.5);
      }
      if (downHeld == false) {
        player.movCurrent = "walk";
      }
    } else {
      player.jumpVel = 0;
      player.movCurrent = "jump"; // causes player to fall if they walk off a platform edge
    }
  }
  
   public void display(Play player) {
     if (!invincible || (millis() / 100) % 2 == 0) {
      rect(player.pos.x, player.pos.y, player.size.x * 1.125, player.size.y * 0.875);
    }
  }
}

class ClimbState implements PlayerState {
  
  // Explicit no-argument constructor
  public ClimbState() {
    //empty 
  }
  
  public void update(Play player) {
    if (leftHeld || rightHeld) {
      if (upPressed) {
        player.jumpVel = player.initJump;
      } else {
        player.jumpVel = 0;
      }
      player.movCurrent = "jump";
    } else {
      if (upPressed) {
        player.pos.y -= (player.speed * 0.6);
      }
      if (downHeld) {
        player.pos.y += (player.speed * 0.6);
      }
    }
  }
  
   public void display(Play player) {
     if (!invincible || (millis() / 100) % 2 == 0) {
      rect(player.pos.x, player.pos.y, player.size.x, player.size.y);
    }
  }
}

class DashState implements PlayerState {
  
  // Explicit no-argument constructor
  public DashState() {
    //empty 
  }
  
  public void update(Play player) {
     if (facingRight){
      player.pos.x += (player.speed*2.5);
    } else {
      player.pos.x -= (player.speed*2.5);
    }
    if (millis() - player.dashStart >= player.dashTime){
      player.movCurrent = "walk";
    }
    
    player.checkClimb(); // context-sensitive climbing state update
  }
  
   public void display(Play player) {
     if (!invincible || (millis() / 100) % 2 == 0) {
      rect(player.pos.x, player.pos.y, player.size.x * 1.2, player.size.y * 0.8);
    }
  }
}

// You can also create additional states like ClimbState, DashState, etc
