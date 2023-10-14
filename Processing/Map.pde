class Map {
  int size;
  ArrayList<ParkSpot> parkingSpots;
  ArrayList<Car> cars;
  
  PGraphics scenery;
  
  Map() {
    size = 900;
    
    parkingSpots = new ArrayList<ParkSpot>();
    cars = new ArrayList<Car>();
    
    scenery = createGraphics(size, size);
    generateParkingSpots();
  }
  
  void generateParkingSpots() {
    int parkW = 80;
    
    //for(int i = 0; i < 5; i++) parkingSpots.add(new ParkSpot(size/2 - 93, size/2-200 + 100*i, -THIRD_PI/2, parkW, PSpotStyle.ANGLED_LEFT));
    //for(int i = 0; i < 5; i++) parkingSpots.add(new ParkSpot(size/2 + 93, size/2-200 + 100*i, -2.5*THIRD_PI, parkW, PSpotStyle.ANGLED_RIGHT));
    
    for(int i = 0; i < 5; i++) parkingSpots.add(new ParkSpot(size/2-200 + 92*i, size/2 - 100, HALF_PI-THIRD_PI/2, parkW, PSpotStyle.ANGLED_LEFT));
    for(int i = 0; i < 5; i++) parkingSpots.add(new ParkSpot(size/2-200 + 92*i, size/2 + 100, -HALF_PI-THIRD_PI/2, parkW, PSpotStyle.ANGLED_LEFT));
    
    scenery.beginDraw();
    for(int i = 0; i < parkingSpots.size(); i++) parkingSpots.get(i).draw(scenery);
    scenery.endDraw();
  }
  
  void populate(float chance) {
    for(int i = 0; i < parkingSpots.size(); i++) {
      if(random(1) >= chance) continue;
      ParkSpot p = parkingSpots.get(i);
      cars.add(new Car(p.x - 50*cos(p.ghama) + random(-7,7), p.y - 50*sin(p.ghama) + random(-7,7), p.ghama + random(-0.1,0.1), 50));
    }
  }
  
  void draw() {
    image(scenery, size/2, size/2);
    for(int i = 0; i < cars.size(); i++) cars.get(i).draw();
  }
  
  Car getCar(int i) {
    return cars.get(i);
  }
  
  PGraphics getCollisionMask(int carIndex) {
    PGraphics pg = createGraphics(size, size);
    
    pg.beginDraw();
    pg.clear();
    pg.imageMode(CENTER);
    for(int i = 0; i < cars.size(); i++) if(i != carIndex) cars.get(i).draw(pg);
    pg.endDraw();
    
    return pg;
  }
  
  int getCarId(int x, int y) {
    for(int i = 0; i < cars.size(); i++) if(cars.get(i).isInside(x, y)) return i;
    return -1;
  }
}
