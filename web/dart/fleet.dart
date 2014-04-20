part of fwf;

class Fleet extends stagexl.Sprite{
  
  static const SARDINE = 1;
  static const TUNA = 2;
  static const SHARK = 3;
  
  static const TEAMA = 0;
  static const TEAMB = 1;
  
  stagexl.ResourceManager _resourceManager;
  stagexl.Juggler _juggler;
  Game _game;
  
  int teamValue;
  
  List<Boat> _boats;
  var boatCount = {
    SARDINE  : 0,
    TUNA : 0,
    SHARK  : 0
  };
  int coin;
  
  Fleet(this._resourceManager, this._juggler, this._game, int SardineBoatCount, int TunaBoatCount, int SharkBoatCount, this.coin, this.teamValue){
    _boats = new List<Boat>();
    boatCount[SARDINE] = SardineBoatCount;
    boatCount[TUNA] = TunaBoatCount;
    boatCount[SHARK] = SharkBoatCount;
    
    for(int i = 0; i < boatCount[SARDINE]; i++){
      addBoat(SARDINE, this.teamValue);
    }
            
  }
  
  addBoat(int boatType, int fleetType){
    Boat newBoat = new Boat(_resourceManager.getBitmapData("${boatString(boatType, fleetType)}"),_resourceManager, _juggler, _game, _game.random.nextInt(_game.width), _game.random.nextInt(_game.height), boatType ,fleetType);
    _boats.add(newBoat);
  }
  
  enableFishing(){
    for(Boat boat in _boats){
      addChild(boat);
      _game.tlayer.touchables.add(boat);
      _juggler.add(boat);
    }
  }
  
  disableFishing(){
    for(Boat boat in _boats){
      removeChild(boat);
      _game.tlayer.touchables.remove(boat);
      _juggler.remove(boat);
    }
  }
  
  
  String boatString(num boatType, num fleetType){
    String name;
    String fleet;
    String type;
    if(fleetType == TEAMA) fleet = "A";
    if(fleetType == TEAMB) fleet = "B";
    
    if(boatType == SARDINE) type = "Sardine";
    if(boatType == TUNA) type = "Tuna";
    if(boatType == SHARK) type = "Shark";
        
    name = "boat${type}${fleet}";
    return name;
  }
}