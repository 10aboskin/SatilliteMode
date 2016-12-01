import com.hamoid.*;
import ddf.minim.*;
import ddf.minim.analysis.*;


/* Constants */
// 60
float systemRadius = 60;
float eRadius;
float eRadiusMin = 250;
float eRadiusMax = 500;
// 20
int numSystems1 = 20;
//int numSystems2 = numSystems1*2;
//int numSystems3 = numSystems1*3;
int numSystems4 = numSystems1*4;
//float angle1 = TWO_PI / numSystems1;
//float angle2 = TWO_PI / numSystems2;
//float angle3 = TWO_PI / numSystems3;
float angle4 = TWO_PI / numSystems4;

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
//AudioPlayer player;
BeatDetect beat;
VideoExport videoExport;
ArrayList<Beep> beeps;
ArrayList<ParticleSystem> nucleus;
//make an orange
Comet comet;
float rotate;
PShader blur;

void setup() {
  /* init */
  //size(1000, 450, P3D);
  fullScreen(P3D);
  noCursor();
  frameRate(24);
  smooth();
  blur = loadShader("blur.glsl"); 

  /* initialize global variables */
  videoExport = new VideoExport(this, "#4.mp4");
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048, 192000.0);
  //player = minim.loadFile("surface.mp3");
  beat = new BeatDetect();
  beeps = new ArrayList<Beep>();
  nucleus = new ArrayList<ParticleSystem>();
  comet = new Comet();
  rotate = 0;

  /* populate particle system ArrayList */
  //for (int i = 0; i < numSystems1; i++) { 
  //  nucleus.add(new ParticleSystem(new PVector((systemRadius/4)*sin(angle1*i), (systemRadius/4)*cos(angle1*i), 0)));
  //}
  //for (int i = 0; i < numSystems2; i++) { 
  //  nucleus.add(new ParticleSystem(new PVector((2*systemRadius/4)*sin(angle2*i), (2*systemRadius/4)*cos(angle2*i), 0)));
  //}
  //for (int i = 0; i < numSystems3; i++) { 
  //  nucleus.add(new ParticleSystem(new PVector((3*systemRadius/4)*sin(angle3*i), (3*systemRadius/4)*cos(angle3*i), 0)));
  //}
  for (int i = 0; i < numSystems4; i++) { 
    nucleus.add(new ParticleSystem(new PVector(systemRadius*sin(angle4*i), systemRadius*cos(angle4*i), 0)));
  }
  
  
  //player.play();
}

void draw() {
  /* init */
  background(5, 7, 8);

  beat.detect(in.mix);
  //beat.detect(player.mix);
  // directional light
  lights();

  pushMatrix();

  translate(width/2, height/2, 0);
  //scale(2);


  /* beeps */
  //if (frameCount % 48 == 0) {
  //  beeps.add(new Beep());
  //}
  //for (int i = 0; i < beeps.size(); i ++) {
  //  beeps.get(i).run();
  //}

  /* nucleus */
  pushMatrix();

  for (int i = 0; i < nucleus.size(); i++) {
    //int sample = int(map(i, 0, particleSystems.size(), 0, in.bufferSize()));
    float factor = map(in.mix.level(), 0, 0.3, 1, 15);
    //float factor = map(player.mix.level(), 0, 0.3, 1, 5);
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


  // rings
  //for (int i = 1; i <= 3; i ++) {
  //  pushMatrix();

  //  rotateY(rotate * PI/i);
  //  rotateX((rotate + 0.01) * PI/i);
  //  rotateZ((rotate + 0.02) * PI/i);
  //  stroke(20,178,75, 64);
  //  strokeWeight(2); 
  //  noFill();

  //  if (beat.isOnset()) {
  //    eRadius = eRadiusMax;
  //  }
  //  ellipse(0, 0, eRadius + (i * 50), eRadius + (i * 50));
  //  eRadius *= 0.95;
  //  if (eRadius < eRadiusMin) {
  //    eRadius = eRadiusMin;
  //  }
  //  popMatrix();
  //}

  //comet.run();
  filter(blur);
  popMatrix();
  rotate += 0.01;
  //videoExport.saveFrame();
  //if (!player.isPlaying()) {
  //  exit();
  //}
}