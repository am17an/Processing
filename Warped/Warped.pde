
float noiseScale = 1000;
float intensity  = 200;
int nAgents = 100;

import toxi.color.*;
import toxi.geom.*;
float t = 0. ;

int nThreads = 100;
int nAgentsThread = nAgents/nThreads;

import java.util.concurrent.atomic.AtomicInteger;
MyThread[] threads;

ArrayList<Agent> agents = new ArrayList<Agent>();

void setup() {
  size(600, 600, P3D);
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
  t+=0.01;
  println(callsToDraw, threadsReady);

 
}


// COLOR STUFF -- 
TColor c1 = TColor.newARGB(#F20D35);
TColor c2 = TColor.newARGB(#AE0FC9);

//color palette[] = {#000000, #7890A8, #304878, #181848, #F0A818};
color palette[] = {#333333};
//color palette[] = {#C5A559, #937843, #E2BC6D, #FBD986, #FFFFC9, #333333, #333333, #333333};

color getColor() {
  return palette[int(random(palette.length))];
}

// NOISE STUFF --

float nc(float x, float y) {
  noiseScale = 2000;
  x /= noiseScale;
  y /= noiseScale;
  
  //return noise(x, y, t);
  float n = 0.0;
  int steps = 5;
  float p = 1;
  for (int i = 0; i < steps; ++i) {
    n += noise(x, y)*p + 4*n;
    p/=4;
    x*=3;
    y*=3;
  }
  return n;
}

void keyPressed() {
  if (key == 's') {
    saveFrame("output/####.png");
  }
}