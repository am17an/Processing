import controlP5.*;
import de.voidplus.leapmotion.*;

ControlP5 cp5;
Slider seperateS, seekS, cohesionS, alignS;

LeapMotion leap;

ArrayList<Particle> particles;
Attractor mouseAttractor;
FlowField flow;

int nParticles = 200;
float PERIPHERY = 50;

boolean DEBUG = true;


void setup() {
  size(1200, 600, P2D);
  
  cp5 = new ControlP5(this);
  
  seperateS = cp5.addSlider("seperate")
         .setPosition(30, 40)
         .setRange(0, 1)
         .setValue(0.5);
  seekS = cp5.addSlider("seek")
         .setPosition(30, 60)
         .setRange(0, 1);
  cohesionS =  cp5.addSlider("cohesion")
         .setPosition(30, 80)
         .setRange(0, 1);
  alignS =  cp5.addSlider("align")
         .setPosition(30, 100)
         .setRange(0, 1);
  
  cp5.addToggle("DEBUG")
    .setPosition(30, 120)
    .setSize(20, 20);
  
  smooth();
  
  particles = new ArrayList<Particle>();
  
  
  leap = new LeapMotion(this);
  flow = new FlowField();
  mouseAttractor = new Attractor();
  for(int i = 0 ; i < nParticles; ++i) {
    particles.add(new Particle(random(width), random(height)));
  }
}

ArrayList<PVector> fingers = new ArrayList<PVector>();

void draw() {
  background(51);
  fingers.clear();
  for(Hand hand: leap.getHands()) {
    for(Finger finger: hand.getFingers()) {
      PVector pos = finger.getPosition();
      ellipse(pos.x, pos.y, 20, 20);
      fingers.add(pos);
    }
  }
  for(Particle p: particles) {
    p.closest(fingers);
    p.update();
    p.applyBehaviors(particles);

    p.restrictBounds();
    p.display();
  }
  
}

void keyPressed() {
  if(key == 's') {
    saveFrame("output/####.png");
  }
}