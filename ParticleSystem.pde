class ParticleSystem {
  ArrayList<Particle> pl;

  ParticleSystem() {
    pl = new ArrayList<Particle>();
  }

  void addParticle() {
    float x = mouseX;
    x = map(x, 0, width, 1, 50);
    while (pl.size()-1 < x)
      pl.add(new Particle());
  }

  void run(float bright) {
    for (int i = pl.size()-1; i >= 0; i--) {
      Particle p = pl.get(i); 
      p.run();
      p.getc(bright);
      if (p.isDead()) {
        pl.remove(i);
        p.reSpawn();
      }
      }
    }
    
    void sleep(){
      for (int i = pl.size()-1; i >= 0; i--) {
      Particle p = pl.get(i);
      p.run();
      }
    }
    
  }