class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  // 6
  float maxParticles = 6;
  float minMovement = 1;
  float maxMovement = 2;

  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
  }

  ParticleSystem() {
    origin = new PVector(0, 0, 0);
    particles = new ArrayList<Particle>();
  }

  void setPosition(PVector newPosition) {
    origin = newPosition.copy();
  }

  void addParticle() {
    if (particles.size() <= maxParticles) {
      particles.add(new Particle(origin));
    }
  }

  void addParticle(float maxLife) {
    if (particles.size() <= maxParticles) {
      particles.add(new Particle(origin, maxLife));
    }
  }

  //void addParticle(PVector position) {
  //  particles.add(new Particle(position));
  //}

  void run() {
    //moveOriginRandom();
    
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  void moveOriginRandom() {
    int choice = int(random(4));
    switch (choice) {
    case 0: 
      origin.x += random(minMovement, maxMovement);
      break;
    case 1: 
      origin.x -= random(minMovement, maxMovement);
      break;
    case 2: 
      origin.y += random(minMovement, maxMovement);
      break;
    case 3: 
      origin.y -= random(minMovement, maxMovement);
    }
  }
}