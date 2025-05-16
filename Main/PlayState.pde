// PlayerState Interface & Concrete State Classes
interface PlayerState {
  // Each state must define how to update the player.
  void update(Play player);
  
  // Each state may define its own display (or you could keep display in Play).
  void display(Play player);
}

// Walking state - default movement behavior
class WalkState implements PlayerState {
  
  // Explicit no-argument constructor
  public WalkState() {
    //empty 
  }

  // Handles movement logic in the walking state 
  public void update(Play player) {
    if (spacePressed && player.upgrades.get("dash") > 0){ // check for dash upgrade
      player.dashStart = millis();
      player.movCurrent = "dash";
    } else if (player.onAnyGround()) {
      if (leftHeld && !rightHeld) {
        player.pos.x -= player.speed;
        player.checkMomentum((player.speed*-1), 0);
      } else if (rightHeld && !leftHeld) {
        player.pos.x += player.speed;
        player.checkMomentum(player.speed, 0);
      } else {
        player.checkMomentum(0, 0);
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
  
  // Handles player display in walking state
  public void display(Play player) {
    // Draw the player normally:
     if (!invincible || (millis() / 100) % 2 == 0) {
      rect(player.pos.x, player.pos.y, player.size.x, player.size.y);
    }
    // println("display walk state");
  } 
}

// Jumping state - manages air movement and gravity
class JumpState implements PlayerState {
  
  // Explicit no-argument constructor
  public JumpState() {
    //empty 
  }
  
  public void update(Play player) {
    
    player.pos.y -= player.jumpVel;
    player.jumpVel -= 0.5;

    if (leftHeld && !rightHeld) {
      player.pos.x -= (player.speed * 0.6);
      player.checkMomentum((player.speed*-0.6), 0);
    } else if (rightHeld && !leftHeld) {
      player.pos.x += (player.speed * 0.6);
      player.checkMomentum((player.speed*0.6), 0);
    } else {
      player.checkMomentum(0, 0); // replace 0s in second input for all of these
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
    // println("update jump state");
  }
  
  // Handles player display while jumping 
  public void display(Play player) {
    if (!invincible || (millis() / 100) % 2 == 0) {
      rect(player.pos.x, player.pos.y, player.size.x * 0.875, player.size.y * 1.125);
    }
    // println("display jump state");
  }
}

// Ducking state - allows crouching and slower movement
class DuckState implements PlayerState {
  
  // Explicit no-argument constructor
  public DuckState() {
    //empty 
  }
  
  // Handles movement logic in the ducking state
  public void update(Play player) {
   if (spacePressed && player.upgrades.get("dash") > 0){
      player.dashStart = millis();
      player.movCurrent = "dash";
    } else if (player.onAnyGround()) {
      if (leftHeld && !rightHeld) {
        player.pos.x -= (player.speed*0.5);
        player.checkMomentum((player.speed*-0.5), 0);
      } else if (rightHeld && !leftHeld) {
        player.pos.x += (player.speed*0.5);
        player.checkMomentum((player.speed*0.5), 0);
      } else {
        player.checkMomentum(0, 0);
      }
      if (downHeld == false) {
        player.movCurrent = "walk";
      }
    } else {
      player.jumpVel = 0;
      player.movCurrent = "jump"; // causes player to fall if they walk off a platform edge
    }
  }
  
   // Handles player display while ducking
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
  
  // Climbing state - handles vertical movement on climbable surfaces
  public void update(Play player) {
    if (leftHeld || rightHeld) {
      if (upPressed) {
        player.jumpVel = player.initJump;
      } else {
        player.jumpVel = 0;
      }
      player.movCurrent = "jump";
    } else {
      if (upPressed && !downHeld) {
        if(player.currentVine.isOnVine(player)){
          player.pos.y -= (player.speed * 0.6);
          player.checkMomentum(0, (player.speed * -0.6));
        } else {
          player.jumpVel = player.initJump;
          player.movCurrent = "jump";
        }
      } else if (downHeld && !upPressed) {
        if(player.onAnyGround()){
          player.movCurrent = "walk";
        } else {
          player.pos.y += (player.speed * 0.6);
          player.checkMomentum(0, (player.speed * 0.6));
        }
      } else {
        player.checkMomentum(0, 0);
      }
    }
  }
  // Handles player display while climbing
   public void display(Play player) {
     if (!invincible || (millis() / 100) % 2 == 0) {
      rect(player.pos.x, player.pos.y, player.size.x, player.size.y);
    }
  }
}

// Dashing state - fast horizontal movement in one direction
class DashState implements PlayerState {
  
  // Explicit no-argument constructor
  public DashState() {
    //empty 
  }
  
  public void update(Play player) {
     if (facingRight){
      player.pos.x += (player.speed*2.5);
      player.checkMomentum((player.speed*2.5), 0);
    } else {
      player.pos.x -= (player.speed*2.5);
      player.checkMomentum((player.speed*-2.5), 0);
    }
    if (millis() - player.dashStart >= player.dashTime){
      player.movCurrent = "walk";
    }
    
    player.checkClimb(); // context-sensitive climbing state update
  }
  
  // Handles player display while dashing
   public void display(Play player) {
     if (!invincible || (millis() / 100) % 2 == 0) {
      rect(player.pos.x, player.pos.y, player.size.x * 1.2, player.size.y * 0.8);
    }
  }
}

// Ready state - the player's weapon is on standby
class ReadyState implements PlayerState {
  
  // Explicit no-argument constructor
  public ReadyState() {
    //empty 
  }
  
  // Each state must define how to update the player.
  public void update(Play player){
    // if aiming matrix is activated, enter firing state
    if (lastAim[0] != "none" || lastAim[1] != "none") {
      player.gunCurrent = "fire";
    }
  };
  
  // Each state may define its own display (or you could keep display in Play).
  public void display(Play player){
    //empty (there is currently nothing to display for this state)
  };
}

// Firing state - the player's weapon is firing
class FiringState implements PlayerState {
  
  // Explicit no-argument constructor
  public FiringState() {
    //empty 
  }
  
  // Each state must define how to update the player.
  public void update(Play player){
    // new 8-directional aiming code
    // had to change this to use key codes
    // 37-40 are in ascending order: left, up, right, down
    if (int(lastAim[0]) == 38) {
      if (int(lastAim[1]) == 37) {
        player.aimRad = PI*1.75; // set value of aim direction (for bullets)
      } else if (int(lastAim[1]) == 39) {
        player.aimRad = PI/4;
      } else {
        player.aimRad = 0;
      }
    } else if (int(lastAim[1]) == 37) {
      player.aimRad = PI*1.5;
      if (int(lastAim[0]) == 40) {
        player.aimRad = PI*1.25;
      }
    } else if (int(lastAim[1]) == 39) {
      player.aimRad = PI/2;
      if (int(lastAim[0]) == 40) {
        player.aimRad = PI*0.75;
      }
    } else if (int(lastAim[0]) == 40) {
      player.aimRad = PI;
    }

    // check if bullet cooldown has elapsed
    if (millis() - player.bulletCd >= player.fireRate) {
      player.bPool.allBullets[player.bPool.nextFree].ready(player.aimRad, player.bulletSpeed, player.momentumX,
                                                           player.momentumY, player.center, player.bulletLife);
      player.bulletCd = millis();
    }

    // if no keys are pressed, exit this state
    if (lastAim[0] == "none" && lastAim[1] == "none") {
      player.gunCurrent = "ready";
    }
  };
  
  // Each state may define its own display (or you could keep display in Play).
  public void display(Play player){
    pushMatrix();
    translate(player.center.x, player.center.y);
    rotate(player.aimRad);
    line(0, 0, 0, -70); // visual aiming line - this is the only reason i push matrix
    popMatrix();
  };
}

// You can also create additional states 
