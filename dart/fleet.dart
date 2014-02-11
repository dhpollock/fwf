

part of fwf;


class Fleet  extends TouchLayer{
  //number of boats for each type 
  var sardineBoatsNum;
  var tunaBoatsNum;
  var sharkBoatsNum;
  var random = new Random();
  
  //multiple boats of each type
  List<Boat> sardineBoats = new List<Boat>();
  List<Boat> tunaBoats = new List<Boat>();
  List<Boat> sharkBoats = new List<Boat>();
  
  //amount of money 
  num coin;
  
  //which fleet type either A or B
  var fleetAB;
  
  //number of boats in fleet 
  num boatCount;
  
  TouchManager tmanager = new TouchManager();
  
  Fleet(var saBoats, var tBoats, var sBoats, var myCoin, var myfleetAB){
    sardineBoatsNum = saBoats;
    tunaBoatsNum = tBoats;
    sharkBoatsNum = sBoats;
    coin = myCoin;
    
    num tempStartX;
    if(myfleetAB == 'A' || myfleetAB == 'B'){
      fleetAB = myfleetAB;
      if(myfleetAB == 'A'){
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
  
  //draw all boats 
  void draw(CanvasRenderingContext2D ctx, num width, num height){
    for(Boat boat in sardineBoats){
      boat.draw(ctx, width, height);
    }
    for(Boat boat in tunaBoats){
      boat.draw(ctx, width, height);
    }
    for(Boat boat in sharkBoats){
      boat.draw(ctx, width, height);
    }
  }
  
  void show(){
    tmanager.enable();
  }
  
  void hide(){
    tmanager.disable();
    for(Boat boat in sardineBoats){
      //hide menues for each boat 
      boat.hide();
    }
    for(Boat boat in tunaBoats){
      boat.hide();
    }
    for(Boat boat in sharkBoats){
      boat.hide();
    }
  }
  
  void animate(){
    for(Boat boat in sardineBoats){
      boat.animate();
    }
    for(Boat boat in tunaBoats){
      boat.animate();
    }
    for(Boat boat in sharkBoats){
      boat.animate();
    }
  }
  

  //creates boat and puts boat in the appropriate list and touchable list 
  void addBoat(var type){
    if(type == 'sardine'){
      Boat boat = new Boat(0 , 0, 'sardine', fleetAB );
      sardineBoats.add(boat);
      touchables.add(boat);
      boatCount++;
    }
    else if(type == 'tuna'){
      Boat boat = new Boat(0 , 0, 'tuna', fleetAB );
      tunaBoats.add(boat);
      touchables.add(boat);
      boatCount++;
    }
    else if(type == 'shark'){
      Boat boat = new Boat(0 , 0, 'shark', fleetAB );
      sharkBoats.add(boat);
      touchables.add(boat);
      boatCount++;
    }
    harborArrage();
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
    for(Boat boat in sardineBoats){
      boat.x = tempStartX;
      boat.y = 215 + tempCount * 80;
      boat.heading = heading;
      boat.clearPath();
      boat.fishCount = 0;
      tempCount++;
    }
    for(Boat boat in tunaBoats){
      boat.x = tempStartX;
      boat.y = 215 + tempCount * 80;
      boat.heading = heading;
      boat.clearPath();
      boat.fishCount = 0;
      tempCount++;
    }    
    for(Boat boat in sharkBoats){
      boat.x = tempStartX;
      boat.y = 215 + tempCount * 80;
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
      for(Boat boat in sardineBoats){
        if(!boat.animateGoTo(tempStartX, 215 + tempCount * 80)){
          atSellLocal = false;
          
        }
        tempCount++;
        boat.sold = false;

      }
      for(Boat boat in tunaBoats){
        if(!boat.animateGoTo(tempStartX, 215 + tempCount * 80)){
          atSellLocal = false;
        }
        tempCount++;
        boat.sold = false;
      }    
      for(Boat boat in sharkBoats){
        if(!boat.animateGoTo(tempStartX, 215 + tempCount * 80)){
          atSellLocal = false;
        }
        tempCount++;
        boat.sold = false;
      }
      //animate();
      return atSellLocal;
  }
  
  bool animateSellPhaseUnload(num sardinePrice,num tunaPrice,num sharkPrice){
    for(Boat boat in sardineBoats){
      if(!boat.sold){
        boat.animateSellFish(sardinePrice);
        return false;
      }
      else{
        coin += sardinePrice * boat.fishCount;
        boat.fishCount = 0;
      }
    }
    for(Boat boat in tunaBoats){
      if(!boat.sold){
        boat.animateSellFish(tunaPrice);
        return false;
      }
      else{
        coin += tunaPrice * boat.fishCount;
        boat.fishCount = 0;
      }
    }
    for(Boat boat in sharkBoats){
      if(!boat.sold){
        boat.animateSellFish(sharkPrice);
        return false;
      }
      else{
        coin += sharkPrice * boat.fishCount;
        boat.fishCount = 0;
      }
    }
    
    return true;
  }
  
  
  Boat collided(Boat boat){
    for(Boat sardine in sardineBoats){
      if(boat.x != sardine.x && boat.y != sardine.y){
        var dist = pow((boat.x - sardine.x), 2) + pow((boat.y - sardine.y), 2);
        var rad = boat.img.width;
        if(dist < pow(rad, 2)){
          return sardine;
        }
      }
    }
    for(Boat tuna in tunaBoats){
      if(boat.x != tuna.x && boat.y != tuna.y){
        var dist = pow((boat.x - tuna.x), 2) + pow((boat.y - tuna.y), 2);
        var rad = boat.img.width;
        if(dist < pow(rad, 2)){
          return tuna;
        }
      }
    }
    for(Boat shark in sharkBoats){
      if(boat.x != shark.x && boat.y != shark.y){
        var dist = pow((boat.x - shark.x), 2) + pow((boat.y - shark.y), 2);
        var rad = boat.img.width;
        if(dist < pow(rad, 2)){
          return shark;
        }
      }
    }
    return null;
  }
  
  void upgrade(var upgrade, num upgradeVal){
    for(Boat boat in sardineBoats){
      if(upgrade == 'speed'){
        boat.speed += upgradeVal;
      }
      else if(upgrade == 'capacity'){
        boat.capacity += upgradeVal;
      }
    }
    for(Boat boat in tunaBoats){
      if(upgrade == 'speed'){
        boat.speed += upgradeVal;
      }
      else if(upgrade == 'capacity'){
        boat.capacity += upgradeVal;
      }
    }
    for(Boat boat in sharkBoats){
      if(upgrade == 'speed'){
        boat.speed += upgradeVal;
      }
      else if(upgrade == 'capacity'){
        boat.capacity += upgradeVal;
      }
    } 
  }
  
}