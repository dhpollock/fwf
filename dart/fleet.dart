

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
  
  TouchManager tmanager = new TouchManager();
  
  Fleet(var saBoats, var tBoats, var sBoats, var myCoin){
    sardineBoatsNum = saBoats;
    tunaBoatsNum = tBoats;
    sharkBoatsNum = sBoats;
    coin = myCoin;
    
    for(var i = 0; i < sardineBoatsNum; i++){
      Boat boat = new Boat(100 + random.nextInt(10) * 30, 600, 'sardine');
      sardineBoats.add(boat);
      touchables.add(boat);
    }
    for(var i = 0; i < tunaBoatsNum; i++){
      Boat boat = new Boat(100 + random.nextInt(10) * 5, 600, 'tuna');
      tunaBoats.add(boat);
      touchables.add(boat);
    }
    for(var i = 0; i < sharkBoatsNum; i++){
      Boat boat = new Boat(100 + random.nextInt(10) * 15, 600, 'shark');
      sharkBoats.add(boat);
      touchables.add(boat);
    }
    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
  }
  
  void draw(CanvasRenderingContext2D ctx){
    for(Boat boat in sardineBoats){
      boat.draw(ctx);
    }
    for(Boat boat in tunaBoats){
      boat.draw(ctx);
    }
    for(Boat boat in sharkBoats){
      boat.draw(ctx);
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