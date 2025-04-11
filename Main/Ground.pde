class Ground {
  PVector pos;
  PVector area;
  color c;
  
  Ground(float x, float y, float w, float h) {
    pos = new PVector(x, y);
    area = new PVector(w, h);
    c = #00ff00;
  }
  
  void display(){
    fill(c);
    rect(pos.x, pos.y, area.x, area.y);
  }
  
}

void grassDraw(){
  background(#3DCFF2);
  grass.display();
}
