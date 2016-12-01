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

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}