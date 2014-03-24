

part of fwf;


class Fleet  extends TouchLayer{
  //number of boats for each type 
  var sardineBoatsNum;
  var tunaBoatsNum;
  var sharkBoatsNum;
  var random = new Random();
  
  //multiple boats of each type
  List<Boat> boats = new List<Boat>();

  
  List<Boat> removeBoats = new List<Boat>();
  
  //amount of money 
  num coin;
  
  //which fleet type either A or B
  var fleetAB;
  
  //number of boats in fleet 
  num boatCount;
  num speedMult = 0, capacityMult = 0;
  num speedMultMax = 3;
  
  TouchManager tmanager = new TouchManager();
  
  Fleet(this.sardineBoatsNum, this.tunaBoatsNum, this.sharkBoatsNum, this.coin, this.fleetAB){
    
    num tempStartX;
    if(fleetAB == 'A' || fleetAB == 'B'){
      if(fleetAB == 'A'){
        tempStartX = 75;
      }
      else{
        tempStartX = 925;
      }
    }
    else{
      print("error, not valid fleet type");
    }
    

    //creates starting boat fleet and puts boat in the appropriate list 
    boatCount = 0;
    for(var i = 0; i < sardineBoatsNum; i++){
      this.addBoat('sardine');
    }
    for(var i = 0; i < tunaBoatsNum; i++){
      this.addBoat('tuna');
    }
    for(var i = 0; i < sharkBoatsNum; i++){
      this.addBoat('shark');
    }
    

    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    tmanager.disable();
    
  }
  
  void fleetStop(){
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
    for(Boat boat in boats){
      //hide menues for each boat 
      boat.hide();
    }
  }
  
  void animate(){
    for(Boat boat in boats){
      boat.animate();
    }
    for(Boat boat in removeBoats){
     removeBoat(boat);
    }
    removeBoats.clear();
  }
  

  //creates boat and puts boat in the appropriate list and touchable list 
  void addBoat(var type){
    if(type == 'sardine' || type == 'tuna' || type == 'shark'){
      Boat boat = new Boat(0 , 0, type, fleetAB );
      boats.add(boat);
      touchables.add(boat);
      boatCount++;
    }
    harborArrage();
  }
  
  void removeBoat(Boat boat){
      boats.remove(boat);
      touchables.remove(boat);
      boatCount += -1;
      print(boatCount);
  }
  
  //gives boats position within harbor 
  void harborArrage(){
    num tempStartX;
    num heading;
    if(fleetAB == 'A'){
      tempStartX = 75;
      heading = 0;
    }
    else{
      tempStartX = 925;
      heading = PI;
    }
    num tempCount = 0;
    for(Boat boat in boats){
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
  
  bool animateSellPhase(){
    bool atSellLocal = true;
    num tempStartX;
    num tempStartY;
    num heading;
    
    if(fleetAB == 'A'){
      tempStartX = 75;
      heading = 0;
    }
    else{
      tempStartX = 925;
      heading = PI;
    }
    num tempCount = 0;
      for(Boat boat in boats){
        if(!boat.animateGoTo(tempStartX, 215 + tempCount * 80)){
          atSellLocal = false;
          
        }
        tempCount++;
        boat.soldFish = false;

      }
      //animate();
      return atSellLocal;
  }
  
  
  void animateFishPhaseUnload(var prices) {
    for (Boat boat in boats) {
      if (boat.soldFish) {
        coin += prices[boat.boatType] * (boat.fishCount - boat.oldfishCount);
        boat.soldFish = false;
      }
    }
  }
  
  
  Boat collided(Boat boat){
    for(Boat newBoat in boats){
      if(boat.x != newBoat.x && boat.y != newBoat.y){
        var dist = pow((boat.x - newBoat.x), 2) + pow((boat.y - newBoat.y), 2);
        var rad = boat.img.width;
        if(dist < pow(rad, 2)){
          return newBoat;
        }
      }
    }
    return null;
  }
  

  
  void upgrade(var upgradeVar, num upgradeVal){
    if(upgradeVar == 'speed'){
      speedMult += 1;
    }
    if(upgradeVar == 'capacity'){
      capacityMult += 1;
    }
    for(Boat boat in boats){
      if(upgradeVar == 'speed'){
        boat.speed += upgradeVal;
      }
      else if(upgradeVar == 'capacity'){
        boat.capacity += upgradeVal;
      }
    }
    
    if(upgradeVar == 'reward'){
      Boat newBoat = new Boat(500,400, 'reward', fleetAB);
      boats.add(newBoat);
      touchables.add(newBoat);
      ws.send('outcome:win');
    }
    
    if(upgradeVar == 'park'){
      
    }
  }
  
  num fishCount(var fishType){
    num total = 0;
      for(Boat boat in boats){
        total += boat.fishCount;
      }
    return total;
}
}
