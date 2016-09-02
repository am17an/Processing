class Surface {
  ArrayList<Vec2> surface;
  Body b;

  Surface(ArrayList<Vec2> s) {

    surface = new ArrayList<Vec2>();
    for(Vec2 vec: s) {
      Vec2 c = new Vec2(vec);
      surface.add(new Vec2(c));
    }

    ChainShape chain = new ChainShape();

    // Make an array of Vec2 for the ChainShape.
    Vec2[] vertices = new Vec2[surface.size()];


    for (int i = 0; i < vertices.length; i++) {
      //[offset-up] Convert each vertex to Box2D World coordinates.
      vertices[i] = box2d.coordPixelsToWorld(surface.get(i));
    }

    // Create the ChainShape with array of Vec2.
    chain.createChain(vertices, vertices.length);

    //[full] Attach the Shape to the Body.
    BodyDef bd = new BodyDef();
    Body body = box2d.world.createBody(bd);
    body.createFixture(chain, 1);
    
    b = body;
    //[end]
  }

  void display() {
    strokeWeight(1);
    stroke(0);
    noFill();
    //[full] Draw the ChainShape as a series of vertices.
    beginShape();
    strokeWeight(4);
    stroke(238);
    for(int i = 1 ; i < surface.size(); ++i) {
      Vec2 p = surface.get(i);
      Vec2 p2 = surface.get(i-1);
      
      line(p.x, p.y, p2.x, p2.y);
    }
    //[end]
    endShape();
  }
}