
float truncedMap(float a, float b, float c, float d, float e) {
  return (a >= b && a < c) ? map(a,b,c,d,e) : 0;
}

void setup() {
  int w = 400;
  int h = 300;
  
  PGraphics pg = createGraphics(w, h);
  
  pg.beginDraw();
  
  int sx= -w/2;
  int sy = h/2;
  
  pg.loadPixels();
  for(int x = 0; x<w; x++)
  for(int y = 0; y<h; y++) {
    int index = y*w + x;
    
    float r = dist(x,y,sx,sy);
    float theta = atan2(y-sy,x-sx);
    pg.pixels[index] = color(255, (truncedMap(r,w/2,w/2 + w/2,0,0.5) + truncedMap(r,w/2 + w/2,w/2 + 3*w/4,0.5,0)) *
                                  (truncedMap(abs(theta),0,QUARTER_PI/3,1,0)) * 255);
    
  }
  pg.updatePixels();
  
  pg.endDraw();
  
  pg.save("teste.png");
  
  exit();
}
