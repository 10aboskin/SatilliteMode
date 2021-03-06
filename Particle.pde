class Particle {
  float maxAcceleration = 0.3;
  float maxVelocity = 4;
  float minLife = 0;
  float maxLife = 30;
  float decayRate = 1.0;
  float maxSize = 16;
  float minSize = 6;
  float colorChangeInt = 6;
  float colorRotoInt = colorChangeInt*7;
  PVector noiseIncrement = new PVector(0.1, 0.1, 0.1);

  color c;
  PVector noff;
  float size;
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifeLeft;

  Particle(PVector l) {
    noff = PVector.random3D().mult(1000);
    acceleration = new PVector();
    velocity = new PVector();    
    position = l.copy();
    lifeLeft = random(minLife, maxLife);
    size = random(minSize, maxSize);

    float time = frameCount/frameRate;
    if (time % colorChangeInt < colorChangeInt/2) {
      c = colors[int(random(1) * colors.length)];
    } else {
      /* color roto */
      for (int i = 1; i <= colors.length; i ++) {
        if (time % colorRotoInt < i*colorRotoInt/colors.length) {
          c = colors[i - 1];
          break;
        }
      }
    }
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
    noStroke();
    fill(c, lifeAlpha);
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