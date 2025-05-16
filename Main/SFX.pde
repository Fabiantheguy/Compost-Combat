// Implement and check if sounds are played clearly!

import processing.sound.*;
SoundFile button;
SoundFile bullet;
SoundFile hurt;
SoundFile jump;
SoundFile level1Music;
boolean backgroundMusicStarted;
// bullet = new SoundFile(this, "data/BulletSound.mp3");
// button = new SoundFile(this, "data/ButtonButton.mp3");
// jump = new SoundFile(this, "data/JumpSound.mp3");
// hurt = new SoundFile(this, "data/HurtFruit.mp3");
<<<<<<< Updated upstream

void soundSetup() {
  if(!backgroundMusicStarted) {
    backgroundMusicStarted = true;
    level1Music = new SoundFile(this, "data/Lvl_1_Compost_Combat.mp3");
    level1Music.loop();  // This will play the song in a loop
  }
}
=======
void jumpSound(){
 if (key == 'w' || key == 'W'){
  if(jump.isPlaying() == false){
   jump.play();
     }
   }
 }

/*void fruitHurt(){
  
}

/* void jump() {
   if (canJump) {
      ySpeed = jumpStrength;
      canJump = false;
      movCurrent = "air";
    }
  }
*/
>>>>>>> Stashed changes
