class Bridge {
  //ArrayList<Vec2> points;
  ArrayList<Body> bodies;

  float w = 16;
  float h = 16;

  Bridge(ArrayList<Vec2> p) {

    bodies = new ArrayList<Body>();

    Body prev = createBody(p.get(0), 0);
    bodies.add(prev);
    Body curr = null;
    for (int i = 1; i < p.size(); ++i) {
      float density = (i == p.size() - 1 ? 0:0.5);
      curr = createBody(p.get(i), density);
      bodies.add(curr);
      createJoint(curr, prev);
      prev = curr;
    }
  }


  void display() {
    for (int i = 1 ; i < bodies.size(); ++i) {
      Body a = bodies.get(i);
      Body b = bodies.get(i-1);
      Vec2 pos = box2d.getBodyPixelCoord(a);
      Vec2 pos2 = box2d.getBodyPixelCoord(b);
      println(pos.x, pos.y);
      ellipse(pos.x, pos.y, 10, 10);
      line(pos.x, pos.y, pos2.x, pos2.y);
    }
  }

  Body createBody(Vec2 p, float density) {
    BodyDef bd = new BodyDef();
    bd.type = (density == 0?BodyType.STATIC :BodyType.DYNAMIC);
    bd.position.set(box2d.coordPixelsToWorld(p.x, p.y));

    Body body = box2d.createBody(bd);


    PolygonShape ps = new PolygonShape();

    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);

    ps.setAsBox(box2dW, box2dH);

    body.createFixture(ps, density);

    return body;
  }

  void createJoint(Body a, Body b) {
    DistanceJointDef djd = new DistanceJointDef();
    djd.bodyA = a;
    djd.bodyB = b;
    

    djd.length = box2d.scalarPixelsToWorld(10);
    djd.frequencyHz = 4;
    djd.dampingRatio = 0.5;
    DistanceJoint dj = (DistanceJoint) box2d.createJoint(djd);
  }
}