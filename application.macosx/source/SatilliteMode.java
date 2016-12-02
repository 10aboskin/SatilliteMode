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
// 60
float systemRadius = 30;
float eRadiusMin = 250;
float eRadiusMax = 500;
// 80
int numSystems = 80;
float angle = TWO_PI / numSystems;

int darkPink = color(241, 119, 118);
int lightPink = color(247, 202, 201);
int orange = color(228, 99, 37);
int yellow = color(243, 205, 41);
int lightGreen = color(20, 178, 75);
int darkGreen = color(18, 90, 46);
int blue = color(29, 75, 153);
int[] colors = {darkGreen, lightGreen, blue, orange, darkPink, yellow, lightPink};

/* Global Variables */
Minim minim;
AudioInput in;
BeatDetect beat;
ArrayList<ParticleSystem> nucleus;
float eRadius;
boolean isFullscreen;
PShader blur;
float rotate;

public void setup() {
  /* init */
  
  // fullscreen(2);
  noCursor();
  frameRate(24);
  
  blur = loadShader("blur.glsl"); 
  
  /* initialize global variables */
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048, 192000.0f);
  beat = new BeatDetect();
  isFullscreen = false;
  rotate = 0;

  nucleus = new ArrayList<ParticleSystem>();
  for (int i = 0; i < numSystems; i++) { 
    nucleus.add(new ParticleSystem(new PVector(systemRadius*sin(angle*i), systemRadius*cos(angle*i), 0)));
  }
}

public void draw() {
  /* init */
  background(5, 7, 8);
  beat.detect(in.mix);
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateZ(rotate);
  /* nucleus */
  for (int i = 0; i < nucleus.size(); i++) {
    //int sample = int(map(i, 0, particleSystems.size(), 0, in.bufferSize()));
    float factor = map(in.mix.level(), 0, 0.3f, 0.1f, 10);
    nucleus.get(i).setPosition(nucleus.get(i).origin.mult(factor));
    nucleus.get(i).addParticle();
    nucleus.get(i).run();
    nucleus.get(i).setPosition(nucleus.get(i).origin.mult(1/factor));
  }
  filter(blur);
  popMatrix();
  rotate+=0.00375f;
}
class Particle {
  float maxAcceleration = 0.3f;
  float maxVelocity = 4;
  float minLife = 0;
  float maxLife = 30;
  float decayRate = 1.0f;
  float maxSize = 16;
  float minSize = 6;
  float colorChangeInt = 8;
  PVector noiseIncrement = new PVector(0.1f, 0.1f, 0.1f);

  int c;
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

    if (millis() % 4000 < 2000) {
      float choice = random(1);
      if (choice < 0.25f) {
        c = darkPink;
      } else if (choice > 0.25f && choice < 0.5f) {
        c = orange;
      } else if (choice > 0.5f && choice < 0.75f) {
        c = lightGreen;
      } else if (choice > 0.75f) {
        c = blue;
      }
    } else {
      /* color roto */
      float time = frameCount/frameRate;
      for (int i = 1; i <= 7; i ++) {
        if (time % colorChangeInt < i*colorChangeInt/7) {
          c = colors[i - 1];
          break;
        }
      }
    }
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
    noStroke();
    fill(c, lifeAlpha);
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

  public void setPosition(PVector newPosition) {
    origin = newPosition.copy();
  }

  public void addParticle() {
    if (particles.size() <= maxParticles) {
      particles.add(new Particle(origin));
    }
  }

  public void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
  public void settings() {  size(1000, 450, P3D);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SatilliteMode" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
