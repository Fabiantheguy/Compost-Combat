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
boolean LEFT, RIGHT, UP, DOWN, W, A, S, D;
// bullet = new SoundFile(this, "data/BulletSound.mp3");
// button = new SoundFile(this, "data/ButtonButton.mp3");
// jump = new SoundFile(this, "data/JumpSound.mp3");
// hurt = new SoundFile(this, "data/HurtFruit.mp3");

void soundSetup() {
  LEFT = false;
  RIGHT = false;
  UP = false;
  DOWN = false;
  W = false;
  A = false;
  S = false;
  D = false;
  bullet = new SoundFile(this, "data/BulletSound.mp3");
  level1Music = new SoundFile(this, "data/Lvl_1_Compost_Combat.mp3");
  titleScreenMusic = new SoundFile(this, "data/TitleMusic.mp3");
  jump = new SoundFile(this, "data/JumpSound.mp3");
  gameOver = new SoundFile(this, "data/GameOver.wav");
  button = new SoundFile(this, "data/ButtonButton.mp3");

  if (screen != "start") {
    level1Music.stop();
  }
  
  if (keyCode == 37){
    LEFT = true;
    if (bullet.isPlaying() == false){
    bullet.play();
    }
  }
  
  if (keyCode == 38){
    UP = true;
    if (bullet.isPlaying() == false){
    bullet.play();
    }
  }
  
  if (keyCode == 39){
    RIGHT = true;
    if (bullet.isPlaying() == false){
    bullet.play();
    }
  }
  
  if (keyCode == 40){
    DOWN = true;
    if (bullet.isPlaying() == false){
    bullet.play();
    }
  }
  
  // W=87, A=65, D=68, S=83  
  if (keyCode == 87){
    W = true;
    if (jump.isPlaying() == false){
    jump.play();
    }
  }  
  
  if(currentHealth <= 1) {
  gameOver.play();
  }
}
