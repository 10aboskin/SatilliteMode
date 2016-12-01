class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifeLeft;
  float maxAcceleration = 0.3;
  float maxVelocity = 4;
  float minLife = 0;
  float maxLife = 30;
  float decayRate = 1.0;
  float size = 6;

  float noiseVal = 0.1;
  PVector noiseIncrement = new PVector(noiseVal, noiseVal, noiseVal);
  PVector noff;

  Particle(PVector l) {
    noff = PVector.random3D().mult(1000);
    acceleration = new PVector();
    velocity = new PVector();    
    position = l.copy();
    lifeLeft = random(minLife, maxLife);
  }

  Particle(PVector l, float maxLife) {
    this.maxLife = maxLife;
    noff = PVector.random3D().mult(1000);
    acceleration = new PVector();
    velocity = new PVector();    
    position = l.copy();
    lifeLeft = random(minLife, maxLife);
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    randomAcceleration();
    velocity.add(acceleration);
    velocity.limit(maxVelocity);
    position.add(velocity);
    acceleration.mult(0);

    lifeLeft -= decayRate;
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void randomAcceleration() {
    acceleration.x = map(noise(noff.x), 0, 1, -1, 1);
    acceleration.y = map(noise(noff.y), 0, 1, -1, 1);
    acceleration.z = map(noise(noff.z), 0, 1, -1, 1);
    acceleration.mult(maxAcceleration);

    noff.add(noiseIncrement);
  }

  // Method to display
  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    float lifeAlpha = map(lifeLeft, minLife, maxLife, 55, 255);
    //stroke(255, lifeAlpha);
    //noFill();
    noStroke();
    fill(255, lifeAlpha);
    //fill(255, 204, 0);
    //sphere(size);

    ellipse(0, 0, size, size);

    popMatrix();
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifeLeft < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
