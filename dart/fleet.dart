

part of fwf;


class Fleet  extends TouchLayer {
  
  //number of boats for each type
  /*
  var sardineBoatsNum;
  var tunaBoatsNum;
  var sharkBoatsNum;
  var random = new Random();
  
  //multiple boats of each type
  List<Boat> sardineBoats = new List<Boat>();
  List<Boat> tunaBoats = new List<Boat>();
  List<Boat> sharkBoats = new List<Boat>();
  List<Boat> rewardBoats = new List<Boat>();
  */
  
  String name;
  
  List<Boat> boats = new List<Boat>();

  List<Boat> removeBoats = new List<Boat>();
  
  //amount of money 
  num coin;
  
  
  //number of boats in fleet 
  num boatCount;
  num speedMult = 0, capacityMult = 0;
  num speedMultMax = 3;
  
  TouchManager tmanager = new TouchManager();
  
  
  Fleet(int saBoats, int tBoats, int sBoats, this.coin, this.name) {
   
    //creates starting boat fleet and puts boat in the appropriate list 
    boatCount = 0;
    for(var i = 0; i < saBoats; i++){
      this.addBoat('sardine');
    }
    for(var i = 0; i < tBoats; i++){
      this.addBoat('tuna');
    }
    for(var i = 0; i < sBoats; i++){
      this.addBoat('shark');
    }
    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    tmanager.disable();
  }
  
  
  
  
  void fleetStop() {
    for(Boat boat in boats){
      boat.clearPath();
    }
  }

  
  //draw all boats 
  void draw(CanvasRenderingContext2D ctx, num width, num height){
    for(Boat boat in boats){
      boat.draw(ctx, width, height);
    }
  }
  
  
  void show(){
    tmanager.enable();
  }
  
  
  void hide(){
    tmanager.disable();
    for(Boat boat in boats) {
      boat.hide();
    }
  }

  
  void animate() {
    for(Boat boat in boats) {
      boat.animate();
    }
    
    for(Boat boat in removeBoats) {
      boats.remove(boat);
      touchables.remove(boat);
      boatCount--;
    }

    removeBoats.clear();
  }
  

  //creates boat and puts boat in the appropriate list and touchable list 
  void addBoat(var type) {
    Boat boat = new Boat(0, 0, type, name);
    boats.add(boat);
    touchables.add(boat);
    boatCount++;
    harborArrange();
  }
  

  //gives boats position within harbor 
  void harborArrange() {
    num tempStartX;
    num heading;
    
    if(name == 'A'){
      tempStartX = 75;
      heading = 0;
    } else{
      tempStartX = 925;
      heading = PI;
    }
    
    num tempCount = 0;
    
    for (Boat boat in boats) {
      boat.x = tempStartX;
      boat.y = 215 + tempCount * 80;
      boat.harborX = boat.x;
      boat.harborY = boat.y;
      boat.heading = heading;
      boat.clearPath();
      boat.fishCount = 0;
      tempCount++;
    }
  }
  
  
  void animateFishPhaseUnload(var prices) {
    for (Boat boat in boats) {
      if (boat.soldFish) {
        coin += prices[boat.boatType] * (boat.fishCount - boat.oldfishCount);
        boat.soldFish = false;
      }
    }
  }
  
  
  Boat collided(Boat boat) {
    for (Boat b in boats) {
      if (b != boat) {
        num dist = pow((boat.x - b.x), 2) + pow((boat.y - b.y), 2);
        num rad = boat.img.width;
        if(dist < pow(rad, 2)) {
          return b;
        }
      }
    }
    return null;
  }

  
  void upgrade(var upgrade, num upgradeVal) {
    if(upgrade == 'speed'){
      speedMult += 1;
    }
    
    if(upgrade == 'capacity'){
      capacityMult += 1;
    }
    
    for(Boat boat in boats){
      if (upgrade == 'speed') {
        boat.speed += upgradeVal;
      }
      else if (upgrade == 'capacity'){
        boat.capacity += upgradeVal;
      }
    }
    
    if (upgrade == 'reward') {
      Boat newBoat = new Boat(500,400, 'reward', name);
      boats.add(newBoat);
      touchables.add(newBoat);
      ws.send('outcome:win');
    }
    
    if(upgrade == 'park'){
      
    }
  }
  
  
  num fishCount(var fishType){
    int total = 0;
    for (Boat boat in boats) {
      if (boat.boatType == fishType) {
        total += boat.fishCount;
      }
    }
    return total;
  }
}
