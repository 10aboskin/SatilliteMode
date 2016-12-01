class Beep {
  PVector position;
  ArrayList<PVector> tail;
  float speed = 5;
  float size = 3;
  int tailLength = 50;

  Beep() {
    position = new PVector(-width/2, random(-height/2 + 100, height/2 - 100), 30);
    tail = new ArrayList<PVector>();
  }

  void update() {
    tail.add(new PVector(position.x, position.y, position.z));
    if (tail.size() > tailLength) {
      tail.remove(0);
    }
    position.x += speed;
  }

  void display() {
    
    
    for (int i = tail.size() - 1; i >= 0 ; i --) {
      pushMatrix();
      translate(tail.get(i).x, tail.get(i).y, tail.get(i).z);
      noStroke();
      fill(255, map(i, 0, tail.size(), 0, 255));
      ellipse(0, 0, size, size);
      popMatrix();
    }

    
  }

  void run() {
    update();
    display();
  }
}
