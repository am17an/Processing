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
    x += 2*cos(angle);
    y += 2*sin(angle);
    
    angle += map(nc(x, y), 0, 1, 0, TWO_PI);
  }
  
  void display() {
    pushMatrix();
    translate(x, y);
    //rotate(angle);
    ellipse(0, 0, 5, 5);
    float x1 = map(nc(x/noiseScale, y/noiseScale), 0, 1, 100, 240);
    float x2 = map(noise(x/noiseScale, y/noiseScale), 0, 1, 100, 240);
    float x3 = map(noise(x/noiseScale), 0, 1, 0, 200);
    
    //TColor c3 = c1.blend(c2, nc(x/noiseScale, y/noiseScale));
    //strokeWeight(2);
    noFill();//stroke(c);
    stroke(c);
    //fill(c);
    popMatrix();
  }
}