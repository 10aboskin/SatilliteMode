import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import com.hamoid.*; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SatilliteMode extends PApplet {





/* Constants */
float systemRadius = 8;
float eRadius;
float eRadiusMin = 150;
float eRadiusMax = 200;
int numSystems = 50;
float angle = TWO_PI / numSystems;

/* Global Variables */
Minim minim;
AudioInput in;
AudioPlayer player;
BeatDetect beat;
VideoExport videoExport;
ArrayList<Beep> beeps;
ArrayList<ParticleSystem> nucleus;
ArrayList<ParticleSystem> fire;
Comet comet;
float rotate;

public void setup() {
  /* init */
  //size(1000, 450, P3D);
  
  noCursor();
  frameRate(24);
  
  colorMode(HSB);
  /* initialize global variables */
  videoExport = new VideoExport(this, "rough1.mp4");
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048, 192000.0f);
  player = minim.loadFile("surface.mp3");
  beat = new BeatDetect();
  beeps = new ArrayList<Beep>();
  nucleus = new ArrayList<ParticleSystem>();
  fire = new ArrayList<ParticleSystem>();
  comet = new Comet();
  rotate = 0;
  // make these smoke for distant effect
  for (int i = -width/2; i <= width/2; i += width/6) {
    fire.add(new ParticleSystem(new PVector(i, height/2 + 20)));
  }

  /* populate particle system ArrayList */
  for (int i = 0; i < numSystems + 1; i++) {
    nucleus.add(new ParticleSystem(new PVector(systemRadius*sin(angle*i), systemRadius*cos(angle*i), 0)));
  }
  player.play();
  
}

public void draw() {
  /* init */
  background(0);
  beat.detect(in.mix);
  // directional light
  lights();
  pushMatrix();
  translate(width/2, height/2, 0);
  scale(2);

  /* beeps */
  if (frameCount % 48 == 0) {
    beeps.add(new Beep());
  }
  for (int i = 0; i < beeps.size(); i ++) {
    beeps.get(i).run();
  }

  /* nucleus */
  pushMatrix();
  for (int i = 1; i < nucleus.size(); i++) {
    //int sample = int(map(i, 0, particleSystems.size(), 0, in.bufferSize()));
    float factor = map(in.mix.level(), 0, 0.3f, 1, 7);
    nucleus.get(i).setPosition(nucleus.get(i).origin.mult(factor));
    nucleus.get(i).addParticle();
    nucleus.get(i).run();
    nucleus.get(i).setPosition(nucleus.get(i).origin.mult(1/factor));
  }
  popMatrix();

  /* fire */
  //pushMatrix();
  //for (int i = 1; i < fire.size(); i++) {
  //  fire.get(i).addParticle(100);
  //  fire.get(i).run();
  //}
  //popMatrix();


  // center rings
  for (int i = 1; i <= 3; i ++) {
    pushMatrix();
    rotateY(rotate * PI/i);
    rotateX((rotate + 0.01f) * PI/i);
    rotateZ((rotate + 0.02f) * PI/i);
    stroke(255);
    strokeWeight(2); 
    noFill();

    if (beat.isOnset()) {
      eRadius = eRadiusMax;
    }
    ellipse(0, 0, eRadius + (i * 50), eRadius + (i * 50));
    eRadius *= 0.99f;
    if (eRadius < eRadiusMin) {
      eRadius = eRadiusMin;
    }
    popMatrix();
  }
  
  comet.run();
  popMatrix();
  rotate += 0.01f;
  videoExport.saveFrame();
  if (!player.isPlaying()) {
    exit(); 
  }
}
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

  public void update() {
    tail.add(new PVector(position.x, position.y, position.z));
    if (tail.size() > tailLength) {
      tail.remove(0);
    }
    position.x += speed;
  }

  public void display() {
    
    
    for (int i = tail.size() - 1; i >= 0 ; i --) {
      pushMatrix();
      translate(tail.get(i).x, tail.get(i).y, tail.get(i).z);
      noStroke();
      fill(255, map(i, 0, tail.size(), 0, 255));
      ellipse(0, 0, size, size);
      popMatrix();
    }

    
  }

  public void run() {
    update();
    display();
  }
}

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

  public void update() {
    tail.add(new PVector(position.x, position.y, position.z));
    if (tail.size() > tailLength) {
      tail.remove(0);
    }
    rotate += 0.005f;
  }

  public void display() {
    rotateZ(rotate * PI/8);
    rotateY(rotate * PI);
    //rotateX(PI/8);
    
    for (int i = tail.size() - 1; i >= 0; i --) {
      pushMatrix();


      translate(tail.get(i).x, tail.get(i).y, tail.get(i).z);
      noStroke();
      fill(255, map(i, 0, tail.size(), 0, 255));
      sphere(size);
      popMatrix();
    }
  }

  public void run() {
    update();
    display();
  }
}

class Cylinder {
  PVector position;
  float r;
  float h;
  float sides = 32;

  Cylinder(float r, float h, PVector position) {
    this.position = position.copy();
    this.r = r;
    this.h = h;
  }

