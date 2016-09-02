class Box {
  float w, h;

  Body body;

  Box(float x_, float y_) {
    w = 8;
    h = 8;

    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x_, y_));
    body = box2d.createBody(bd);
    body.setBullet(true);

    PolygonShape ps = new PolygonShape();

    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);

    ps.setAsBox(box2dW, box2dH);

    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    body.createFixture(fd);
  }

  Box(float x_, float y_, float h_, float w_, boolean fixed) {
    w = w_;
    h = h_;
    BodyDef bd = new BodyDef();
    bd.type = fixed? BodyType.STATIC : BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x_, y_));
    body = box2d.createBody(bd);
    body.setBullet(true);

    PolygonShape ps = new PolygonShape();

    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);

    ps.setAsBox(box2dW, box2dH);

    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    body.createFixture(fd);
  }

  void display() {
    fill(238);
    noStroke();
    rectMode(CENTER);
    Vec2 pos = box2d.coordWorldToPixels(body.getPosition());
    float angle = body.getAngle();

    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-angle);
    rect(0, 0, w, h);
    popMatrix();
  }
}