import de.voidplus.leapmotion.*;

import shiffman.box2d.*;

import java.util.*;

import org.jbox2d.collision.shapes.*; 
import org.jbox2d.common.*; 
import org.jbox2d.dynamics.*; 
import org.jbox2d.dynamics.joints.*;

Box2DProcessing box2d;

ArrayList<Box> boxes;

HashMap<Integer, FingerMouse> FingerMap;

LeapMotion leap;
FingerMouse a;

Windmill windmill;

int t = 0;
void setup() {
  smooth(8);
  size(600, 600, P3D);

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -2);

  boxes = new ArrayList<Box>();

  leap = new LeapMotion(this).allowGestures();

  FingerMap = new HashMap<Integer, FingerMouse>();
  
  Body bd = createBody(new Vec2(width/2, height/2), 1);
  
  windmill = new Windmill(width/2, height/2);
}

ArrayList<Body> mHands = new ArrayList<Body>();
ArrayList<Surface> surfaces = new ArrayList<Surface>();
void draw() {
  background(200, 0, 0);
  box2d.step();

  for(Surface sur: surfaces) {
    box2d.destroyBody(sur.b);
  }
  surfaces.clear();
  for(Hand hand: leap.getHands()) {
    ArrayList<Vec2> fingList = new ArrayList<Vec2>();
    for(Finger finger: hand.getFingers()) {
      int id = finger.getId();
    
      PVector pos = finger.getPosition();
      fingList.add(new Vec2(pos.x, pos.y));

//      if(FingerMap.containsKey(id)) {
//        FingerMouse fm = FingerMap.get(id);
//        fm.update(new Vec2(pos.x, pos.y));  
//      } else {
//        Body bd = createBody(new Vec2(pos.x, pos.y), 0.1);
//        FingerMouse fm = new FingerMouse(bd);
//        FingerMap.put(id, fm);
//      }
    }
    surfaces.add(new Surface(fingList));
  }
  
  for(Integer id: FingerMap.keySet()) {
    FingerMouse fm = FingerMap.get(id);
    fm.display();
  }
  
  for(Surface s: surfaces) {
    s.display();
  }


  if (t%2 == 0) {
    Box p = new Box(random(width), 0);
    p.body.setAngularVelocity(random(2));
    boxes.add(p);
  }

  for (Box box : boxes) {
    box.display();
  }
  
  windmill.display();


  t += 1;
  removeUnusedBoxes();
}

void removeUnusedBoxes() {
  for (int i= boxes.size() - 1; i>=0; i--) {
    Box b = boxes.get(i);
    Vec2 pos = box2d.getBodyPixelCoord(b.body);  

    if (pos.x < -10 || pos.x > width + 10 || pos.y < 0 || pos.y > height + 10) {
      box2d.destroyBody(b.body);
      boxes.remove(i);
    }
  }
}

float w = 16;
float h = 16;
Body createBody(Vec2 p, float density) {
  BodyDef bd = new BodyDef();
  bd.type = BodyType.DYNAMIC;
  bd.position.set(box2d.coordPixelsToWorld(p.x, p.y));

  Body body = box2d.createBody(bd);


  PolygonShape ps = new PolygonShape();

  float box2dW = box2d.scalarPixelsToWorld(w/2);
  float box2dH = box2d.scalarPixelsToWorld(h/2);

  ps.setAsBox(box2dW, box2dH);

  body.createFixture(ps, density);

  return body;
}