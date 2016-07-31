import controlP5.*;
import peasy.*;
ControlP5 cp5;
PeasyCam cam;

float a = 1;
float b = 1;

Slider n1S, n2S, n3S, m1S, m2S, n21S, n22S, n23S;

float superShape(float n1, float n2, float n3, float m, float phi) {
  float t1 = pow(abs(1/a * cos(m/4 * phi)), n2);
  float t2 = pow(abs(1/b * sin(m/4 * phi)), n3);

  return pow(t1 + t2, -1/n1);
}

void setup() {
  size(800, 800, P3D);  

  cp5 = new ControlP5(this);

  cam = new PeasyCam(this, 400);


 m1S = cp5.addSlider("m1")
    .setPosition(100, 80)
    .setRange(0, 20)
    .setValue(5);

  n1S = cp5.addSlider("n1")
    .setPosition(100, 100)
    .setRange(0, 100)
    .setValue(1);
  n2S = cp5.addSlider("n2")
    .setPosition(100, 120)
    .setRange(0, 100)
    .setValue(1);
  n3S = cp5.addSlider("n3")
    .setPosition(100, 140)
    .setRange(0, 100)
    .setValue(2);

  m2S = cp5.addSlider("m2")
    .setPosition(600, 100)
    .setRange(0, 100)
    .setValue(5);
    
  n21S = cp5.addSlider("n21")
    .setPosition(600, 120)
    .setRange(0, 100)
    .setValue(1);
  n22S = cp5.addSlider("n22")
    .setPosition(600, 140)
    .setRange(0, 100)
    .setValue(1);
  n23S = cp5.addSlider("n23")
    .setPosition(600, 160)
    .setRange(0, 100)
    .setValue(3);


    cp5.setAutoDraw(false);

  globe = new PVector[latPoints+1][lonPoints+1];
}

int latPoints = 50;
int lonPoints = 100;

PVector[][] globe;

int offset = 0;

float mchange = 0;
void draw() {
  //translate(width/2, height/2);
  mchange += 0.02;
  background(51);
  lights();
  pushMatrix();
  stroke(238);

  float m1  = m1S.getValue();
  float n1 = n1S.getValue();
  float n2 = n2S.getValue();
  float n3 = n3S.getValue();
  
 
  float m2  = m2S.getValue();
  float n21 = n21S.getValue();
  float n22 = n22S.getValue();
  float n23 = n23S.getValue();

  for (int i = 0; i < latPoints; ++i) {
    float theta = map(i, 0, latPoints, -PI, PI);
    float r1 = superShape(n1, n2, n3, m1, theta);
    for (int j = 0; j < lonPoints; ++j) {
      float phi = map(j, 0, lonPoints, -HALF_PI, HALF_PI);
      float r2 = superShape(n21, n22, n23, m2, phi);

      float x = 200*r1*cos(theta)*r2*cos(phi);
      float y = 200*r1*sin(theta)*r2*cos(phi);
      float z = 200*r2*sin(phi);

      globe[i][j] = new PVector(x, y, z);
      point(x, y, z);
    }
  }

  offset += 5;

//  for (int i = 0; i < latPoints; ++i) {
//    float hu = map(i, 0, latPoints, 0, 255*6);
//    noFill();
//    beginShape(TRIANGLE_STRIP);
//    for (int j = 0; j < lonPoints+1; ++j) {
//      PVector v1 = globe[i][j];
//      PVector v2 = globe[i+1][j];
//      vertex(v1.x, v1.y, v1.z);
//      vertex(v2.x, v2.y, v2.z);
//    }
//    endShape();
//  }
  popMatrix();

  gui();
}

void gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  cp5.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}