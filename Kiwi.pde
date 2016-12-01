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


  void display() {
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