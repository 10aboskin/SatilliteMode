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

  void display() {
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