enum Gear {
  REVERSE,
  NEUTRAL,
  FORWARD
}

int N = 7;
PImage[] sprites;

ArrayList<int[]>[] collisionCheckPoints;
// collisionCheckPoints[x].get(y)[z]
// x selects the sprite(type) of car (0 <= x < N)
// y selects the pixel (depends on x)
// z = 0 -> x of pixel, 1 -> y of pixel (z = 0 or z = 1)

void loadImages() {
  sprites = new PImage[N];
  for(int i = 0; i < sprites.length; i++) sprites[i] = loadImage("car" + i + ".png");
}

void addPointNoRepeat(ArrayList<int[]> al, int x, int y) {
  for(int i = 0; i < al.size(); i++)
    if(al.get(i)[0] == x && al.get(i)[1] == y)
      return;
  int[] pixel = {x, y};
  al.add(pixel);
}

void generateCheckCollisionPoints(int w_) {
  collisionCheckPoints = new ArrayList[N]; // Initialize the array

  for (int i = 0; i < N; i++) {
    ArrayList<int[]> al = new ArrayList<int[]>(); // Initialize each ArrayList
    collisionCheckPoints[i] = al;
    
    float w = w_;
    float l = w * sprites[i].height / sprites[i].width;
    
    PGraphics pg = createGraphics(int(w*1.5), int(l*1.5));
    
    int offSet = 2;
    pg.beginDraw();
    pg.clear();
    pg.image(sprites[i], offSet, offSet, w*1.5 - 2 * offSet, l*1.5 - 2 * offSet);
    pg.endDraw();
    
    pg.loadPixels();
    
    for(int x = 0; x < pg.width; x++)
      for(int y = 0; y < pg.height; y++)
        if(alpha(pg.pixels[y*pg.width + x]) != 0) {
          addPointNoRepeat(al, x, y);
          break;
        }
      
    for(int x = 0; x < pg.width; x++)
      for(int y = pg.height-1; y >= 0 ; y--)
        if(alpha(pg.pixels[y*pg.width + x]) != 0) {
          addPointNoRepeat(al, x, y);
          break;
        }
     
    for(int y = 0; y < pg.height; y++)
      for(int x = 0; x < pg.width; x++)
        if(alpha(pg.pixels[y*pg.width + x]) != 0) {
          addPointNoRepeat(al, x, y);
          break;
        }
      
    for(int y = 0; y < pg.height; y++)
      for(int x = pg.width-1; x >= 0 ; x--)
        if(alpha(pg.pixels[y*pg.width + x]) != 0) {
          addPointNoRepeat(al, x, y);
          break;
        }
  }
}

class Car {
  float w, l; // car dimensions
  float wheelDiameter, wheelWidth; // car wheel's dimensions

  float x, y, ghama; // car position and rotation on the world

  float velocity, theta; // angle of the middle front wheel

  float steeringWheelRotation; // between -1 and 1. positive = clockwise
  boolean accelerating, breaking;
  
  Gear gear = Gear.NEUTRAL;
  
  int type;
  
  boolean showControls;
  
  Car(float x_, float y_, float ghama_, float w_, int type_) {
    wheelDiameter = 25;
    wheelWidth = 8;

    x = x_;
    y = y_;
    ghama = ghama_;

    velocity = 0;
    theta = 0;

    steeringWheelRotation = 0;
    accelerating = false;
    breaking = false;
    
    type = type_;
    w = w_;
    l = w * sprites[type].height / sprites[type].width;
    
    showControls = false;
  }
  
  Car(float x_, float y_, float ghama_, float w_) {
    this(x_, y_, ghama_, w_, int(random(sprites.length)));
  }

  void update() {
    float breakingAcceleration = 0.3;
    float acceleration = 0.3;
    float drag = 0.04;
    
    if (breaking) {
      if(velocity > breakingAcceleration) velocity -= breakingAcceleration;
      else if(velocity < -breakingAcceleration) velocity += breakingAcceleration;
      else velocity = 0;
    }
    else if (accelerating) {
      if(gear == Gear.FORWARD) velocity += acceleration;
      else if(gear == Gear.REVERSE) velocity -= acceleration;
    }
    
    if(velocity > drag) velocity -= drag;
    else if(velocity < -drag) velocity += drag;
    else velocity = 0;
    
    velocity = constrain(velocity, -1, 2.5);

    float d = 1 * velocity; // distance = deltaT * velocity
    float dx, dy, dGhama;
    
    float c = cos(ghama);
    float s = sin(ghama);

    if (theta == 0) {
      dGhama = 0;
      dx = d * c;
      dy = d * s;
    } else {
      float TR = l / tan(theta);

      dGhama = d / TR;

      float xf__ = TR * sin(dGhama);
      float yf__ = TR * (1 - cos(dGhama));

      dx = xf__ * c - yf__ * s;
      dy = xf__ * s + yf__ * c;
    }

    x += dx;
    y += dy;
    ghama += dGhama;
  }

