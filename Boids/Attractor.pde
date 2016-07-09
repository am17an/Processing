class Attractor {
  PVector location;
  
  Attractor() {
    location = new PVector(width/2, height/2);
  }
  
  PVector attract(Particle p) {
    PVector force = PVector.sub(location, p.location);
    force.normalize();
    
    return force;
  }
  
  

}