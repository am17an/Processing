
float noiseScale = 1000;
float intensity  = 2000;
int nAgents = 50000;

import toxi.color.*;
import toxi.geom.*;
float t = 0. ;

int nThreads = 1000;
int nAgentsThread = nAgents/nThreads;

import java.util.concurrent.atomic.AtomicInteger;
MyThread[] threads;

ArrayList<Agent> agents = new ArrayList<Agent>();

void setup() {
  size(1200, 1600, P3D);
  smooth();
  background(238);

  for (int i = 0; i < nAgents; ++i) {
    agents.add(new Agent(
      random(width), random(height)));
  }
  
  threads = new MyThread[nThreads];
  
  for(int i = 0; i < nThreads; ++i) {
    threads[i] = new MyThread(nAgentsThread*i, nAgentsThread*(i+1));
  }
}

int done = 0;

void draw() {
  println(frameRate);
  int callsToDraw = 0, threadsReady = 0;
  for (int i = 0; i < nThreads; ++i) {
    if (threads[i].state.get() == 0) {
      threads[i].run();
    } else if (threads[i].state.get() == 1) {
      threadsReady++;
      threads[i].state.set(0);
    }
  }
  t+=0.001;
  println(callsToDraw, threadsReady);

 
}


// COLOR STUFF -- 
TColor c1 = TColor.newARGB(#F20D35);
TColor c2 = TColor.newARGB(#AE0FC9);

//color palette[] = {#000000, #7890A8, #304878, #181848, #F0A818};
color palette[] = {#8B1820, #D2A520, #43437A, #DED5D0};
//color palette[] = {#C5A559, #937843, #E2BC6D, #FBD986, #FFFFC9, #333333, #333333, #333333};

color getColor() {
  return palette[int(random(palette.length))];
}

// NOISE STUFF --

float nc(float x, float y) {
  noiseScale = map(y, 0, height, 100, 1000);
  x /= noiseScale;
  y /= noiseScale;
  float n = 0.0;
  int steps = 3;
  float p = 1;
  for (int i = 0; i < steps; ++i) {
    n += noise(x, y)*p + 4*n;
    p/=4;
    x*=6;
    y*=6;
  }
  return n;
}

void keyPressed() {
  if (key == 's') {
    saveFrame("output/####.png");
  }
}