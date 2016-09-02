class Boundary {
  
  float x,y;
  float w,h;
  
  Vec2[] vertices;
  
  Body b;
  
  Boundary(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    
    BodyDef bd = new BodyDef();
    bd.position.set(box2d.coordPixelsToWorld(x_, y_));
    bd.type = BodyType.STATIC;
    b = box2d.createBody(bd);
    
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    
    ChainShape chain = new ChainShape();
    
    vertices = new Vec2[2];  
    vertices[0] = box2d.coordPixelsToWorld(0, 150);
    vertices[1] = box2d.coordPixelsToWorld(width, 150);
    
    chain.createChain(vertices, vertices.length);
   
    b.createFixture(chain, 1);
  }
  
  void display() {
    strokeWeight(1);
    stroke(0);
    fill(0);
    
    beginShape();
    for(Vec2 vex: vertices) {
      Vec2 vv = box2d.coordWorldToPixels(vex);
      vertex(vv.x, vv.y);
    }
    endShape(CLOSE);
  }
}