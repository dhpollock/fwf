

part of fwf;


class Fleet  extends TouchLayer{
  var sardineBoatsNum;
  var tunaBoatsNum;
  var sharkBoatsNum;
  var random = new Random();
  List<Boat> sardineBoats = new List<Boat>();
  List<Boat> tunaBoats = new List<Boat>();
  List<Boat> sharkBoats = new List<Boat>();
  num coin;
  var fleetAB;
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
    
    boatCount = 0;
    for(var i = 0; i < sardineBoatsNum; i++){
      Boat boat = new Boat(tempStartX , 215 + boatCount * 80, 'sardine', myfleetAB );
      sardineBoats.add(boat);
      touchables.add(boat);
      boatCount++;
    }
    for(var i = 0; i < tunaBoatsNum; i++){
      Boat boat = new Boat(tempStartX , 215 + boatCount * 80, 'tuna', myfleetAB);
      tunaBoats.add(boat);
      touchables.add(boat);
      boatCount++;
    }
    for(var i = 0; i < sharkBoatsNum; i++){
      Boat boat = new Boat(tempStartX, 215 + boatCount * 80, 'shark', myfleetAB);
      sharkBoats.add(boat);
      touchables.add(boat);
      boatCount++;
    }
    

    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    tmanager.disable();
    
  }
  
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
    repaint();
  }
  
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
      tempCount++;
    }
    for(Boat boat in tunaBoats){
      boat.x = tempStartX;
      boat.y = 215 + tempCount * 80;
      boat.heading = heading;
      boat.clearPath();
      tempCount++;
    }    for(Boat boat in sharkBoats){
      boat.x = tempStartX;
      boat.y = 215 + tempCount * 80;
      boat.heading = heading;
      boat.clearPath();
      tempCount++;
    }
    
  }
  
}