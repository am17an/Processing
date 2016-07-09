class FlowField {
  
  PVector[][] field;
  int cols, rows;
  int resolution;
  
  FlowField() {
    resolution = 10;
    cols = width/resolution;
    rows = height/resolution;
  
  }
  
  PVector lookup(PVector location) {
    float theta = noise(location.x/resolution, location.y/resolution);
    theta = map(theta, 0, 1, 0, TWO_PI);
    return new PVector(cos(theta), sin(theta));
  }
  
  float angle(PVector location) {
    float n =  noise(location.x/resolution, location.y/resolution);
    
    return map(n, 0, 1, 0, TWO_PI);
  }
 
  
  void display() {
    for(int i = 0 ; i < cols ;++i) {
      for(int j = 0 ; j < rows; ++j) {
        pushMatrix();
        translate(i*resolution, j*resolution);
        rotate(angle(new PVector(i*resolution, j*resolution)));
        line(0, 0, 5, 0);
        popMatrix();
      }
    }
  }

}