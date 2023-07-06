
Car carro;

void setup() {
  carro = new Car();
  
  size(500,500);
  
  rectMode(CENTER);
}

void draw() {
  background(0);
  carro.update();
  carro.draw();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      carro.pisaAcelerador();
    } else if (keyCode == DOWN) {
      carro.pisaFreio();
    }  else if (keyCode == LEFT) {
      carro.clicaViraEsquerda();
    }  else if (keyCode == RIGHT) {
      carro.clicaViraDireita();
    } 
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      carro.soltaAcelerador();
    } else if (keyCode == DOWN) {
      carro.soltaFreio();
    }  else if (keyCode == LEFT) {
      carro.soltaViraEsquerda();
    }  else if (keyCode == RIGHT) {
      carro.soltaViraDireita();
    } 
  }
}
