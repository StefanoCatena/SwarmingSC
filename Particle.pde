class Particle {

  PVector location;
  float lifespan;
  float life;
  PVector velocity;
  PVector acceleration;  
  int c;


  Particle() {
    lifespan = 255.;
    life = random(1.5, 3);
    velocity = new PVector(1, 1.8);
    location = new PVector(random(width), random(height));
    acceleration = new PVector(random(1.1, 1.5), random(1.1, 1.5));
  }

  void display() {
    noStroke();
    fill(c, 360, lifespan);
    float x = mouseY;
    x = map(x, 0, height, height/60, height/150);
    ellipse(location.x, location.y, x, x);
  }

  void update() {
    lifespan = lifespan-life;
    PVector mouse = new PVector(mouseX, mouseY);
    PVector dir = PVector.sub(mouse, location);
    dir.normalize();
    dir.mult(1.1);
    acceleration = dir;
    velocity.add(acceleration);
    velocity.limit(22);
    location.add(velocity);
  }

  boolean isDead() { //tag the ball as dead
    if (lifespan < 0.) {

      return true;
    } else {
      return false;
    }
  }
  void reSpawn() { //creates a new ball
    lifespan = 255.;
    location.set(random(width), random(height));
  }

  void run() {
    update();
    display();
  }

  void getc (float col) { //get the value for the color (mapped)
    col = constrain(col, 2, 10000);
    c = int(map(col, 2, 10000, 0, 360));
    
  }
}