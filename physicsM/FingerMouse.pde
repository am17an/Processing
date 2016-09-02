class FingerMouse {
  MouseJoint mouseJoint;

  FingerMouse(Body body) {
    MouseJointDef md = new MouseJointDef();
    md.bodyA = box2d.getGroundBody();
    md.bodyB = body;

    md.maxForce = 50;
    md.frequencyHz =5;
    md.dampingRatio = 0.1;

    mouseJoint = (MouseJoint)box2d.world.createJoint(md);
  }

  void update(Vec2 world) {
    Vec2 mouseWorld = box2d.coordPixelsToWorld(world);
    mouseJoint.setTarget(mouseWorld);
  }

  void display() {
    Vec2 pos = box2d.coordWorldToPixels(mouseJoint.getBodyB().getPosition());
    fill(51);
    ellipse(pos.x, pos.y, 10, 10);
  }
}