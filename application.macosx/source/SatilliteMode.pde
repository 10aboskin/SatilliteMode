import com.hamoid.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

/* Constants */
// 60
float systemRadius = 30;
float eRadiusMin = 250;
float eRadiusMax = 500;
// 80
int numSystems = 80;
float angle = TWO_PI / numSystems;

color darkPink = color(241, 119, 118);
color lightPink = color(247, 202, 201);
color orange = color(228, 99, 37);
color yellow = color(243, 205, 41);
color lightGreen = color(20, 178, 75);
color darkGreen = color(18, 90, 46);
color blue = color(29, 75, 153);
color[] colors = {darkGreen, lightGreen, blue, orange, darkPink, yellow, lightPink};

/* Global Variables */
Minim minim;
AudioInput in;
BeatDetect beat;
ArrayList<ParticleSystem> nucleus;
float eRadius;
boolean isFullscreen;
PShader blur;
float rotate;

void setup() {
  /* init */
  size(1000, 450, P3D);
  // fullscreen(2);
  noCursor();
  frameRate(24);
  smooth();
  blur = loadShader("blur.glsl"); 
  
  /* initialize global variables */
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048, 192000.0);
  beat = new BeatDetect();
  isFullscreen = false;
  rotate = 0;

  nucleus = new ArrayList<ParticleSystem>();
  for (int i = 0; i < numSystems; i++) { 
    nucleus.add(new ParticleSystem(new PVector(systemRadius*sin(angle*i), systemRadius*cos(angle*i), 0)));
  }
}

void draw() {
  /* init */
  background(5, 7, 8);
  beat.detect(in.mix);
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateZ(rotate);
  /* nucleus */
  for (int i = 0; i < nucleus.size(); i++) {
    //int sample = int(map(i, 0, particleSystems.size(), 0, in.bufferSize()));
    float factor = map(in.mix.level(), 0, 0.3, 0.1, 10);
    nucleus.get(i).setPosition(nucleus.get(i).origin.mult(factor));
    nucleus.get(i).addParticle();
    nucleus.get(i).run();
    nucleus.get(i).setPosition(nucleus.get(i).origin.mult(1/factor));
  }
  filter(blur);
  popMatrix();
  rotate+=0.00375;
}