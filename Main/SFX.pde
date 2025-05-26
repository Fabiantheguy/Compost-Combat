// Implement and check if sounds are played clearly!

import processing.sound.*;
SoundFile button;
SoundFile bullet;
SoundFile hurt;
SoundFile jump;
SoundFile titleScreenMusic;
SoundFile level1Music;
SoundFile gameOver;
boolean backgroundMusicStarted;
// bullet = new SoundFile(this, "data/BulletSound.mp3");
// button = new SoundFile(this, "data/ButtonButton.mp3");
// jump = new SoundFile(this, "data/JumpSound.mp3");
// hurt = new SoundFile(this, "data/HurtFruit.mp3");

void soundSetup() {
  bullet = new SoundFile(this, "data/BulletSound.mp3");
  level1Music = new SoundFile(this, "data/Lvl_1_Compost_Combat.mp3");
  titleScreenMusic = new SoundFile(this, "data/TitleMusic.mp3");
  jump = new SoundFile(this, "data/JumpSound.mp3");
  gameOver = new SoundFile(this, "data/GameOver.wav");
  button = new SoundFile(this, "data/ButtonButton.mp3");
}

void playSFX(){
  
  if (worm.gunCurrent == "fire" && bullet.isPlaying() == false){
    bullet.play();
  }
  
  // W=87, A=65, D=68, S=83  
  if (worm.movCurrent == "jump" && jump.isPlaying() == false){
    jump.play();
  }  
  
  if(currentHealth <= 0 && gameOver.isPlaying() == false) {
    gameOver.play();
  }
}
