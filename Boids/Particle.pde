class Particle {

  PVector location;
  PVector velocity;
  PVector acceleration;
   
  PVector nearestFinger = new PVector(width/2, height/2);

  float maxSpeed;
  float maxForce;
  

  Particle(float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);

    maxSpeed = 4;
    maxForce = 0.1;
  }
  
  
  
  
  void closest(ArrayList<PVector> targets) {
    float minDist = 10000;
    PVector closest = new PVector(width/2, height/2);
    
    for(PVector target: targets) {
      // And its in my line of sight
      float dist = PVector.dist(target, location);
      
      if(dist < minDist) {
        minDist = dist;
        closest = target;
      }
    }
    nearestFinger = closest;
    
  }


  // FORCES -- 
  // REF - natureofcode.com
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);
    desired.normalize();

    desired.mult(maxSpeed);

    
    PVector steer = PVector.sub(desired, velocity);

    steer.limit(maxForce);
   
    return steer;
  }

  PVector arrive(PVector target) {
    PVector desired = PVector.sub(target, location);

    float d = desired.mag();
    desired.normalize();

    if (d<100) {
      float m = map(d, 0, 100, 0, maxSpeed);
      desired.mult(m);
    } else {
      desired.mult(maxSpeed);
    }

    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    return steer;
  }
 
  void wander() {
    PVector futureLocation = PVector.add(location, PVector.mult(velocity, 4));
    stroke(238);
    point(futureLocation.x, futureLocation.y);
    line(futureLocation.x, futureLocation.y, location.x, location.y);
    noFill();

    ellipse(futureLocation.x, futureLocation.y, 10, 10);

    float theta = random(TWO_PI);
    PVector futureTarget = 
      new PVector(futureLocation.x + 10*cos(theta), futureLocation.y + 10*sin(theta));


    seek(futureTarget);
  }
  
  boolean inPeriphery(PVector target) {
    boolean visible = false;
    
    PVector v = PVector.sub(target, location);
    float dist = PVector.dist(target, location);
    
    float angleBetween = PVector.angleBetween(velocity, v);
    
    if(angleBetween > -PI/6 && angleBetween < PI/6) {
       if(dist < PERIPHERY) {
         visible = true;
       }
    }
   
    
    
    return visible;
  }

  PVector seperate(ArrayList<Particle> others) {
    float d = 50;
    PVector flee = new PVector(0, 0);
    int count = 0;
    for (Particle p : others) {
      if (p.equals(this)) {
        continue;
      }
      float dist = PVector.dist(p.location, location);

      if (dist < PERIPHERY) {
        PVector desired = PVector.sub(location, p.location);
        desired.normalize();
        desired.div(d);
        flee.add(desired);
        count ++;
      }
    }

    if (count > 0) {
      flee.div(count);

      flee.setMag(maxSpeed);

      PVector steer = PVector.sub(flee, velocity);
      steer.limit(maxForce);

      return steer;
    }
    return flee;
  }

  PVector align(ArrayList<Particle> particles) {
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Particle p : particles) {
      
      if (p.equals(this)) {
        continue;
      }
      
      if (inPeriphery(p.location)) {
        sum.add(p.velocity);
        count++;
        if(inPeriphery(p.location) && DEBUG) {
          line(location.x, location.y, p.location.x, p.location.y);
        }
      }
     
    }
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxSpeed);

      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxForce);

      return steer;
    }
    return sum;
  }

  PVector cohesion(ArrayList<Particle> particles) {
    PVector sum = new PVector(0, 0);
    int count = 0;
    int lcount = 0;

    for (Particle p : particles) {
      if(p.equals(this)) {
        continue;
      }
      if (inPeriphery(p.location)) {
        sum.add(p.location);
        count++;
      }
    }

    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxSpeed);

      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxForce);

      return steer;
      
    }
    return sum;
  }
  
  void applyBehaviors(ArrayList<Particle> particles) {
    PVector seperate = seperate(particles);
    PVector seek     = arrive(nearestFinger);
    PVector cohesion = cohesion(particles);
    PVector align    = align(particles);

    seperate.mult(seperateS.getValue());
    seek.mult(seekS.getValue());
    cohesion.mult(cohesionS.getValue());
    align.mult(alignS.getValue());

    applyForce(seek);
    applyForce(seperate);
    applyForce(cohesion);
    applyForce(align);
  }

  void restrictBounds() {

    float bounds = 20;

    PVector desired = velocity.copy();
    if (location.x + bounds > width ) {
      desired = new PVector(-maxSpeed, velocity.y);
    } else if (location.x - bounds < 0) {
      desired = new PVector(maxSpeed, velocity.y);
    } else if (location.y + bounds > height) {
      desired = new PVector(velocity.x, -maxSpeed);
    } else if (location.y - bounds < 0) {
      desired = new PVector(velocity.x, maxSpeed);
    }

    PVector steer   = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }

  void display() {
    pushMatrix();
    translate(location.x, location.y, location.z);
    float theta = velocity.heading()  - PI/2;
    rotate(theta);
    stroke(238, map(PVector.dist(location, nearestFinger), 0, 100, 50, 255));
    //stroke(238);
    noFill();
    if(DEBUG) {
      arc(0., 0., PERIPHERY, PERIPHERY, -PI/6  + PI/2, PI/6 + PI/2);
      //text(degrees(velocity.heading()), 0, 0);
    }
    
    line(-5, 0, 0, 5);
    line(5, 0, 0, 5);
    popMatrix();
  }

  void applyForce(PVector force) {
    force.limit(maxForce);

    acceleration.add(force);
  }

  void update() {
    location.add(velocity);
    velocity.add(acceleration);
    velocity.limit(maxSpeed);

    acceleration.mult(0);
  }
}