  void draw() {
    pushMatrix();
    translate(x, y);
    rotate(ghama);
    
    // draw car
    pushMatrix();
    translate(l/2,0);
    rotate(HALF_PI);
    image(sprites[type],0,0,w*1.5,l*1.5);
    popMatrix();
    
    stroke(255);
    strokeWeight(1);
    fill(0,50);
    
    if(showControls) {
      // back wheels
      rect(0, w/2, wheelDiameter, wheelWidth);
      rect(0, -w/2, wheelDiameter, wheelWidth);
  
      // front wheels
      float thetaE, thetaD;
      if (theta == 0) {
        thetaE = 0;
        thetaD = 0;
      } else {
        float TR = l / tan(theta);
        thetaD = atan(2*l/(2*TR+w));
        thetaE = atan(2*l/(2*TR-w));
      }
  
      pushMatrix();
      translate(l, w/2);
      rotate(thetaE);
      rect(0, 0, wheelDiameter, wheelWidth);
      popMatrix();
  
      pushMatrix();
      translate(l, -w/2);
      rotate(thetaD);
      rect(0, 0, wheelDiameter, wheelWidth);
      popMatrix();
      
      stroke(0);
      strokeWeight(5);
      pushMatrix();
      translate(l/3,0);
      if(gear == Gear.NEUTRAL) {
        circle(0,0,5);
      }
      else {
        rotate((gear == Gear.REVERSE ? 1 : -1) * HALF_PI);
        line(0, -5, 0, 10);
        translate(0,10);
        rotate(QUARTER_PI);
        line(0,0, 0,-5);
        rotate(-HALF_PI);
        line(0,0, 0,-5);
      }
      popMatrix();
    }

    popMatrix();
  }
  
  void draw(PGraphics pg) {
    pg.pushMatrix();
    pg.translate(x, y);
    pg.rotate(ghama);
    
    // draw car
    pg.translate(l/2,0);
    pg.rotate(HALF_PI);
    pg.image(sprites[type],0,0,w*1.5,l*1.5);

    pg.popMatrix();
  }
  
  void drawTrajectory(){
    float limit = 0.01;
    float noFadeLimit = 0.1;
    
    if(abs(theta) < limit) return;
    float fadeLevel = constrain(map(abs(theta), limit, noFadeLimit, 0, 1), 0, 1);
    
    int N = 5;
    float offSet = w*.8;
    
    float TR = l / tan(theta);
    
    float xC = x - TR * sin(ghama);
    float yC = y + TR * cos(ghama);
    
    
    stroke(125, 125*fadeLevel);
    strokeWeight(3);
    noFill();
    for(int i = 0; i < N; i++) {
      circle(xC, yC, 2*(TR + map(i,0,N-1,-offSet,offSet)));
    }
    
    fill(125, 125*fadeLevel);
    
    circle(xC, yC, 20);
    
    pushMatrix();
    translate(x,y);
    rotate(ghama);
    line(0,0,0,TR);
    
    float thetaD = atan(2*l/(2*TR+w));
    float thetaE = atan(2*l/(2*TR-w));
    
    pushMatrix();
    translate(l,-w/2);
    rotate(thetaD);
    line(0,0,0,(TR+w/2)/cos(thetaD));
    popMatrix();
    
    pushMatrix();
    translate(l,w/2);
    rotate(thetaE);
    line(0,0,0,(TR-w/2)/cos(thetaE));
    popMatrix();
    
    popMatrix();
    
  }

  void pressAccelerator() {
    accelerating = true;
  }

  void releaseAccelerator() {
    accelerating = false;
  }

  void pressBreak() {
    breaking = true;
  }

  void releaseBreak() {
    breaking = false;
  }
  
  int setGear(Gear gear_) {
    if(gear_ == Gear.FORWARD && velocity < 0) return 1;
    if(gear_ == Gear.REVERSE && velocity > 0) return 1;
    gear = gear_;
    return 0;
  }

  void setSteeringWheelRotation(float rotation) {
    steeringWheelRotation = rotation;
    theta = map(steeringWheelRotation, -1, 1, -PI/4, PI/4);
  }
  
  float getCenterX() {
    return x + cos(ghama) * l/2;
  }
  
  float getCenterY() {
    return y + sin(ghama) * l/2;
  }
  
  boolean checkCollision(PGraphics collisionMask) {
    PGraphics pg = createGraphics(int(w*1.5), int(l*1.5));
    
    pg.beginDraw();
    pg.clear();
    //pg.stroke(255,255,0);
    //for(int i = 0; i < collisionCheckPoints[type].size(); i++) {
    //  pg.point(collisionCheckPoints[type].get(i)[0], collisionCheckPoints[type].get(i)[1]);
    //}
    pg.translate(pg.width/2,pg.height/2+l/2);
    pg.rotate(-ghama-HALF_PI);
    pg.translate(-x,-y);
    pg.image(collisionMask, 0, 0);
    pg.endDraw();
    
    //image(pg,400,400);
    
    pg.loadPixels();
    
    for(int i = 0; i < collisionCheckPoints[type].size(); i++) {
      if(alpha(pg.pixels[collisionCheckPoints[type].get(i)[0] + collisionCheckPoints[type].get(i)[1] * pg.width]) != 0) return true;
    }
    
    return false;
  }
  
  boolean isInside(int xC, int yC) {
    xC -= x;
    yC -= y;
    
    float c = cos(-ghama);
    float s = sin(-ghama);
    
    float xT = xC * c - yC * s;
    float yT = xC * s + yC * c;
    
    return (xT >= - 0.25 * l && xT <= + 1.25 * l) && (yT >= - 0.75 * w && yT <= + 0.75 * w);
  }
  
  boolean isMoving() {
    return velocity != 0;
  }
  
  void copyControls(Car c) {
    accelerating = c.accelerating;
    breaking = c.breaking;
  }
  
  void disable() {
    accelerating = false;
    breaking = false;
    gear = Gear.NEUTRAL;
  }
  
  void stop() {
    velocity = 0;
  }
  
  void showControls() {
    showControls = true;
  }
  
  void hideControls() {
    showControls = false;
  }
}
