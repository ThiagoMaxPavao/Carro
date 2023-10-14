enum PSpotStyle {
  STRAIGHT,
  ANGLED_RIGHT,
  ANGLED_LEFT,
  PARALLEL
}

class ParkSpot {
  // position and angle
  float x, y, ghama;
  
  // dimensions
  float w,l;
  
  // car parked verification
  int direction; // 0 = both, 1 = front entry, -1 = backEntry
  
  // draw type
  PSpotStyle style;
  
  ParkSpot(float x_, float y_, float ghama_, float w_, PSpotStyle style_) {
    x = x_;
    y = y_;
    ghama = ghama_;
    
    w = w_;
    l = 2*w;
    
    direction = 0;
    
    style = style_;
  }
  
  void draw() {
    float aux = 0.57735026919 * w;
    stroke(255);
    strokeWeight(5);
    pushMatrix();
    translate(x,y);
    rotate(ghama);
    
    // limit
    switch(style) {
    case STRAIGHT:
      line(-l/2,-w/2,l/2,-w/2);
      line(l/2,-w/2,l/2,+w/2);
      line(-l/2,+w/2,l/2,+w/2);
      break;
    case ANGLED_LEFT:
      line(-l/2,-w/2,l/2 + aux,-w/2);
      line(l/2 + aux,-w/2,l/2,+w/2);
      line(-l/2-aux,+w/2,l/2,+w/2);
      break;
    case ANGLED_RIGHT:
      line(-l/2-aux,-w/2,l/2,-w/2);
      line(l/2,-w/2,l/2 + aux,+w/2);
      line(-l/2,+w/2,l/2 + aux,+w/2);
      break;
    default:
      break;
    }
    
    strokeWeight(7);
    // direction arrow 
    if(direction != 0) {
      line(-l/5, 0, l/5, 0);
      rotate(-direction * HALF_PI);
      translate(0,l/5);
      rotate(QUARTER_PI);
      line(0,0, 0,-20);
      rotate(-HALF_PI);
      line(0,0, 0,-20);
    }
    
    popMatrix();
  }
  
  void draw(PGraphics pg) {
    float aux = 0.57735026919 * w;
    pg.stroke(255);
    pg.strokeWeight(5);
    pg.pushMatrix();
    pg.translate(x,y);
    pg.rotate(ghama);
    
    // limit
    switch(style) {
    case STRAIGHT:
      pg.line(-l/2,-w/2,l/2,-w/2);
      pg.line(l/2,-w/2,l/2,+w/2);
      pg.line(-l/2,+w/2,l/2,+w/2);
      break;
    case ANGLED_LEFT:
      pg.line(-l/2,-w/2,l/2 + aux,-w/2);
      pg.line(l/2 + aux,-w/2,l/2,+w/2);
      pg.line(-l/2-aux,+w/2,l/2,+w/2);
      break;
    case ANGLED_RIGHT:
      pg.line(-l/2-aux,-w/2,l/2,-w/2);
      pg.line(l/2,-w/2,l/2 + aux,+w/2);
      pg.line(-l/2,+w/2,l/2 + aux,+w/2);
      break;
    default:
      break;
    }
    
    pg.strokeWeight(7);
    // direction arrow 
    if(direction != 0) {
      pg.line(-l/5, 0, l/5, 0);
      pg.rotate(-direction * HALF_PI);
      pg.translate(0,l/5);
      pg.rotate(QUARTER_PI);
      pg.line(0,0, 0,-20);
      pg.rotate(-HALF_PI);
      pg.line(0,0, 0,-20);
    }
    
    pg.popMatrix();
  }
  
  boolean isCarParkedIn(Car car) {
    float angleTolerance = 0.1;
    float positionTolerance = 10;
    
    if(dist(car.getCenterX(), car.getCenterY(), x, y) > positionTolerance) return false;
    if(direction != -1 && abs(abs(car.ghama - ghama + PI) % TWO_PI - PI) < angleTolerance) return true;
    if(direction != 1 && abs(abs(car.ghama - ghama) % TWO_PI - PI) < angleTolerance) return true;
    return false;
  }
  
  void setDirection(int dir) {
    direction = dir;
  }
}
