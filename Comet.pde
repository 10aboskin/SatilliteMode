class Comet {
  PVector position;
  ArrayList<PVector> tail;
  float speed = 5;
  float size = 15;
  int tailLength = 10;
  float radius = 200;
  float rotate = 0;

  Comet() {
    position = new PVector(radius, 0, 0);
    tail = new ArrayList<PVector>();
  }

  void update() {
    tail.add(new PVector(position.x, position.y, position.z));
    if (tail.size() > tailLength) {
      tail.remove(0);
    }
    rotate += 0.005;
  }

  void display() {
    rotateZ(rotate * PI/8);
    rotateY(rotate * PI);
    //rotateX(PI/8);
    
    for (int i = tail.size() - 1; i >= 0; i --) {
      pushMatrix();


      translate(tail.get(i).x, tail.get(i).y, tail.get(i).z);
      noStroke();
      fill(228,99,37, map(i, 0, tail.size(), 0, 255));
      sphere(size);
      popMatrix();
    }
  }

  void run() {
    update();
    display();
  }
}