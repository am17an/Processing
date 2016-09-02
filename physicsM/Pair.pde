class Pair {
  Box p1, p2;
  
  float len = 32;
  
  Pair(float x, float y) {
    p1 = new Box(x, y);
    p2 = new Box(x + random(-1, 1), y + random(-1, 1));
    
    DistanceJointDef djd = new DistanceJointDef();
    djd.bodyA = p1.body;
    djd.bodyB = p2.body;
    
    djd.length = box2d.scalarPixelsToWorld(len);
    djd.frequencyHz = 4;
    djd.dampingRatio = 0.5;
    
    DistanceJoint dj = (DistanceJoint) box2d.createJoint(djd);
  }
  
  void display() {
    Vec2 pos1 = box2d.getBodyPixelCoord(p1.body);
    Vec2 pos2 = box2d.getBodyPixelCoord(p2.body);
    
    stroke(0);
    line(pos1.x, pos1.y, pos2.x, pos2.y);
    
    p1.display();
    p2.display();
  }
}