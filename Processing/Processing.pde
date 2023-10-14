GameController control;


void setup() {
  size(900,900);
  
  loadImages();
  generateCheckCollisionPoints(50);
  
  control = new GameController();
  
  rectMode(CENTER);
  imageMode(CENTER);
}

void draw() {
  control.draw();
}

void keyPressed() {
  control.keyPressed(key);
}

void keyReleased() {
  control.keyReleased(key);
}

void mouseClicked() {
  control.mouseClicked(mouseX, mouseY);
}
