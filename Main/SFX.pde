// Implement and check if sounds are played clearly!

import processing.sound.*;
SoundFile button;
SoundFile bullet;
SoundFile hurt;
SoundFile jump;
SoundFile titleScreenMusic;
SoundFile level1Music;
boolean backgroundMusicStarted;
// bullet = new SoundFile(this, "data/BulletSound.mp3");
// button = new SoundFile(this, "data/ButtonButton.mp3");
// jump = new SoundFile(this, "data/JumpSound.mp3");
// hurt = new SoundFile(this, "data/HurtFruit.mp3");

void soundSetup() {
    level1Music = new SoundFile(this, "data/Lvl_1_Compost_Combat.mp3");
    titleScreenMusic = new SoundFile(this, "data/TitleMusic.mp3");

  if(screen != "start") {
    level1Music.stop();
  }
}
