class FrozenPineapple {
  Pineapple pineapple;
  Cylinder ice;
  int cylinderRadius = 45;
  int cylinderHeight = 125;
  int cylinderOffset = -3;
  PVector position;

  FrozenPineapple() {
    position = new PVector(0, 0, 0);
    pineapple = new Pineapple(position);
    ice = new Cylinder(cylinderRadius, cylinderHeight, position.add(new PVector(0, cylinderOffset, 0)));
  }

  FrozenPineapple(int x, int y, int z) {
    position = new PVector(x, y, z);
    pineapple = new Pineapple(position);
    ice = new Cylinder(cylinderRadius, cylinderHeight, position.add(new PVector(0, cylinderOffset, 0)));
  }

  FrozenPineapple(PVector coords) {
    position = coords;
    pineapple = new Pineapple(position);
    ice = new Cylinder(cylinderRadius, cylinderHeight, position.add(new PVector(0, cylinderOffset, 0)));
  }
  
  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    pineapple.display();
    noStroke();
    fill(255, 50);
    ice.display();
    popMatrix();
  }
}