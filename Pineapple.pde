class Pineapple {
  PShape s;
  PVector position;
  
  Pineapple() {
    s = loadShape("Pineapple.obj");
    position = new PVector(0, 0, 0);
  }
  
  Pineapple(int x, int y, int z) {
    s = loadShape("Pineapple.obj"); 
    position = new PVector(x, y, z);
  }
  
  Pineapple(PVector coords) {
    s = loadShape("Pineapple.obj");
    position = coords;
  }
  
  void display() {
    pushMatrix();
    rotateX(PI);
    translate(position.x, position.y, position.z);
    noStroke();
    noFill();
    shape(s, 0, 0);
    popMatrix();
  }
}