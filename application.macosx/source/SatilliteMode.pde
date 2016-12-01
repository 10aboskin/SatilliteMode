import com.hamoid.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

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

void setup() {
  /* init */
  //size(1000, 450, P3D);
  fullScreen(P3D);
  noCursor();
  frameRate(24);
  smooth();
  colorMode(HSB);
  /* initialize global variables */
  videoExport = new VideoExport(this, "rough1.mp4");
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048, 192000.0);
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

void draw() {
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
    float factor = map(in.mix.level(), 0, 0.3, 1, 7);
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
    rotateX((rotate + 0.01) * PI/i);
    rotateZ((rotate + 0.02) * PI/i);
    stroke(255);
    strokeWeight(2); 
    noFill();

    if (beat.isOnset()) {
      eRadius = eRadiusMax;
    }
    ellipse(0, 0, eRadius + (i * 50), eRadius + (i * 50));
    eRadius *= 0.99;
    if (eRadius < eRadiusMin) {
      eRadius = eRadiusMin;
    }
    popMatrix();
  }
  
  comet.run();
  popMatrix();
  rotate += 0.01;
  videoExport.saveFrame();
  if (!player.isPlaying()) {
    exit(); 
  }
}