  public void display() {
    float angle = 360 / sides;
    float halfHeight = h / 2;
    // draw top shape
    pushMatrix();
    translate(position.x, position.y, position.z);
    rotateX(PI/2);
    beginShape();
    for (int i = 0; i < sides; i++) {
      float x = cos( radians( i * angle ) ) * r;
      float y = sin( radians( i * angle ) ) * r;
      vertex( x, y, -halfHeight );
    }
    endShape(CLOSE);
    // draw bottom shape
    beginShape();
    for (int i = 0; i < sides; i++) {
      float x = cos( radians( i * angle ) ) * r;
      float y = sin( radians( i * angle ) ) * r;
      vertex( x, y, halfHeight );
    }
    endShape(CLOSE);
    // draw body
    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < sides + 1; i++) {
      float x = cos( radians( i * angle ) ) * r;
      float y = sin( radians( i * angle ) ) * r;
      vertex( x, y, halfHeight);
      vertex( x, y, -halfHeight);
    }
    endShape(CLOSE);
    popMatrix();
  }
}
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
  
  public void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    pineapple.display();
    noStroke();
    fill(255, 50);
    ice.display();
    popMatrix();
  }
}
class Kiwi {
  PVector position;
  PImage texture;
  float r;
  float h;
  int sides = 32;

  Kiwi(float r, float h, PVector position) {
    texture = loadImage("Kiwi.png");
    this.position = position.copy();
    this.r = r;
    this.h = h;
  }

  Kiwi(float r, float h) {
    texture = loadImage("Kiwi.png");
    this.position = new PVector(0, 0, 0);
    this.r = r;
    this.h = h;
  }


  public void display() {
    float halfHeight = h / 2;
    float angle = TWO_PI / sides;
    float[][] pointArray = new float[sides][2];
    float[][] imgArray = new float[sides][2];
    for (int i = 0; i < sides; i++) {
      pointArray[i][0] = r * sin(angle*i);
      imgArray[i][0] = texture.width/2 + (texture.width/2) * sin(angle * i);
    }
    for (int i = 0; i < sides; i++) {
      pointArray[i][1] = r * cos(angle*i);
      imgArray[i][1] = texture.height/2 + (texture.height/2) * cos(angle * i);
    }
    pushMatrix();
    noStroke();
    translate(position.x, position.y, position.z);
    // draw top shape
    beginShape();
    texture(texture);
    for (int i=0; i<sides; i++) {
      vertex(pointArray[i][0], pointArray[i][1], -halfHeight, imgArray[i][0], imgArray[i][1]);
    }
    endShape();
    // draw bottom shape
    beginShape();
    texture(texture);
    for (int i = 0; i < sides; i++) {
      vertex(pointArray[i][0], pointArray[i][1], halfHeight, imgArray[i][0], imgArray[i][1]);
    }
    endShape();
    // draw body
    fill(141, 85, 37);
    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < sides + 1; i++) {
      float x = cos(i * angle) * r;
      float y = sin(i * angle) * r;
      vertex( x, y, halfHeight);
      vertex( x, y, -halfHeight);
    }
    endShape(CLOSE);
    popMatrix();
  }
}

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifeLeft;
  float maxAcceleration = 0.3f;
  float maxVelocity = 4;
  float minLife = 0;
  float maxLife = 30;
  float decayRate = 1.0f;
  float size = 6;

  float noiseVal = 0.1f;
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

  public void run() {
    update();
    display();
  }

  // Method to update position
  public void update() {
    randomAcceleration();
    velocity.add(acceleration);
    velocity.limit(maxVelocity);
    position.add(velocity);
    acceleration.mult(0);

    lifeLeft -= decayRate;
  }

  public void applyForce(PVector force) {
    acceleration.add(force);
  }

  public void randomAcceleration() {
    acceleration.x = map(noise(noff.x), 0, 1, -1, 1);
    acceleration.y = map(noise(noff.y), 0, 1, -1, 1);
    acceleration.z = map(noise(noff.z), 0, 1, -1, 1);
    acceleration.mult(maxAcceleration);

    noff.add(noiseIncrement);
  }

  // Method to display
  public void display() {
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
  public boolean isDead() {
    if (lifeLeft < 0.0f) {
      return true;
    } else {
      return false;
    }
  }
}

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  float maxParticles = 5;
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

  public void setPosition(PVector newPosition) {
    origin = newPosition.copy();
  }

  public void addParticle() {
    if (particles.size() <= maxParticles) {
      particles.add(new Particle(origin));
    }
  }

  public void addParticle(float maxLife) {
    if (particles.size() <= maxParticles) {
      particles.add(new Particle(origin, maxLife));
    }
  }

  //void addParticle(PVector position) {
  //  particles.add(new Particle(position));
  //}

  public void run() {
    //moveOriginRandom();
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  public void moveOriginRandom() {
    int choice = PApplet.parseInt(random(4));
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
  
  public void display() {
    pushMatrix();
    rotateX(PI);
    translate(position.x, position.y, position.z);
    noStroke();
    noFill();
    shape(s, 0, 0);
    popMatrix();
  }
}
  public void settings() {  fullScreen(P3D);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--hide-stop", "SatilliteMode" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
