class Car {
  float x, y, angulo, velocidade, curva, aceleracao;
  
  boolean pisandoAcelerador, pisandoFreio;
  boolean virandoDireita, virandoEsquerda;
  
  Car() {
    x = 0;
    y = 0;
    angulo = 0;
    curva = 0;
    velocidade = 0;
    aceleracao = 0;
    
    pisandoAcelerador = false;
    pisandoFreio = false;
  }
  
  void update() {
    // verifica aceleracoes
    if(virandoEsquerda && !virandoDireita) curva = -.03;
    else if(!virandoEsquerda && virandoDireita) curva = .03;
    else curva = 0;
    
    if(pisandoFreio) aceleracao = -.2;
    else if(pisandoAcelerador) aceleracao = .1;
    else aceleracao = 0;
    
    // atualiza velocidades
    angulo += curva;
    velocidade += aceleracao;
    velocidade -= 0.01;
    velocidade = constrain(velocidade, 0, 3);
    
    // atualiza posicao
    x += velocidade * cos(angulo);
    y += velocidade * sin(angulo);
  }
  
  void draw() {
    pushMatrix();
    translate(x, y);
    rotate(angulo);
    rect(0, 0, 50, 25);
    popMatrix();
  }
  
  void pisaAcelerador() {
    pisandoAcelerador = true;
  }
  
  void soltaAcelerador() {
    pisandoAcelerador = false;
  }
  
  void pisaFreio() {
    pisandoFreio = true;
  }
  
  void soltaFreio() {
    pisandoFreio = false;
  }
  
  
  void clicaViraDireita() {
    virandoDireita = true;
  }
  
  void soltaViraDireita() {
    virandoDireita = false;
  }
  
  void clicaViraEsquerda() {
    virandoEsquerda = true;
  }
  
  void soltaViraEsquerda() {
    virandoEsquerda = false;
  }
}
