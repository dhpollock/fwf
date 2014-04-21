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
      addBoat(SARDINE, teamValue);
    }
    for(int i = 0; i < boatCount[SARDINE]; i++){
      addBoat(TUNA, teamValue);
    }
    for(int i = 0; i < boatCount[SARDINE]; i++){
      addBoat(SHARK, teamValue);
    }
            
  }
  
  addBoat(int boatType, int fleetType){
    Boat newBoat = new Boat(_resourceManager, _juggler, _game, _game.random.nextInt(_game.width), _game.random.nextInt(_game.height), boatType ,fleetType);
    _boats.add(newBoat);
  }
  
  enableFishing(){
    for(Boat boat in _boats){
      addChild(boat);
      _game.tlayer.touchables.add(boat);
      _juggler.add(boat);
      addChild(boat.myNet);
      _juggler.add(boat.myNet);
    }
  }
  
  disableFishing(){
    for(Boat boat in _boats){
      //removeChild(boat);
      _game.tlayer.touchables.remove(boat);
      //_juggler.remove(boat);
    }
  }
  
  harborArrange(){
    num dock1 = 0;
    num dock2 = 1;
    num dock3 = 2;
    
    var dockLocations;
    
    
    if(teamValue == TEAMA){
      dockLocations = {
        dock1 : [_game.width/2 - 125,_game.height/2 - 200, -1.90],
        dock2 : [_game.width/2 - 230,_game.height/2 - 10, -2.65],
        dock3 : [_game.width/2 - 210,_game.height/2 + 175, -3.6],
      };
    }
    else if(teamValue == TEAMB){
      dockLocations = {
        dock1 : [_game.width/2 + 145,_game.height/2-100, -PI/6],
        dock2 : [_game.width/2 + 165,_game.height/2 + 75, PI/7],
        dock3 : [_game.width/2 + 60,_game.height/2 + 235, 1.4],
      };
    }
    
    for(int i = 0; i < _boats.length; i++){
      _boats[i].x = dockLocations[i][0];
      _boats[i].y = dockLocations[i][1];
      _boats[i].rotation = dockLocations[i][2];
      
      _game.tlayer.touchables.remove(_boats[i]);
    }
    
    
  }
  
  

}