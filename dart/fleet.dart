

part of fwf;


class Fleet  extends TouchLayer{
  var sardineBoatsNum;
  var tunaBoatsNum;
  var sharkBoatsNum;
  var random = new Random();
  List<Boat> sardineBoats = new List<Boat>();
  List<Boat> tunaBoats = new List<Boat>();
  List<Boat> sharkBoats = new List<Boat>();
  var coin;
  var fleetAB;
  
  TouchManager tmanager = new TouchManager();
  
  Fleet(var saBoats, var tBoats, var sBoats, var myCoin, var myfleetAB){
    sardineBoatsNum = saBoats;
    tunaBoatsNum = tBoats;
    sharkBoatsNum = sBoats;
    coin = myCoin;
    
    var tempStartX;
    if(myfleetAB == 'A' || myfleetAB == 'B'){
      fleetAB = myfleetAB;
      if(myfleetAB == 'A'){
        tempStartX = 100;
      }
      else{
        tempStartX = 500;
      }
    }
    else{
      print("error, not valid fleet type");
    }
    for(var i = 0; i < sardineBoatsNum; i++){
      Boat boat = new Boat(tempStartX , 500+ random.nextInt(10) * 30, 'sardine', myfleetAB );
      sardineBoats.add(boat);
      touchables.add(boat);
    }
    for(var i = 0; i < tunaBoatsNum; i++){
      Boat boat = new Boat(tempStartX , 500 + random.nextInt(10) * 5, 'tuna', myfleetAB);
      tunaBoats.add(boat);
      touchables.add(boat);
    }
    for(var i = 0; i < sharkBoatsNum; i++){
      Boat boat = new Boat(tempStartX, 500 + random.nextInt(10) * 15, 'shark', myfleetAB);
      sharkBoats.add(boat);
      touchables.add(boat);
    }
    

    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
  }
  
  void draw(CanvasRenderingContext2D ctx,num height,num width){
    for(Boat boat in sardineBoats){
      boat.draw(ctx, height, width);
    }
    for(Boat boat in tunaBoats){
      boat.draw(ctx, height, width);
    }
    for(Boat boat in sharkBoats){
      boat.draw(ctx, height, width);
    }
  }
  
  void hide(){
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
  
}