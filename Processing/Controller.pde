class GameController {
  Map map;
  
  int currentCarIndex = -1;
  Car currentCar;
 
  PGraphics collisionMask;
  
  GameController() {
    map = new Map();
    currentCar = null;
    collisionMask = map.getCollisionMask(0);
  }
  
  void draw() {
    background(0);
    if(currentCar != null) {
      currentCar.setSteeringWheelRotation(map(mouseX, 0, width, -1, 1));
      currentCar.update();
    }
    map.draw();
    
    int hover = map.getCarId(mouseX, mouseY);
    cursor(hover != -1 && hover != currentCarIndex ? HAND : ARROW);
  }
  
  void keyPressed(char k) {
    if(currentCar == null) return;
    if(k == 'w' || k == 'W') currentCar.pressAccelerator();
    else if(k == 's' || k == 'S') currentCar.pressBreak();
    else if(k == '1') currentCar.setGear(Gear.REVERSE);
    else if(k == '2') currentCar.setGear(Gear.NEUTRAL);
    else if(k == '3') currentCar.setGear(Gear.FORWARD);
  }
  
  void keyReleased(char k) {
    if(currentCar == null) return;
    if(k == 'w' || k == 'W') currentCar.releaseAccelerator();
    else if(k == 's' || k == 'S') currentCar.releaseBreak();
  }
  
  void mouseClicked(int x, int y) {
    int hover = map.getCarId(x, y);
    if(hover == -1) {
      if(currentCar != null) {
        currentCar.disable();
        currentCar.stop();
        currentCar.hideControls();
      }
      currentCarIndex = hover;
      currentCar = null;
    }
    else {
      Car newCar = map.getCar(hover);
      if(currentCar == null) {
        newCar.showControls();
        collisionMask = map.getCollisionMask(hover);
        currentCarIndex = hover;
        currentCar = newCar;
      }
      else if(newCar != currentCar) {
        newCar.copyControls(currentCar);
        
        currentCar.disable();
        currentCar.stop();
        currentCar.hideControls();
        
        newCar.showControls();
        collisionMask = map.getCollisionMask(hover);
        
        currentCarIndex = hover;
        currentCar = newCar;
      }
    }
  }
}
