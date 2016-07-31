class Agent {
  float x,y;
  float angle;
  color c;
  
  Agent(float X, float Y) {
    x = X;
    y = Y;
    angle = random(TWO_PI);
    c = getColor();
  }
  
  void update() {
    x += cos(angle);
    y += sin(angle);
    
    angle += map(nc(x, y), 0, 1, 0, TWO_PI);
  }
  
  void display() {
    pushMatrix();
    translate(x, y);
    //rotate(angle);
    point(0, 0);
    float x1 = map(nc(x/noiseScale, y/noiseScale), 0, 1, 100, 240);
    float x2 = map(noise(x/noiseScale, y/noiseScale), 0, 1, 100, 240);
    float x3 = map(noise(x/noiseScale), 0, 1, 0, 200);
    
    //TColor c3 = c1.blend(c2, nc(x/noiseScale, y/noiseScale));
    stroke(c, 10);
    popMatrix();
  }
}